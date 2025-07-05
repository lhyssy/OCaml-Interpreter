open Ast

let is_power_of_two n =
  n > 0 && (n land (n - 1)) = 0

(* 获取2的幂次 *)
let log2 n =
  if n <= 0 then failwith "log2 of non-positive number"
  else
    let rec aux p i =
      if p = n then i
      else if p > n then failwith (Printf.sprintf "Not a power of 2: %d" n)
      else aux (p * 2) (i + 1)
    in
    aux 1 0

(* 中间表示 (IR) *)
type vreg = int (* 虚拟寄存器 *)

type operand =
  | VReg of vreg
  | Imm of int

type instruction =
  | IR_Label of string
  | IR_Comment of string
  (* Moves *)
  | IR_Li of vreg * int
  | IR_Mv of vreg * vreg
  (* Arithmetic *)
  | IR_Add of vreg * vreg * operand
  | IR_Sub of vreg * vreg * operand
  | IR_Mul of vreg * vreg * vreg
  | IR_Div of vreg * vreg * vreg
  | IR_Rem of vreg * vreg * vreg
  (* Bitwise *)
  | IR_Slli of vreg * vreg * int
  | IR_Srli of vreg * vreg * int
  (* Comparison *)
  | IR_Seqz of vreg * vreg
  | IR_Snez of vreg * vreg
  | IR_Slt of vreg * vreg * vreg
  | IR_Sgt of vreg * vreg * vreg
  | IR_Sge of vreg * vreg * vreg
  (* Memory *)
  | IR_Lw of vreg * int * vreg (* Lw rd, offset(rs1) *)
  | IR_Sw of vreg * int * vreg (* Sw rs1, offset(rd) *)
  (* Control Flow *)
  | IR_J of string
  | IR_Beqz of vreg * string
  | IR_Bnez of vreg * string
  | IR_Call of string
  | IR_Ret

(* 真实寄存器定义 *)
type preg =
  | A0 | A1 | A2 | A3 | A4 | A5 | A6 | A7
  | T0 | T1 | T2 | T3 | T4 | T5 | T6
  | S0 | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10 | S11
  | RA | SP | FP | ZERO

let string_of_preg = function
  | A0 -> "a0" | A1 -> "a1" | A2 -> "a2" | A3 -> "a3"
  | A4 -> "a4" | A5 -> "a5" | A6 -> "a6" | A7 -> "a7"
  | T0 -> "t0" | T1 -> "t1" | T2 -> "t2" | T3 -> "t3"
  | T4 -> "t4" | T5 -> "t5" | T6 -> "t6"
  | S0 -> "s0" | S1 -> "s1" | S2 -> "s2" | S3 -> "s3"
  | S4 -> "s4" | S5 -> "s5" | S6 -> "s6" | S7 -> "s7"
  | S8 -> "s8" | S9 -> "s9" | S10 -> "s10" | S11 -> "s11"
  | RA -> "ra" | SP -> "sp" | FP -> "fp" | ZERO -> "zero"

(* 变量环境 *)
type var_env = {
  vars: (string, vreg) Hashtbl.t; (* 变量名 -> 虚拟寄存器 *)
}

let empty_var_env () = {
  vars = Hashtbl.create 16;
}

let add_var env name vreg =
  Hashtbl.add env.vars name vreg

let find_var env name =
  try Hashtbl.find env.vars name
  with Not_found -> failwith ("Undefined variable: " ^ name)

(* 编译器环境 *)
type compile_env = {
  var_env: var_env;
  mutable vreg_count: int;
  mutable label_count: int;
  mutable current_loop: (string * string) option;
  mutable current_func_return_label: string;
  mutable instructions: instruction list;
}

let init_compile_env () = {
  var_env = empty_var_env ();
  vreg_count = 0;
  label_count = 0;
  current_loop = None;
  current_func_return_label = "";
  instructions = [];
}

let fresh_vreg env =
  let v = env.vreg_count in
  env.vreg_count <- v + 1;
  v

let fresh_label env prefix =
  let l = env.label_count in
  env.label_count <- l + 1;
  prefix ^ "_" ^ string_of_int l

let emit env instr =
  env.instructions <- instr :: env.instructions

(* IR to Assembly *)
let string_of_ir (instrs : instruction list) (vreg_map : (vreg, preg option) Hashtbl.t) =
  let out = Buffer.create 1024 in
  let reg r =
    match Hashtbl.find vreg_map r with
    | Some preg -> string_of_preg preg
    | None -> failwith ("vreg " ^ string_of_int r ^ " was spilled (not implemented)")
  in
  let op_to_s = function
    | VReg r -> reg r
    | Imm i -> string_of_int i
  in
  List.iter (function
    | IR_Label s -> Buffer.add_string out (s ^ ":\n")
    | IR_Comment _ -> ()
    | IR_Li (r, i) -> 
        (* 替换 li 伪指令，对于小的立即数使用 addi，大的立即数仍然使用 li *)
        if i >= -2048 && i <= 2047 then
          Printf.bprintf out "\taddi %s, x0, %d\n" (reg r) i
        else
          Printf.bprintf out "\tli %s, %d\n" (reg r) i
    | IR_Mv (rd, rs) -> Printf.bprintf out "\taddi %s, %s, 0\n" (reg rd) (reg rs)
    | IR_Add (rd, r1, op2) -> Printf.bprintf out "\tadd %s, %s, %s\n" (reg rd) (reg r1) (op_to_s op2)
    | IR_Sub (rd, r1, op2) -> Printf.bprintf out "\tsub %s, %s, %s\n" (reg rd) (reg r1) (op_to_s op2)
    | IR_Mul (rd, r1, r2) -> Printf.bprintf out "\tmul %s, %s, %s\n" (reg rd) (reg r1) (reg r2)
    | IR_Div (rd, r1, r2) -> Printf.bprintf out "\tdiv %s, %s, %s\n" (reg rd) (reg r1) (reg r2)
    | IR_Rem (rd, r1, r2) -> Printf.bprintf out "\trem %s, %s, %s\n" (reg rd) (reg r1) (reg r2)
    | IR_Slli (rd, r1, i) -> Printf.bprintf out "\tslli %s, %s, %d\n" (reg rd) (reg r1) i
    | IR_Srli (rd, r1, i) -> Printf.bprintf out "\tsrli %s, %s, %d\n" (reg rd) (reg r1) i
    | IR_Seqz (rd, rs) ->
        Printf.bprintf out "\tsub %s, %s, x0\n" (reg rd) (reg rs);
        Printf.bprintf out "\tsltiu %s, %s, 1\n" (reg rd) (reg rd)
    | IR_Snez (rd, rs) ->
        Printf.bprintf out "\tsub %s, %s, x0\n" (reg rd) (reg rs);
        Printf.bprintf out "\tsltu %s, x0, %s\n" (reg rd) (reg rd)
    | IR_Slt (rd, r1, r2) -> Printf.bprintf out "\tslt %s, %s, %s\n" (reg rd) (reg r1) (reg r2)
    | IR_Sgt (rd, r1, r2) -> Printf.bprintf out "\tslt %s, %s, %s\n" (reg rd) (reg r2) (reg r1)
    | IR_Sge (rd, r1, r2) ->
        Printf.bprintf out "\tslt %s, %s, %s\n" (reg rd) (reg r1) (reg r2);
        Printf.bprintf out "\txori %s, %s, 1\n" (reg rd) (reg rd)
    | IR_Lw (rd, off, rs) -> Printf.bprintf out "\tlw %s, %d(%s)\n" (reg rd) off (reg rs)
    | IR_Sw (rs, off, rd) -> Printf.bprintf out "\tsw %s, %d(%s)\n" (reg rs) off (reg rd)
    | IR_J s -> Printf.bprintf out "\tjal x0, %s\n" s
    | IR_Beqz (rs, l) -> Printf.bprintf out "\tbeq %s, x0, %s\n" (reg rs) l
    | IR_Bnez (rs, l) -> Printf.bprintf out "\tbne %s, x0, %s\n" (reg rs) l
    | IR_Call s -> Printf.bprintf out "\tjal ra, %s\n" s
    | IR_Ret -> Buffer.add_string out "\tjalr x0, ra, 0\n"
  ) instrs;
  Buffer.contents out
  
(* 表达式求值，返回存放结果的虚拟寄存器 *)
let rec compile_expr env expr : vreg =
  match expr with
  | EInt n ->
      let rd = fresh_vreg env in
      emit env (IR_Li (rd, n));
      rd
  | EVar name ->
      find_var env.var_env name
  | ECall (func_name, args) ->
      let arg_vregs = List.map (compile_expr env) args in
      let rd = fresh_vreg env in
      emit env (IR_Comment "Setup call arguments");
      (* a0-a7 are vregs 1-8 for now *)
      List.iteri (fun i arg_vreg ->
        if i < 8 then emit env (IR_Mv (i+1, arg_vreg))
      ) arg_vregs;
      emit env (IR_Call func_name);
      emit env (IR_Mv (rd, 1)); (* Assume result in a0 (vreg 1) *)
      rd
  | EUnop (op, e) ->
      let rs = compile_expr env e in
      (match op with
      | Neg ->
          let rd = fresh_vreg env in
          let zero_vreg = fresh_vreg env in
          emit env (IR_Li (zero_vreg, 0));
          emit env (IR_Sub (rd, zero_vreg, VReg rs));
          rd
      | Not ->
          let rd = fresh_vreg env in
          emit env (IR_Seqz (rd, rs));
          rd
      | Plus -> rs
      )
  | EBinop (op, e1, e2) ->
      (* 常量折叠优化: 如果两个操作数都是常量 *)
      match e1, e2 with
      | EInt n1, EInt n2 ->
          (* 直接计算结果 *)
          let rd = fresh_vreg env in
          let value = match op with
            | Add -> n1 + n2
            | Sub -> n1 - n2
            | Mul -> n1 * n2
            | Div -> if n2 <> 0 then n1 / n2 else 1 (* 避免除零 *)
            | Mod -> if n2 <> 0 then n1 mod n2 else 0
            | Eq -> if n1 = n2 then 1 else 0
            | Neq -> if n1 <> n2 then 1 else 0
            | Lt -> if n1 < n2 then 1 else 0
            | Le -> if n1 <= n2 then 1 else 0
            | Gt -> if n1 > n2 then 1 else 0
            | Ge -> if n1 >= n2 then 1 else 0
            | And -> if n1 <> 0 && n2 <> 0 then 1 else 0
            | Or -> if n1 <> 0 || n2 <> 0 then 1 else 0
          in
          emit env (IR_Li (rd, value));
          rd
      | _, _ ->
          (* 不是常量表达式 *)
      let r1 = compile_expr env e1 in
          
          (* 检查特殊情况 *)
          match e2 with
          | EInt n when op = Mul && is_power_of_two n ->
              (* 乘以2的幂优化为左移 *)
              let rd = fresh_vreg env in
              let shift = log2 n in
              emit env (IR_Slli (rd, r1, shift));
              rd
          | EInt n when op = Div && is_power_of_two n ->
              (* 除以2的幂优化为右移 *)
              let rd = fresh_vreg env in
              let shift = log2 n in
              emit env (IR_Srli (rd, r1, shift));
              rd
          | EInt 0 when op = Add ->
              (* x + 0 = x *)
              r1
          | EInt 0 when op = Sub ->
              (* x - 0 = x *)
              r1
          | EInt 0 when op = Mul ->
              (* x * 0 = 0 *)
              let rd = fresh_vreg env in
              emit env (IR_Li (rd, 0));
              rd
          | EInt 1 when op = Mul ->
              (* x * 1 = x *)
              r1
          | EInt 1 when op = Div ->
              (* x / 1 = x *)
              r1
          | _ ->
              (* 标准情况 *)
      let r2 = compile_expr env e2 in
      let rd = fresh_vreg env in
      (match op with
      | Add -> emit env (IR_Add (rd, r1, VReg r2))
      | Sub -> emit env (IR_Sub (rd, r1, VReg r2))
      | Mul -> emit env (IR_Mul (rd, r1, r2))
      | Div -> emit env (IR_Div (rd, r1, r2))
      | Mod -> emit env (IR_Rem (rd, r1, r2))
      | Eq ->
          let t = fresh_vreg env in
          emit env (IR_Sub (t, r1, VReg r2));
          emit env (IR_Seqz (rd, t))
      | Neq ->
          let t = fresh_vreg env in
          emit env (IR_Sub (t, r1, VReg r2));
          emit env (IR_Snez (rd, t))
      | Lt -> emit env (IR_Slt (rd, r1, r2))
      | Gt -> emit env (IR_Sgt (rd, r1, r2))
      | Le ->
          let t = fresh_vreg env in
          emit env (IR_Sgt (t, r1, r2));
          emit env (IR_Seqz (rd, t))
      | Ge ->
          let t = fresh_vreg env in
          emit env (IR_Slt (t, r1, r2));
          emit env (IR_Seqz (rd, t))
      | And ->
          let label_false = fresh_label env "and_false" in
          let label_end = fresh_label env "and_end" in
          emit env (IR_Beqz (r1, label_false));
          emit env (IR_Beqz (r2, label_false));
          emit env (IR_Li (rd, 1));
          emit env (IR_J label_end);
          emit env (IR_Label label_false);
          emit env (IR_Li (rd, 0));
          emit env (IR_Label label_end)
      | Or ->
          let label_true = fresh_label env "or_true" in
          let label_end = fresh_label env "or_end" in
          emit env (IR_Bnez (r1, label_true));
          emit env (IR_Bnez (r2, label_true));
          emit env (IR_Li (rd, 0));
          emit env (IR_J label_end);
          emit env (IR_Label label_true);
          emit env (IR_Li (rd, 1));
          emit env (IR_Label label_end)
      );
      rd

(* 编译语句 *)
let rec compile_stmt env stmt : unit =
  match stmt with
  | SEmpty -> ()
  | SExpr e -> let _ = compile_expr env e in ()
  | SReturn (Some e) ->
      (match e with
      | EInt n -> 
          emit env (IR_Li (1, n)) (* Optimization: direct load to a0 (vreg 1) *)
      | _ -> 
          let rv = compile_expr env e in
          emit env (IR_Mv (1, rv)) (* Move to a0 *)
      );
      emit env (IR_J env.current_func_return_label)
  | SReturn None ->
      emit env (IR_Li (1, 0)); (* a0 = 0 *)
      emit env (IR_J env.current_func_return_label)
  | SDeclare (name, init_expr) ->
      let init_vreg = compile_expr env init_expr in
      add_var env.var_env name init_vreg
  | SAssign (name, expr) ->
      let val_vreg = compile_expr env expr in
      let dest_vreg = find_var env.var_env name in
      emit env (IR_Mv (dest_vreg, val_vreg))
  | SIf (cond, then_s, else_opt) ->
      let cond_vreg = compile_expr env cond in
      let else_label = fresh_label env "else" in
      let end_label = fresh_label env "endif" in
      emit env (IR_Beqz (cond_vreg, else_label));
      compile_stmt env then_s;
      emit env (IR_J end_label);
      emit env (IR_Label else_label);
      (match else_opt with
      | Some s -> compile_stmt env s
      | None -> ());
      emit env (IR_Label end_label)
  | SWhile (cond, body) ->
      let start_label = fresh_label env "while_start" in
      let end_label = fresh_label env "while_end" in
      let old_loop = env.current_loop in
      env.current_loop <- Some (start_label, end_label);
      
      emit env (IR_Label start_label);
      let cond_vreg = compile_expr env cond in
      emit env (IR_Beqz (cond_vreg, end_label));
      compile_stmt env body;
      emit env (IR_J start_label);
      emit env (IR_Label end_label);

      env.current_loop <- old_loop
  | SBreak ->
      (match env.current_loop with
      | Some (_, end_l) -> emit env (IR_J end_l)
      | None -> failwith "break outside loop")
  | SContinue ->
      (match env.current_loop with
      | Some (start_l, _) -> emit env (IR_J start_l)
      | None -> failwith "continue outside loop")
  | SBlock stmts -> List.iter (compile_stmt env) stmts

(* 编译一个函数 *)
let compile_func func_def return_label =
  let env = init_compile_env () in
  env.current_func_return_label <- return_label;

  (* 处理参数: 将参数从物理寄存器移动到新的虚拟寄存器 *)
  let param_pregs = [1; 2; 3; 4; 5; 6; 7; 8] in (* vregs for a0-a7 *)
  let rec process_params params pregs =
    match params, pregs with
    | P name :: rest_params, preg :: rest_pregs ->
        let param_vreg = fresh_vreg env in
        emit env (IR_Comment ("Param " ^ name));
        emit env (IR_Mv (param_vreg, preg)); (* Move param from preg to a new vreg *)
        add_var env.var_env name param_vreg;
        process_params rest_params rest_pregs
    | [], _ -> ()
    | _ -> failwith "Too many parameters for registers"
  in
  process_params func_def.params param_pregs;

  (* 编译函数体 *)
  compile_stmt env func_def.body;

  (List.rev env.instructions, env)

(* --- Peephole Optimization for IR --- *)

let is_label = function
  | IR_Label _ -> true
  | _ -> false

(*
  Performs a single pass of peephole optimizations.
  - Removes jump to the next label.
  - Removes code after an unconditional jump or a return, until the next label.
*)
let rec peephole_optimize_ir instrs =
  match instrs with
  | [] -> []
  (* Pattern 1: Redundant jump to the immediately following label. *)
  | IR_J j_label :: (IR_Label l_label :: rest) when j_label = l_label ->
      (IR_Label l_label) :: peephole_optimize_ir rest
  (* Pattern 2: Unreachable code after an unconditional jump. *)
  | (IR_J _ as jump_instr) :: next_instr :: rest when not (is_label next_instr) ->
      peephole_optimize_ir (jump_instr :: rest) (* Remove `next_instr` and re-evaluate. *)
  (* Pattern 3: Unreachable code after a return. *)
  | IR_Ret :: next_instr :: rest when not (is_label next_instr) ->
      peephole_optimize_ir (IR_Ret :: rest) (* Remove `next_instr` and re-evaluate. *)
  | h :: t -> h :: peephole_optimize_ir t

(* Runs the peephole optimization until no more changes can be made. *)
let rec run_peephole_to_fixed_point instrs =
  let optimized_instrs = peephole_optimize_ir instrs in
  if optimized_instrs = instrs then
    instrs
  else
    run_peephole_to_fixed_point optimized_instrs

(* 活跃区间分析 *)
module VRegMap = Map.Make(Int)
type live_interval = {
  start: int;
  mutable end_of: int;
}
type live_intervals = live_interval VRegMap.t

let compute_live_intervals (instrs: instruction list) : live_intervals =
  let intervals = ref VRegMap.empty in
  
  let update_interval vreg idx =
    let current =
      try VRegMap.find vreg !intervals
      with Not_found -> { start = idx; end_of = idx }
    in
    intervals := VRegMap.add vreg { current with end_of = max current.end_of idx } !intervals
  in

  let process_vreg_defs idx defs =
    List.iter (fun d ->
      if not (VRegMap.mem d !intervals) then
        intervals := VRegMap.add d { start = idx; end_of = idx } !intervals
    ) defs
  in

  let process_vreg_uses idx uses =
    List.iter (fun u -> update_interval u idx) uses
  in

  List.iteri (fun i instr ->
    let used, defined =
      match instr with
      | IR_Li (d, _) -> [], [d]
      | IR_Mv (d, s) -> [s], [d]
      | IR_Add (d, r1, VReg r2) | IR_Sub (d, r1, VReg r2)
      | IR_Mul (d, r1, r2) | IR_Div (d, r1, r2) | IR_Rem (d, r1, r2)
      | IR_Slt (d, r1, r2) | IR_Sgt (d, r1, r2) -> [r1; r2], [d]
      | IR_Add (d, r1, Imm _) | IR_Sub (d, r1, Imm _) -> [r1], [d]
      | IR_Slli (d, s, _) | IR_Srli (d, s, _) -> [s], [d]
      | IR_Seqz (d, s) | IR_Snez (d, s) -> [s], [d]
      | IR_Lw (d, _, s) -> [s], [d]
      | IR_Sw (s, _, base) -> [s; base], []
      | IR_Beqz (s, _) | IR_Bnez (s, _) -> [s], []
      | IR_Call _ -> [], [1]
      | IR_Ret | IR_Label _ | IR_Comment _ -> ([], [])
      | _ -> ([], [])
    in
    process_vreg_defs i defined;
    process_vreg_uses i used;
  ) instrs;

  !intervals

(* Helper to get uses and defs for the spill rewriter *)
let get_vreg_uses_and_defs instr =
  match instr with
  | IR_Li (d, _) -> [], [d]
  | IR_Mv (d, s) -> [s], [d]
  | IR_Add (d, r1, VReg r2) | IR_Sub (d, r1, VReg r2)
  | IR_Mul (d, r1, r2) | IR_Div (d, r1, r2) | IR_Rem (d, r1, r2)
  | IR_Slt (d, r1, r2) | IR_Sgt (d, r1, r2) -> [r1; r2], [d]
  | IR_Add (d, r1, Imm _) | IR_Sub (d, r1, Imm _) -> [r1], [d]
  | IR_Slli (d, s, _) | IR_Srli (d, s, _) -> [s], [d]
  | IR_Seqz (d, s) | IR_Snez (d, s) -> [s], [d]
  | IR_Lw (d, _, s) -> [s], [d]
  | IR_Sw (s, _, base) -> [s; base], []
  | IR_Beqz (s, _) | IR_Bnez (s, _) -> [s], []
  | IR_Call _ ->
      (* Simplified: first 8 args passed in a0-a7, which are not allocatable. Result in a0 *)
      [], [1] (* a0 is defined by call *)
  | IR_Ret | IR_Label _ | IR_Comment _ -> ([], [])
  | _ -> ([], [])

(* Virtual registers for spill temps. We use negative numbers to avoid collision. *)
let t_spill1_vreg = -1
let t_spill2_vreg = -2

let rewrite_spills instrs allocation =
  let spill_map = Hashtbl.create 16 in
  let current_spill_offset = ref (-4) in

  Hashtbl.iter (fun vreg preg_opt ->
    if preg_opt = None then (
      Hashtbl.add spill_map vreg !current_spill_offset;
      current_spill_offset := !current_spill_offset - 4
    )
  ) allocation;

  let spill_frame_size = abs (!current_spill_offset + 4) in
  
  let rewritten_instrs = List.fold_left (fun acc_instrs instr ->
    let uses, defs = get_vreg_uses_and_defs instr in
    
    let use_map = Hashtbl.create 2 in
    let load_instrs = ref [] in
    
    let add_load_for_use vreg =
      if not (Hashtbl.mem use_map vreg) then (
        let temp_vreg =
            if Hashtbl.length use_map = 0 then t_spill1_vreg else t_spill2_vreg
        in
        let offset = Hashtbl.find spill_map vreg in
        load_instrs := IR_Lw (temp_vreg, offset, 0) :: !load_instrs;
        Hashtbl.add use_map vreg temp_vreg
      )
    in
    List.iter (fun u -> if Hashtbl.mem spill_map u then add_load_for_use u) uses;

    let def_map = Hashtbl.create 1 in
    let store_instrs = ref [] in
     List.iter (fun d ->
      if Hashtbl.mem spill_map d then
        let temp_vreg = t_spill1_vreg in
        let offset = Hashtbl.find spill_map d in
        store_instrs := IR_Sw (temp_vreg, offset, 0) :: !store_instrs;
        Hashtbl.add def_map d temp_vreg
    ) defs;

    let map_use r = try Hashtbl.find use_map r with Not_found -> r in
    let map_def r = try Hashtbl.find def_map r with Not_found -> r in
    let map_op = function VReg r -> VReg(map_use r) | Imm i -> Imm i in

    let rewritten_instr = match instr with
      | IR_Li (d, i) -> IR_Li (map_def d, i)
      | IR_Mv (d, s) -> IR_Mv (map_def d, map_use s)
      | IR_Add (d, r1, op2) -> IR_Add (map_def d, map_use r1, map_op op2)
      | IR_Sub (d, r1, op2) -> IR_Sub (map_def d, map_use r1, map_op op2)
      | IR_Mul (d, r1, r2) -> IR_Mul (map_def d, map_use r1, map_use r2)
      | IR_Div (d, r1, r2) -> IR_Div (map_def d, map_use r1, map_use r2)
      | IR_Rem (d, r1, r2) -> IR_Rem (map_def d, map_use r1, map_use r2)
      | IR_Slli (d, s, i) -> IR_Slli (map_def d, map_use s, i)
      | IR_Srli (d, s, i) -> IR_Srli (map_def d, map_use s, i)
      | IR_Seqz (d, s) -> IR_Seqz (map_def d, map_use s)
      | IR_Snez (d, s) -> IR_Snez (map_def d, map_use s)
      | IR_Slt (d, r1, r2) -> IR_Slt (map_def d, map_use r1, map_use r2)
      | IR_Sgt (d, r1, r2) -> IR_Sgt (map_def d, map_use r1, map_use r2)
      | IR_Lw (d, off, base) -> IR_Lw (map_def d, off, map_use base)
      | IR_Sw (s, off, base) -> IR_Sw (map_use s, off, map_use base)
      | IR_Beqz (s, l) -> IR_Beqz (map_use s, l)
      | IR_Bnez (s, l) -> IR_Bnez (map_use s, l)
      | IR_J s -> IR_J s
      | IR_Call s -> IR_Call s
      | IR_Ret -> IR_Ret
      | other -> other
    in
    let final_instrs = (List.rev !load_instrs) @ [rewritten_instr] @ !store_instrs in
    acc_instrs @ final_instrs
  ) [] instrs in
  
  (rewritten_instrs, spill_frame_size)

(* 线性扫描寄存器分配 *)
let linear_scan_allocator (intervals: live_intervals) : (vreg, preg option) Hashtbl.t =
  let allocation = Hashtbl.create (VRegMap.cardinal intervals) in
  let sorted_intervals = List.sort (fun (_, a) (_, b) -> compare a.start b.start) (VRegMap.bindings intervals) in
  
  let physical_regs = [T0; T1; T2; T3; T4; S0; S1; S2; S3; S4; S5; S6; S7; S8] in (* T5, T6 are reserved *)
  let free_regs = ref physical_regs in

  let active = ref [] in (* list of (vreg, preg, interval) *)

  List.iter (fun (vreg, interval) ->
    (* 1. 释放不活跃的寄存器 *)
    let (still_active, expired) = List.partition (fun (_, _, i) -> i.end_of >= interval.start) !active in
    active := still_active;
    List.iter (fun (_, preg, _) -> free_regs := preg :: !free_regs) expired;

    (* 2. 分配寄存器 *)
    match !free_regs with
    | preg :: rest ->
      free_regs := rest;
      Hashtbl.add allocation vreg (Some preg);
      active := (vreg, preg, interval) :: !active;
      active := List.sort (fun (_, _, a) (_, _, b) -> compare a.end_of b.end_of) !active
    | [] ->
      (* 3. 溢出 (Spill) *)
      (* Standard heuristic: spill the interval in 'active' that ends latest. *)
      (* 'active' is sorted by end_of ascending, so the last element is the one to spill. *)
      let last_in_active = List.hd (List.rev !active) in
      let (spill_vreg, spill_preg, spill_interval) = last_in_active in
      
      if spill_interval.end_of > interval.end_of then (
        (* Spill the existing interval because it lives longer than the current one *)
        active := List.filter (fun (v, _, _) -> v <> spill_vreg) !active;
        Hashtbl.add allocation spill_vreg None; (* Mark as spilled *)
        
        (* Allocate its physical register to the current interval *)
        Hashtbl.add allocation vreg (Some spill_preg);
        active := (vreg, spill_preg, interval) :: !active;
        active := List.sort (fun (_, _, a) (_, _, b) -> compare a.end_of b.end_of) !active
      ) else (
        (* Spill the current interval, as it ends later (or same time) *)
        Hashtbl.add allocation vreg None
      )
  ) sorted_intervals;

  allocation

(* 遍历AST以确定函数是否为叶子函数 (不调用其他函数) *)
let rec is_leaf_function_body stmt =
  match stmt with
  | SEmpty | SReturn _ | SBreak | SContinue | SDeclare _ | SAssign _ -> true
  | SExpr e -> is_leaf_function_expr e
  | SIf (_, then_s, else_opt) ->
      is_leaf_function_body then_s &&
      (match else_opt with None -> true | Some s -> is_leaf_function_body s)
  | SWhile (_, body) -> is_leaf_function_body body
  | SBlock stmts -> List.for_all is_leaf_function_body stmts

and is_leaf_function_expr expr =
  match expr with
  | EInt _ | EVar _ -> true
  | EUnop (_, e) -> is_leaf_function_expr e
  | EBinop (_, e1, e2) -> is_leaf_function_expr e1 && is_leaf_function_expr e2
  | ECall _ -> false

let generate_riscv (Program funcs) =
  let final_code = Buffer.create(4096) in
  
  List.iter (fun func_def ->
    let return_label = func_def.name ^ "_return" in
    Printf.bprintf final_code "%s:\n" func_def.name;
    
    let (instrs, _) = compile_func func_def return_label in
    let instrs = run_peephole_to_fixed_point instrs in
    let intervals = compute_live_intervals instrs in
    let allocation = linear_scan_allocator intervals in
    
    let is_leaf = func_def.name <> "main" && is_leaf_function_body func_def.body in
    
    let (rewritten_instrs, spill_frame_size) = rewrite_spills instrs allocation in

    (*
      Stack frame layout:
      - ra (if non-leaf)
      - s0 (frame pointer)
      - spilled virtual registers
    *)
    let ra_slot_size = if is_leaf then 0 else 4 in
    let s0_slot_size = 4 in
    let total_frame_size = spill_frame_size + ra_slot_size + s0_slot_size in
    
    (* Align frame size to 16 bytes *)
    let frame_size =
      if total_frame_size <= 16 then 16
      else (total_frame_size + 15) / 16 * 16
    in
    
    let ra_offset = frame_size - 4 in
    let s0_offset = frame_size - 8 in

    (* Prologue *)
    Printf.bprintf final_code "\taddi sp, sp, -%d\n" frame_size;
    if not is_leaf then
      Printf.bprintf final_code "\tsw ra, %d(sp)\n" ra_offset;
    Printf.bprintf final_code "\tsw s0, %d(sp)\n" s0_offset;
    Printf.bprintf final_code "\taddi s0, sp, %d\n" frame_size;

    (* Special vregs for spill temps and FP/A0 *)
    Hashtbl.add allocation 0 (Some S0); (* FP is now s0 *)
    Hashtbl.add allocation 1 (Some A0);
    Hashtbl.add allocation t_spill1_vreg (Some T5);
    Hashtbl.add allocation t_spill2_vreg (Some T6);

    let func_asm = string_of_ir rewritten_instrs allocation in
    Buffer.add_string final_code func_asm;

    (* Epilogue: the return label is added here, and jumps from 'ret' statements will land here. *)
    Buffer.add_string final_code ("\n" ^ return_label ^ ":\n");
    if not is_leaf then
      Printf.bprintf final_code "\tlw ra, %d(sp)\n" ra_offset;
    Printf.bprintf final_code "\tlw s0, %d(sp)\n" s0_offset;
    Printf.bprintf final_code "\taddi sp, sp, %d\n" frame_size;
    Buffer.add_string final_code "\tjalr x0, ra, 0\n\n";

  ) funcs;

  Buffer.contents final_code 