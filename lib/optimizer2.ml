(* optimzer2.ml：用于处理IR层次上的优化 *)
open Ir
open Tool

let remove_adjacent_jumps (instructions : instruction list) : instruction list =
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_J l1 :: IR_J l2 :: rest when l1 = l2 ->
        aux acc (IR_J l1 :: rest)  (* 合并连续的跳转 *)
    | IR_J l1 :: IR_Label l2 :: rest when l1 = l2 ->
        aux acc (IR_Label l2 :: rest)  (* 跳转到标签的情况 *)
    | instr :: rest ->
        aux (instr :: acc) rest
  in
  aux [] instructions
;;

(* 将无效算术/移动/调整指令化简为更短的形式，或删除 *)
let simplify_noop_instructions (instructions : instruction list) : instruction list =
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_Add (rd, rs1, Imm 0) :: rest ->
        if rd = rs1 then aux acc rest else aux (IR_Mv (rd, rs1) :: acc) rest
    | IR_Sub (rd, rs1, Imm 0) :: rest ->
        if rd = rs1 then aux acc rest else aux (IR_Mv (rd, rs1) :: acc) rest
    | IR_Slli (rd, rs, 0) :: rest ->
        if rd = rs then aux acc rest else aux (IR_Mv (rd, rs) :: acc) rest
    | IR_Srli (rd, rs, 0) :: rest ->
        if rd = rs then aux acc rest else aux (IR_Mv (rd, rs) :: acc) rest
    | IR_Mv (rd, rs) :: rest when rd = rs ->
        aux acc rest
    | IR_Adjust_SP 0 :: rest ->
        aux acc rest
    | instr :: rest -> aux (instr :: acc) rest
  in
  aux [] instructions
;;


let collect_used_labels (instructions : instruction list) : string list =
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_J l          :: rest -> aux (l :: acc) rest
    | IR_Beqz (_, l)  :: rest -> aux (l :: acc) rest
    | IR_Bnez (_, l)  :: rest -> aux (l :: acc) rest
    | IR_Beq (_, _, l):: rest -> aux (l :: acc) rest
    | IR_Bne (_, _, l):: rest -> aux (l :: acc) rest
    | IR_Blt (_, _, l):: rest -> aux (l :: acc) rest
    | IR_Bge (_, _, l):: rest -> aux (l :: acc) rest
    | _               :: rest -> aux acc rest
  in
  aux [] instructions
;;

let remove_dead_labels (instructions : instruction list) : instruction list =
  let labels = collect_used_labels instructions in
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_Label l :: rest ->
        if List.mem l labels then
          aux (IR_Label l :: acc) rest  (* 保留存在的标签 *)
        else
          aux acc rest  (* 跳过不存在的标签 *)
    | instr :: rest ->
        aux (instr :: acc) rest  (* 保留存在的标签 *)
  in
  aux [] instructions
;;

(* 基本块划分（以标签为块头，并在控制流终结指令后截断） *)
let split_basic_blocks (instructions : instruction list) : (instruction list) list =
  let is_terminator = function
    | IR_J _ | IR_Ret
    | IR_Beq _ | IR_Bne _ | IR_Blt _ | IR_Bge _
    | IR_Beqz _ | IR_Bnez _ -> true
    | _ -> false
  in
  let rec aux acc cur = function
    | [] -> List.rev (List.rev cur :: acc)
    | (IR_Label _ as l) :: rest ->
        let acc' = if cur = [] then acc else (List.rev cur :: acc) in
        aux acc' [l] rest
    | instr :: rest ->
        let cur' = instr :: cur in
        if is_terminator instr then
          aux (List.rev cur' :: acc) [] rest
        else aux acc cur' rest
  in
  match instructions with
  | [] -> []
  | IR_Label _ :: _ -> aux [] [] instructions
  | _ -> aux [] [] (IR_Label "ENTRY" :: instructions)
;;

(* 计算指令的使用与定义寄存器集合 *)
let uses_defs_of_instr (instr: instruction) : (vreg list * vreg list) =
  match instr with
  | IR_Li (d, _) -> ([], [d])
  | IR_Mv (d, s) -> ([s], [d])
  | IR_Add (d, r1, VReg r2) | IR_Sub (d, r1, VReg r2)
  | IR_Mul (d, r1, r2) | IR_Div (d, r1, r2) | IR_Rem (d, r1, r2)
  | IR_Slt (d, r1, r2) | IR_Sgt (d, r1, r2) | IR_Sge (d, r1, r2) -> ([r1; r2], [d])
  | IR_Add (d, r1, Imm _) | IR_Sub (d, r1, Imm _) -> ([r1], [d])
  | IR_Slli (d, s, _) | IR_Srli (d, s, _) -> ([s], [d])
  | IR_Seqz (d, s) | IR_Snez (d, s) -> ([s], [d])
  | IR_Lw (d, _, s) -> ([s], [d])
  | IR_Sw (s, _, base) -> ([s; base], [])
  | IR_Beqz (s, _) | IR_Bnez (s, _) -> ([s], [])
  | IR_Beq (r1, r2, _) | IR_Bne (r1, r2, _) | IR_Blt (r1, r2, _) | IR_Bge (r1, r2, _) -> ([r1; r2], [])
  | IR_Load_Callee_Stack_Arg (d, _) -> ([], [d])
  | IR_Call _ -> ([], [1])
  | IR_Ret | IR_Label _ | IR_Comment _ | IR_Adjust_SP _ | IR_Push_Caller_Stack_Arg _
  | IR_J _ | IR_T_reg_save _ | IR_T_reg_restore _ -> ([], [])
;;

let has_side_effect = function
  | IR_Sw _ | IR_Call _ | IR_Adjust_SP _ | IR_Push_Caller_Stack_Arg _ | IR_J _ | IR_Ret
  | IR_Beq _ | IR_Bne _ | IR_Blt _ | IR_Bge _ | IR_Beqz _ | IR_Bnez _ | IR_T_reg_save _ | IR_T_reg_restore _
  | IR_Label _ -> true
  | _ -> false
;;

let is_protected_def d = d >= 0 && d <= 8 (* 保留预涂色/ABI关键 vreg 定义 *)
;;

(* 基本块内 DCE（自底向上活跃性） *)
let dce_block (block: instruction list) : instruction list =
  let live = ref [] in
  let add_live r = if not (List.mem r !live) then live := r :: !live in
  let remove_live r = live := List.filter ((<>) r) !live in
  let is_live r = List.mem r !live in
  let rec pass acc = function
    | [] -> acc
    | instr :: rest ->
        let uses, defs = uses_defs_of_instr instr in
        let keep =
          has_side_effect instr || List.exists is_live defs || List.exists is_protected_def defs
        in
        let acc' = if keep then instr :: acc else acc in
        List.iter add_live uses;
        List.iter remove_live defs;
        pass acc' rest
  in
  List.rev (pass [] (List.rev block))
;;

let run_local_dce (instructions: instruction list) : instruction list =
  split_basic_blocks instructions
  |> List.map dce_block
  |> List.flatten
;;

(* ---------------- 控制流优化：跳转链折叠与分支反转 ---------------- *)
(* 构建 label -> 其后若为单条无副作用的 j t 则映射到 t 的表（并做链式收敛） *)
let build_label_jump_chain (instructions: instruction list) : (string, string) Hashtbl.t =
  let map = Hashtbl.create 32 in
  let rec scan = function
    | IR_Label l :: rest ->
        let rec next_sig = function
          | IR_Comment _ :: xs -> next_sig xs
          | (IR_J t) :: _ -> Some t
          | _ -> None
        in
        (match next_sig rest with
        | Some t -> Hashtbl.replace map l t
        | None -> ());
        scan rest
    | _ :: rest -> scan rest
    | [] -> ()
  in
  scan instructions;
  (* 收敛：l -> t1, t1 -> t2 ... → l -> tn *)
  let rec resolve l =
    match Hashtbl.find_opt map l with
    | Some t when t <> l -> resolve t
    | _ -> l
  in
  Hashtbl.iter (fun l _ -> Hashtbl.replace map l (resolve l)) map;
  map
;;

let redirect_jumps_using_chain (instructions: instruction list) : instruction list =
  let chain = build_label_jump_chain instructions in
  let resolve l = match Hashtbl.find_opt chain l with Some t -> t | None -> l in
  List.map (function
    | IR_J l -> IR_J (resolve l)
    | IR_Beqz (s, l) -> IR_Beqz (s, resolve l)
    | IR_Bnez (s, l) -> IR_Bnez (s, resolve l)
    | IR_Beq (a, b, l) -> IR_Beq (a, b, resolve l)
    | IR_Bne (a, b, l) -> IR_Bne (a, b, resolve l)
    | IR_Blt (a, b, l) -> IR_Blt (a, b, resolve l)
    | IR_Bge (a, b, l) -> IR_Bge (a, b, resolve l)
    | x -> x
  ) instructions
;;

let invert_branch_to_remove_fallthrough_jump (instructions: instruction list) : instruction list =
  let rec aux acc = function
    | IR_Beqz (s, l1) :: IR_J l2 :: IR_Label l1' :: rest when l1 = l1' ->
        aux (IR_Bnez (s, l2) :: IR_Label l1 :: acc) rest
    | IR_Bnez (s, l1) :: IR_J l2 :: IR_Label l1' :: rest when l1 = l1' ->
        aux (IR_Beqz (s, l2) :: IR_Label l1 :: acc) rest
    | x :: xs -> aux (x :: acc) xs
    | [] -> List.rev acc
  in
  aux [] instructions
;;

(* ---------------- 跨块常量/拷贝传播：数据流分析与基于 IN 的替换 ---------------- *)
module IMap = Map.Make(Int)

type value = [ `Const of int | `Copy of vreg | `Unknown ]
type env = value IMap.t

let env_lookup r (e:env) = try IMap.find r e with Not_found -> `Unknown
let env_set r v (e:env) = IMap.add r v e

let rec resolve_copy_in_env (e:env) (r:vreg) : vreg =
  match env_lookup r e with
  | `Copy r' when r' <> r -> resolve_copy_in_env e r'
  | _ -> r

let join_value (a:value) (b:value) : value = if a = b then a else `Unknown

let join_env (a:env) (b:env) : env =
  let all_keys =
    IMap.fold (fun k _ acc -> k :: acc) a []
    |> List.fold_left (fun acc k -> if List.mem k acc then acc else k :: acc)
         (IMap.fold (fun k _ acc -> k :: acc) b [])
  in
  List.fold_left (fun acc k ->
    let va = env_lookup k a in
    let vb = env_lookup k b in
    env_set k (join_value va vb) acc
  ) IMap.empty all_keys

(* 构建 CFG：块列表、label->index、succ 列表 *)
let build_cfg (blocks: instruction list list) : (int list array * (string, int) Hashtbl.t) =
  let n = List.length blocks in
  let label_to_block = Hashtbl.create 32 in
  List.iteri (fun idx block ->
    match block with IR_Label l :: _ -> Hashtbl.replace label_to_block l idx | _ -> ()
  ) blocks;
  let succ = Array.make n [] in
  List.iteri (fun i block ->
    match List.rev block with
    | last :: _ -> (
        match last with
        | IR_J l ->
            (match Hashtbl.find_opt label_to_block l with
            | Some idx -> succ.(i) <- [idx]
            | None -> succ.(i) <- [])
        | IR_Beqz (_, l) | IR_Bnez (_, l) | IR_Beq (_, _, l) | IR_Bne (_, _, l)
        | IR_Blt (_, _, l) | IR_Bge (_, _, l) ->
            let t_opt = Hashtbl.find_opt label_to_block l in
            let fall = if i + 1 < n then [i + 1] else [] in
            (match t_opt with
            | Some t -> succ.(i) <- t :: fall
            | None -> succ.(i) <- fall)
        | IR_Ret -> succ.(i) <- []
        | _ -> if i + 1 < n then succ.(i) <- [i + 1] else ()
      )
    | [] -> if i + 1 < n then succ.(i) <- [i + 1] else ()
  ) blocks;
  (succ, label_to_block)

(* 块传递函数：给定 IN 环境，计算 OUT *)
let transfer_block (in_env:env) (block:instruction list) : env =
  let e = ref in_env in
  let set_unknown d = e := env_set d `Unknown !e in
  let set_const d i = e := env_set d (`Const i) !e in
  let set_copy d s = e := env_set d (`Copy s) !e in
  let get r = env_lookup r !e in
  let step = function
    | IR_Li (d, i) -> set_const d i
    | IR_Mv (d, s) -> (match get s with `Const v -> set_const d v | `Copy r' -> set_copy d r' | _ -> set_copy d s)
    | IR_Add (d, r1, Imm n) -> (match get r1 with `Const v -> set_const d (v + n) | `Copy r1' -> set_copy d r1' | _ -> set_unknown d)
    | IR_Sub (d, r1, Imm n) -> (match get r1 with `Const v -> set_const d (v - n) | `Copy r1' -> set_copy d r1' | _ -> set_unknown d)
    | IR_Add (d, r1, VReg r2) -> (match get r1, get r2 with `Const a, `Const b -> set_const d (a + b) | _ -> set_unknown d)
    | IR_Sub (d, r1, VReg r2) -> (match get r1, get r2 with `Const a, `Const b -> set_const d (a - b) | _ -> set_unknown d)
    | IR_Mul (d, r1, r2) -> (match get r1, get r2 with `Const a, `Const b -> set_const d (a * b) | _ -> set_unknown d)
    | IR_Div (d, r1, r2) -> (match get r1, get r2 with `Const a, `Const b when b <> 0 -> set_const d (a / b) | _ -> set_unknown d)
    | IR_Rem (d, r1, r2) -> (match get r1, get r2 with `Const a, `Const b when b <> 0 -> set_const d (a mod b) | _ -> set_unknown d)
    | IR_Seqz (d, s) -> (match get s with `Const v -> set_const d (if v = 0 then 1 else 0) | _ -> set_unknown d)
    | IR_Snez (d, s) -> (match get s with `Const v -> set_const d (if v <> 0 then 1 else 0) | _ -> set_unknown d)
    | IR_Slli (d, s, k) -> (match get s with `Const v -> set_const d (v lsl k) | _ -> set_unknown d)
    | IR_Srli (d, s, k) -> (match get s with `Const v -> set_const d (v lsr k) | _ -> set_unknown d)
    | IR_Lw (d, _, _) | IR_Load_Callee_Stack_Arg (d, _) -> set_unknown d
    | IR_Call _ -> e := env_set 1 `Unknown !e
    | _ -> ()
  in
  List.iter step block; !e

(* 迭代求解 IN/OUT 环境 *)
let solve_dataflow (blocks:instruction list list) : env array * env array =
  let n = List.length blocks in
  let (succ, _) = build_cfg blocks in
  let in_envs = Array.make n IMap.empty in
  let out_envs = Array.make n IMap.empty in
  let changed = ref true in
  while !changed do
    changed := false;
    for i = 0 to n - 1 do
      (* IN = join of predecessors' OUT *)
      let preds =
        let ps = ref [] in
        for j = 0 to n - 1 do
          if List.mem i succ.(j) then ps := j :: !ps
        done; !ps
      in
      let in_e =
        match preds with
        | [] -> in_envs.(i)
        | p :: rest -> List.fold_left (fun acc k -> join_env acc out_envs.(k)) out_envs.(p) rest
      in
      if in_e <> in_envs.(i) then (in_envs.(i) <- in_e; changed := true);
      let out_e = transfer_block in_envs.(i) (List.nth blocks i) in
      if out_e <> out_envs.(i) then (out_envs.(i) <- out_e; changed := true)
    done
  done;
  (in_envs, out_envs)

(* 基于 IN 环境重写块（常量/拷贝传播与折叠） *)
let rewrite_blocks_with_env (blocks:instruction list list) (in_envs:env array) : instruction list =
  let rewrite_block i block : instruction list =
    let env_tbl : (vreg, value) Hashtbl.t = Hashtbl.create 32 in
    (* 种下 IN 环境 *)
    IMap.iter (fun k v -> Hashtbl.replace env_tbl k v) in_envs.(i);
    let get v = match Hashtbl.find_opt env_tbl v with Some x -> x | None -> `Unknown in
    let set_unknown v = Hashtbl.replace env_tbl v `Unknown in
    let set_const v i = Hashtbl.replace env_tbl v (`Const i) in
    let set_copy v r = Hashtbl.replace env_tbl v (`Copy r) in
    let subst_vreg r = match get r with `Copy r' -> r' | _ -> r in
    let out = ref [] in
    let emit x = out := x :: !out in
    let rec loop = function
      | [] -> ()
      | IR_Label _ as l :: rest -> emit l; loop rest
      | IR_Li (d, i) :: rest -> set_const d i; emit (IR_Li (d, i)); loop rest
      | IR_Mv (d, s) :: rest ->
          (match get s with `Const v -> set_const d v; emit (IR_Li (d, v))
                          | `Copy r' -> if d <> r' then (set_copy d r'; emit (IR_Mv (d, r'))) else ()
                          | _ -> if d <> s then (set_copy d s; emit (IR_Mv (d, s))) else ());
          loop rest
      | IR_Add (d, r1, Imm n) :: rest ->
          (match get r1 with
          | `Const v -> set_const d (v + n); emit (IR_Li (d, v + n))
          | `Copy r1' -> if n = 0 then (set_copy d r1'; emit (IR_Mv (d, r1'))) else (emit (IR_Add (d, r1', Imm n)); set_unknown d)
          | _ -> if n = 0 then (set_copy d r1; emit (IR_Mv (d, r1))) else (emit (IR_Add (d, r1, Imm n)); set_unknown d));
          loop rest
      | IR_Sub (d, r1, Imm n) :: rest ->
          (match get r1 with
          | `Const v -> set_const d (v - n); emit (IR_Li (d, v - n))
          | `Copy r1' -> if n = 0 then (set_copy d r1'; emit (IR_Mv (d, r1'))) else (emit (IR_Sub (d, r1', Imm n)); set_unknown d)
          | _ -> if n = 0 then (set_copy d r1; emit (IR_Mv (d, r1))) else (emit (IR_Sub (d, r1, Imm n)); set_unknown d));
          loop rest
      | IR_Add (d, r1, VReg r2) :: rest ->
          let r1' = subst_vreg r1 in
          (match get r2 with
          | `Const c when is_12bit c -> emit (IR_Add (d, r1', Imm c)); set_unknown d
          | `Copy r2' -> emit (IR_Add (d, r1', VReg r2')); set_unknown d
          | `Const _ | `Unknown -> emit (IR_Add (d, r1', VReg r2)); set_unknown d);
          loop rest
      | IR_Sub (d, r1, VReg r2) :: rest ->
          let r1' = subst_vreg r1 in
          (match get r2 with
          | `Const c when is_12bit c -> emit (IR_Sub (d, r1', Imm c)); set_unknown d
          | `Copy r2' -> emit (IR_Sub (d, r1', VReg r2')); set_unknown d
          | `Const _ | `Unknown -> emit (IR_Sub (d, r1', VReg r2)); set_unknown d);
          loop rest
      | IR_Slt (d, r1, r2) :: rest -> emit (IR_Slt (d, subst_vreg r1, subst_vreg r2)); set_unknown d; loop rest
      | IR_Sgt (d, r1, r2) :: rest -> emit (IR_Sgt (d, subst_vreg r1, subst_vreg r2)); set_unknown d; loop rest
      | IR_Sge (d, r1, r2) :: rest -> emit (IR_Sge (d, subst_vreg r1, subst_vreg r2)); set_unknown d; loop rest
      | IR_Mul (d, r1, r2) :: rest ->
          (match get r1, get r2 with `Const a, `Const b -> set_const d (a * b); emit (IR_Li (d, a * b))
                                   | _ -> emit (IR_Mul (d, subst_vreg r1, subst_vreg r2)); set_unknown d);
          loop rest
      | IR_Div (d, r1, r2) :: rest ->
          (match get r1, get r2 with `Const _, `Const 0 -> emit (IR_Div (d, subst_vreg r1, subst_vreg r2)); set_unknown d
                                   | `Const a, `Const b -> set_const d (a / b); emit (IR_Li (d, a / b))
                                   | _ -> emit (IR_Div (d, subst_vreg r1, subst_vreg r2)); set_unknown d);
          loop rest
      | IR_Rem (d, r1, r2) :: rest ->
          (match get r1, get r2 with `Const _, `Const 0 -> emit (IR_Rem (d, subst_vreg r1, subst_vreg r2)); set_unknown d
                                   | `Const a, `Const b -> set_const d (a mod b); emit (IR_Li (d, a mod b))
                                   | _ -> emit (IR_Rem (d, subst_vreg r1, subst_vreg r2)); set_unknown d);
          loop rest
      | IR_Seqz (d, s) :: rest -> (match get s with `Const v -> set_const d (if v = 0 then 1 else 0); emit (IR_Li (d, if v = 0 then 1 else 0))
                                               | _ -> emit (IR_Seqz (d, subst_vreg s)); set_unknown d); loop rest
      | IR_Snez (d, s) :: rest -> (match get s with `Const v -> set_const d (if v <> 0 then 1 else 0); emit (IR_Li (d, if v <> 0 then 1 else 0))
                                               | _ -> emit (IR_Snez (d, subst_vreg s)); set_unknown d); loop rest
      | IR_Slli (d, s, k) :: rest -> (match get s with `Const v -> set_const d (v lsl k); emit (IR_Li (d, v lsl k))
                                               | _ -> emit (IR_Slli (d, subst_vreg s, k)); set_unknown d); loop rest
      | IR_Srli (d, s, k) :: rest -> (match get s with `Const v -> set_const d (v lsr k); emit (IR_Li (d, v lsr k))
                                               | _ -> emit (IR_Srli (d, subst_vreg s, k)); set_unknown d); loop rest
      | IR_Lw (d, off, base) :: rest -> emit (IR_Lw (d, off, subst_vreg base)); set_unknown d; loop rest
      | IR_Sw (s, off, base) :: rest -> emit (IR_Sw (subst_vreg s, off, subst_vreg base)); loop rest
      | IR_Beqz (s, l) :: rest -> (match get s with `Const 0 -> emit (IR_J l) | `Const _ -> () | `Copy r' -> emit (IR_Beqz (r', l)) | _ -> emit (IR_Beqz (s, l))); loop rest
      | IR_Bnez (s, l) :: rest -> (match get s with `Const 0 -> () | `Const _ -> emit (IR_J l) | `Copy r' -> emit (IR_Bnez (r', l)) | _ -> emit (IR_Bnez (s, l))); loop rest
      | IR_Beq (r1, r2, l) :: rest ->
          (match get r1, get r2 with `Const a, `Const b -> if a = b then emit (IR_J l) else ()
                                   | `Copy a, `Unknown -> emit (IR_Beq (a, r2, l))
                                   | `Unknown, `Copy b -> emit (IR_Beq (r1, b, l))
                                   | `Copy a, `Copy b -> emit (IR_Beq (a, b, l))
                                   | _ -> emit (IR_Beq (r1, r2, l))); loop rest
      | IR_Bne (r1, r2, l) :: rest ->
          (match get r1, get r2 with `Const a, `Const b -> if a <> b then emit (IR_J l) else ()
                                   | `Copy a, `Unknown -> emit (IR_Bne (a, r2, l))
                                   | `Unknown, `Copy b -> emit (IR_Bne (r1, b, l))
                                   | `Copy a, `Copy b -> emit (IR_Bne (a, b, l))
                                   | _ -> emit (IR_Bne (r1, r2, l))); loop rest
      | IR_Blt (r1, r2, l) :: rest -> emit (IR_Blt (subst_vreg r1, subst_vreg r2, l)); loop rest
      | IR_Bge (r1, r2, l) :: rest -> emit (IR_Bge (subst_vreg r1, subst_vreg r2, l)); loop rest
      | IR_Call name :: rest -> set_unknown 1; emit (IR_Call name); loop rest
      | IR_Ret :: rest -> emit IR_Ret; loop rest
      | IR_J l :: rest -> emit (IR_J l); loop rest
      | IR_Adjust_SP i :: rest -> emit (IR_Adjust_SP i); loop rest
      | IR_Push_Caller_Stack_Arg (s, off) :: rest -> emit (IR_Push_Caller_Stack_Arg (subst_vreg s, off)); loop rest
      | IR_Load_Callee_Stack_Arg (d, off) :: rest -> emit (IR_Load_Callee_Stack_Arg (d, off)); set_unknown d; loop rest
      | IR_T_reg_save id :: rest -> emit (IR_T_reg_save id); loop rest
      | IR_T_reg_restore id :: rest -> emit (IR_T_reg_restore id); loop rest
      | IR_Comment _ :: rest -> loop rest
    in
    loop block; List.rev !out
  in
  blocks
  |> List.mapi (fun i b -> rewrite_block i b)
  |> List.flatten
;;

let optimize_program2 (program : program_ir) : program_ir =
  match program with
  | Program_ir funcs ->
      let optimized_funcs = List.map (fun func ->
        let optimized_body = 
          func.body
          |> simplify_noop_instructions
          |> (fun instrs ->
            (* 基本块划分：以标签为块头，将块内做常量/拷贝传播与条件折叠 *)
            let rec to_blocks acc cur = function
              | [] -> List.rev (List.rev cur :: acc)
              | (IR_Label _ as l) :: rest ->
                  (* 新块开始 *)
                  let acc' = if cur = [] then acc else (List.rev cur :: acc) in
                  to_blocks acc' [l] rest
              | instr :: rest -> to_blocks acc (instr :: cur) rest
            in
            let blocks =
              match instrs with
              | [] -> []
              | IR_Label _ :: _ -> to_blocks [] [] instrs
              | _ -> to_blocks [] [] (IR_Label "ENTRY" :: instrs) (* 人工块头，便于统一处理 *)
            in

            let simplify_block (block: instruction list) : instruction list =
              let env : (vreg, [ `Const of int | `Copy of vreg | `Unknown ]) Hashtbl.t = Hashtbl.create 32 in
              let set_unknown v = Hashtbl.replace env v `Unknown in
              let set_const v i = Hashtbl.replace env v (`Const i) in
              let set_copy v r = Hashtbl.replace env v (`Copy r) in
              let get v = match Hashtbl.find_opt env v with Some x -> x | None -> `Unknown in

              let subst_vreg r =
                match get r with
                | `Copy r' -> r'
                | _ -> r
              in

              let out = ref [] in
              let emit i = out := i :: !out in
              let finish () = List.rev !out in

              let rec loop = function
                | [] -> ()
                | IR_Label _ as l :: rest ->
                    (* 块内不会再遇到 label；若遇到，重置环境 *)
                    Hashtbl.reset env; emit l; loop rest
                | IR_Li (d, i) :: rest -> set_const d i; emit (IR_Li (d, i)); loop rest
                | IR_Mv (d, s) :: rest ->
                    (match get s with
                    | `Const i -> set_const d i; emit (IR_Li (d, i))
                    | `Copy r' -> if d = r' then () else (set_copy d r'; emit (IR_Mv (d, r')))
                    | `Unknown -> if d = s then () else (set_copy d s; emit (IR_Mv (d, s))));
                    loop rest
                | IR_Add (d, r1, Imm n) :: rest ->
                    (match get r1 with
                    | `Const v -> set_const d (v + n); emit (IR_Li (d, v + n))
                    | `Copy r1' -> if n = 0 then (set_copy d r1'; emit (IR_Mv (d, r1'))) else (emit (IR_Add (d, r1', Imm n)); set_unknown d)
                    | `Unknown -> if n = 0 then (set_copy d r1; emit (IR_Mv (d, r1))) else (emit (IR_Add (d, r1, Imm n)); set_unknown d));
                    loop rest
                | IR_Sub (d, r1, Imm n) :: rest ->
                    (match get r1 with
                    | `Const v -> set_const d (v - n); emit (IR_Li (d, v - n))
                    | `Copy r1' -> if n = 0 then (set_copy d r1'; emit (IR_Mv (d, r1'))) else (emit (IR_Sub (d, r1', Imm n)); set_unknown d)
                    | `Unknown -> if n = 0 then (set_copy d r1; emit (IR_Mv (d, r1))) else (emit (IR_Sub (d, r1, Imm n)); set_unknown d));
                    loop rest
                | IR_Add (d, r1, VReg r2) :: rest ->
                    let r1' = subst_vreg r1 in
                    (match get r2 with
                    | `Const c when is_12bit c -> emit (IR_Add (d, r1', Imm c)); set_unknown d
                    | `Const _c -> (* 超过12位，保持二寄存器形式 *) emit (IR_Add (d, r1', VReg r2)); set_unknown d
                    | `Copy r2' -> emit (IR_Add (d, r1', VReg r2')); set_unknown d
                    | `Unknown -> emit (IR_Add (d, r1', VReg r2)); set_unknown d);
                    loop rest
                | IR_Sub (d, r1, VReg r2) :: rest ->
                    let r1' = subst_vreg r1 in
                    (match get r2 with
                    | `Const c when is_12bit c -> emit (IR_Sub (d, r1', Imm c)); set_unknown d
                    | `Const _c -> emit (IR_Sub (d, r1', VReg r2)); set_unknown d
                    | `Copy r2' -> emit (IR_Sub (d, r1', VReg r2')); set_unknown d
                    | `Unknown -> emit (IR_Sub (d, r1', VReg r2)); set_unknown d);
                    loop rest
                | IR_Slt (d, r1, r2) :: rest ->
                    emit (IR_Slt (d, subst_vreg r1, subst_vreg r2)); set_unknown d; loop rest
                | IR_Sgt (d, r1, r2) :: rest ->
                    emit (IR_Sgt (d, subst_vreg r1, subst_vreg r2)); set_unknown d; loop rest
                | IR_Sge (d, r1, r2) :: rest ->
                    emit (IR_Sge (d, subst_vreg r1, subst_vreg r2)); set_unknown d; loop rest
                | IR_Mul (d, r1, r2) :: rest ->
                    (match get r1, get r2 with
                    | `Const a, `Const b -> set_const d (a * b); emit (IR_Li (d, a * b))
                    | _ -> emit (IR_Mul (d, subst_vreg r1, subst_vreg r2)); set_unknown d);
                    loop rest
                | IR_Div (d, r1, r2) :: rest ->
                    (match get r1, get r2 with
                    | `Const _, `Const 0 -> emit (IR_Div (d, subst_vreg r1, subst_vreg r2)); set_unknown d
                    | `Const a, `Const b -> set_const d (a / b); emit (IR_Li (d, a / b))
                    | _ -> emit (IR_Div (d, subst_vreg r1, subst_vreg r2)); set_unknown d);
                    loop rest
                | IR_Rem (d, r1, r2) :: rest ->
                    (match get r1, get r2 with
                    | `Const _, `Const 0 -> emit (IR_Rem (d, subst_vreg r1, subst_vreg r2)); set_unknown d
                    | `Const a, `Const b -> set_const d (a mod b); emit (IR_Li (d, a mod b))
                    | _ -> emit (IR_Rem (d, subst_vreg r1, subst_vreg r2)); set_unknown d);
                    loop rest
                | IR_Seqz (d, s) :: rest ->
                    (match get s with
                    | `Const v -> set_const d (if v = 0 then 1 else 0); emit (IR_Li (d, if v = 0 then 1 else 0))
                    | `Copy r' -> emit (IR_Seqz (d, r')); set_unknown d
                    | `Unknown -> emit (IR_Seqz (d, s)); set_unknown d);
                    loop rest
                | IR_Snez (d, s) :: rest ->
                    (match get s with
                    | `Const v -> set_const d (if v <> 0 then 1 else 0); emit (IR_Li (d, if v <> 0 then 1 else 0))
                    | `Copy r' -> emit (IR_Snez (d, r')); set_unknown d
                    | `Unknown -> emit (IR_Snez (d, s)); set_unknown d);
                    loop rest
                | IR_Slli (d, s, k) :: rest ->
                    (match get s with
                    | `Const v -> set_const d (v lsl k); emit (IR_Li (d, v lsl k))
                    | `Copy r' -> emit (IR_Slli (d, r', k)); set_unknown d
                    | `Unknown -> emit (IR_Slli (d, s, k)); set_unknown d);
                    loop rest
                | IR_Srli (d, s, k) :: rest ->
                    (match get s with
                    | `Const v -> set_const d (v lsr k); emit (IR_Li (d, v lsr k))
                    | `Copy r' -> emit (IR_Srli (d, r', k)); set_unknown d
                    | `Unknown -> emit (IR_Srli (d, s, k)); set_unknown d);
                    loop rest
                | IR_Lw (d, off, base) :: rest ->
                    emit (IR_Lw (d, off, subst_vreg base)); set_unknown d; loop rest
                | IR_Sw (s, off, base) :: rest ->
                    emit (IR_Sw (subst_vreg s, off, subst_vreg base)); loop rest
                | IR_Beqz (s, l) :: rest ->
                    (match get s with
                    | `Const 0 -> emit (IR_J l)
                    | `Const _ -> ()
                    | `Copy r' -> emit (IR_Beqz (r', l))
                    | `Unknown -> emit (IR_Beqz (s, l)));
                    loop rest
                | IR_Bnez (s, l) :: rest ->
                    (match get s with
                    | `Const 0 -> ()
                    | `Const _ -> emit (IR_J l)
                    | `Copy r' -> emit (IR_Bnez (r', l))
                    | `Unknown -> emit (IR_Bnez (s, l)));
                    loop rest
                | IR_Beq (r1, r2, l) :: rest ->
                    (match get r1, get r2 with
                    | `Const a, `Const b -> if a = b then emit (IR_J l) else ()
                    | `Copy a, `Unknown -> emit (IR_Beq (a, r2, l))
                    | `Unknown, `Copy b -> emit (IR_Beq (r1, b, l))
                    | `Copy a, `Copy b -> emit (IR_Beq (a, b, l))
                    | _ -> emit (IR_Beq (r1, r2, l)));
                    loop rest
                | IR_Bne (r1, r2, l) :: rest ->
                    (match get r1, get r2 with
                    | `Const a, `Const b -> if a <> b then emit (IR_J l) else ()
                    | `Copy a, `Unknown -> emit (IR_Bne (a, r2, l))
                    | `Unknown, `Copy b -> emit (IR_Bne (r1, b, l))
                    | `Copy a, `Copy b -> emit (IR_Bne (a, b, l))
                    | _ -> emit (IR_Bne (r1, r2, l)));
                    loop rest
                | IR_Blt (r1, r2, l) :: rest -> emit (IR_Blt (subst_vreg r1, subst_vreg r2, l)); loop rest
                | IR_Bge (r1, r2, l) :: rest -> emit (IR_Bge (subst_vreg r1, subst_vreg r2, l)); loop rest
                | IR_Call name :: rest ->
                    (* 调用后 a0(=v1) 被定义，置未知；其他vreg不变 *)
                    set_unknown 1; emit (IR_Call name); loop rest
                | IR_Ret :: rest -> emit IR_Ret; loop rest
                | IR_J l :: rest -> emit (IR_J l); loop rest
                | IR_Adjust_SP i :: rest -> emit (IR_Adjust_SP i); loop rest
                | IR_Push_Caller_Stack_Arg (s, off) :: rest -> emit (IR_Push_Caller_Stack_Arg (subst_vreg s, off)); loop rest
                | IR_Load_Callee_Stack_Arg (d, off) :: rest -> emit (IR_Load_Callee_Stack_Arg (d, off)); set_unknown d; loop rest
                | IR_T_reg_save id :: rest -> emit (IR_T_reg_save id); loop rest
                | IR_T_reg_restore id :: rest -> emit (IR_T_reg_restore id); loop rest
                | IR_Comment _ :: rest -> loop rest
              in
              loop block; finish ()
            in

            let blocks' = List.map simplify_block blocks in
            (* 去掉人工块头 *)
            let flatten =
              match blocks' with
              | [] -> []
              | (IR_Label "ENTRY" :: b1) :: rest_blocks -> b1 @ List.flatten rest_blocks
              | _ -> List.flatten blocks'
            in
            flatten
          )
          |> (fun instrs ->
            (* 合并连续 Adjust_SP *)
            let rec aux acc = function
              | IR_Adjust_SP a :: IR_Adjust_SP b :: rest -> aux acc (IR_Adjust_SP (a + b) :: rest)
              | IR_Adjust_SP 0 :: rest -> aux acc rest
              | instr :: rest -> aux (instr :: acc) rest
              | [] -> List.rev acc
            in
            aux [] instrs)
          |> redirect_jumps_using_chain
          |> invert_branch_to_remove_fallthrough_jump
          |> (fun instrs ->
            (* 跨块常量/拷贝传播与基于 IN 的块内替换，再次 DCE *)
            let blocks = split_basic_blocks instrs in
            let (in_envs, _) = solve_dataflow blocks in
            let rewritten = rewrite_blocks_with_env blocks in_envs in
            run_local_dce rewritten)
          |> remove_adjacent_jumps
          |> remove_dead_labels
        in
        { func with body = optimized_body }
      ) funcs in
      Program_ir optimized_funcs
;;