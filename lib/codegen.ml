open Ir
open Irgen

(* 真实寄存器定义 *)
type preg =
  | A0 | A1 | A2 | A3 | A4 | A5 | A6 | A7
  | T0 | T1 | T2 | T3 | T4 | T5 | T6
  | S0 | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10 | S11
  | RA | SP | FP | ZERO
;;

let string_of_preg = function
  | A0 -> "a0" | A1 -> "a1" | A2 -> "a2" | A3 -> "a3"
  | A4 -> "a4" | A5 -> "a5" | A6 -> "a6" | A7 -> "a7"
  | T0 -> "t0" | T1 -> "t1" | T2 -> "t2" | T3 -> "t3"
  | T4 -> "t4" | T5 -> "t5" | T6 -> "t6"
  | S0 -> "s0" | S1 -> "s1" | S2 -> "s2" | S3 -> "s3"
  | S4 -> "s4" | S5 -> "s5" | S6 -> "s6" | S7 -> "s7"
  | S8 -> "s8" | S9 -> "s9" | S10 -> "s10" | S11 -> "s11"
  | RA -> "ra" | SP -> "sp" | FP -> "fp" | ZERO -> "zero"
;;

(* 活跃区间分析 *)
module VRegMap = Map.Make(Int)
type live_interval = {
  start: int;
  mutable end_of: int;
}
type live_intervals = live_interval VRegMap.t

module StringMap = Map.Make(String)
type label_map = int StringMap.t

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
  | IR_Beq (r1, r2, _) | IR_Bne (r1, r2, _) | IR_Blt (r1, r2, _) | IR_Bge (r1, r2, _) ->
      [r1; r2], []
  | IR_Lw (d, _, s) -> [s], [d]
  | IR_Sw (s, _, base) -> [s; base], []
  | IR_Beqz (s, _) | IR_Bnez (s, _) -> [s], []
  | IR_Call _ ->
      (* Simplified: first 8 args passed in a0-a7, which are not allocatable. Result in a0 *)
      [], [1] (* a0 is defined by call *)
  | IR_Ret | IR_Label _ | IR_Comment _ -> ([], [])
  | IR_Adjust_SP _ -> ([], [])
  | IR_Push_Caller_Stack_Arg (s, _) -> [s], []
  | IR_Load_Callee_Stack_Arg (d, _) -> [], [d]
  | _ -> ([], []) (* Should not happen with exhaustive matching *)
;;

(* 检测其中的循环部分，并输出循环对应的区间 *)
let detect_loops (instrs: instruction list) : live_interval list =
  (* 按顺序检查指令，如果有label，那么将其行号放置于一个map中 *)
  (* 如果遇见跳转指令，检查当前行以及跳转label行号的大小，如果当前行号大，则建立循环区间记录 *)
  let label_map = ref StringMap.empty in
  let loop_list = ref [] in
  let process_label idx instr = 
    match instr with
    | IR_Label label ->
        label_map := StringMap.add label idx !label_map
    | _ -> ()
  in

  List.iteri(fun i instr ->
    process_label i instr;
    match instr with
    | IR_J label ->
        (try
          let target_idx = StringMap.find label !label_map in
          if target_idx < i then
            loop_list := { start = target_idx; end_of = i } :: !loop_list
        with Not_found -> ())
    | IR_Beqz (_, label) | IR_Bnez (_, label) ->
        (try
          let target_idx = StringMap.find label !label_map in
          if target_idx < i then
            loop_list := { start = target_idx; end_of = i } :: !loop_list
        with Not_found -> ())
    | _ -> ()
  )instrs;

  !loop_list
;;

let compute_live_intervals (instrs: instruction list) : live_intervals =
  let loops = detect_loops instrs in
  let intervals = ref VRegMap.empty in
  
  let update_interval vreg idx =
    let current =
      try VRegMap.find vreg !intervals
      with Not_found -> { start = idx; end_of = idx }
    in
    intervals := VRegMap.add vreg { current with end_of = max current.end_of idx } !intervals
  in

  let expand_new_end (cur_begin:int) (cur_end:int): int = 
    let get_end loop_interval: int =
      if cur_begin < loop_interval.start && loop_interval.start <= cur_end then
        max cur_end loop_interval.end_of
      else
        cur_end
    in
    List.fold_left (fun acc loop_interval -> 
      max (get_end loop_interval) acc)
    cur_end loops
  in

  let process_vreg_defs idx defs =
    List.iter (fun d ->
      if not (VRegMap.mem d !intervals) then
        intervals := VRegMap.add d { start = idx; end_of = idx } !intervals
    ) defs
  in

  let process_vreg_uses idx uses =
    List.iter (fun u ->
    try
      update_interval u idx;
      let current = VRegMap.find u !intervals in
      let cur_begin = current.start in
      let cur_end = max current.end_of idx in
      let new_end = expand_new_end cur_begin cur_end in
      intervals := VRegMap.add u { current with end_of = new_end } !intervals
    with Not_found -> ()
  ) uses
  (* 已经被这一坨屎搞得没有任何动力了，总之，燃尽了*)
  in

  List.iteri (fun i instr ->
    let used, defined = get_vreg_uses_and_defs instr in
    process_vreg_defs i defined;
    process_vreg_uses i used;
  ) instrs;

  !intervals
;;

let print_live_intervals_and_allocation (intervals: live_intervals) (allocation: (vreg, preg option) Hashtbl.t) =
  let print_vreg_info vreg interval =
    Printf.printf "vreg %d: [%d, %d], " vreg interval.start interval.end_of;
    match Hashtbl.find_opt allocation vreg with
    | Some (Some preg) -> Printf.printf "allocated to %s\n" (string_of_preg preg);
    | Some None -> Printf.printf "spilled\n";
    | None -> Printf.printf "not allocated\n";
  in

  VRegMap.iter print_vreg_info intervals;
;;

(* 判断每个vreg是否live across call *)
let compute_live_across_call (instrs: instruction list) : (vreg, bool) Hashtbl.t =
  let live_across = Hashtbl.create 16 in
  let live_now = ref [] in
  List.iteri (fun _ instr ->
    let used, defined = get_vreg_uses_and_defs instr in
    (* 在call前，live_now中所有vreg都活跃穿越call *)
    (match instr with
    | IR_Call _ ->
        List.iter (fun v -> Hashtbl.replace live_across v true) !live_now
    | _ -> ());
    (* 更新live_now *)
    live_now := List.filter (fun v -> not (List.mem v defined)) !live_now;
    List.iter (fun v -> if not (List.mem v !live_now) then live_now := v :: !live_now) used;
  ) instrs;
  live_across
;;

(* Virtual registers for spill temps. We use negative numbers to avoid collision. *)
let t_spill1_vreg = -1
let t_spill2_vreg = -2

let rewrite_spills instrs allocation save_bisas =
  let spill_map = Hashtbl.create 16 in
  let current_spill_offset = ref (-save_bisas) in

  Hashtbl.iter (fun vreg preg_opt ->
    if preg_opt = None then (
      Hashtbl.add spill_map vreg !current_spill_offset;
      current_spill_offset := !current_spill_offset - 4
    )
  ) allocation;

  let spill_frame_size = abs (!current_spill_offset + save_bisas) in

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
      | IR_Beq (r1, r2, l) -> IR_Beq (map_use r1, map_use r2, l)
      | IR_Bne (r1, r2, l) -> IR_Bne (map_use r1, map_use r2, l)
      | IR_Blt (r1, r2, l) -> IR_Blt (map_use r1, map_use r2, l)
      | IR_Bge (r1, r2, l) -> IR_Bge (map_use r1, map_use r2, l)
      | IR_J s -> IR_J s
      | IR_Call s -> IR_Call s
      | IR_Ret -> IR_Ret
      | IR_Adjust_SP i -> IR_Adjust_SP i
      | IR_Push_Caller_Stack_Arg (s, off) -> IR_Push_Caller_Stack_Arg (map_use s, off)
      | IR_Load_Callee_Stack_Arg (d, off) -> IR_Load_Callee_Stack_Arg (map_def d, off)
      | IR_Label s -> IR_Label s
      | other -> 
        Printf.eprintf "Warning: Unhandled instruction %s in spill rewriting.\n" (string_of_instruction other);
        other
    in

    let final_instrs = (List.rev !load_instrs) @ [rewritten_instr] @ !store_instrs in
    acc_instrs @ final_instrs
  ) [] instrs in
  
  (rewritten_instrs, spill_frame_size)
;;

(* 线性扫描寄存器分配 *)
let linear_scan_allocator (intervals: live_intervals) (live_across_call: (vreg, bool) Hashtbl.t) : (vreg, preg option) Hashtbl.t =
  let allocation = Hashtbl.create (VRegMap.cardinal intervals) in
  let sorted_intervals = List.sort (fun (_, a) (_, b) -> compare a.start b.start) (VRegMap.bindings intervals) in
  let caller_saved = [T0; T1; T2; T3; T4] in
  let callee_saved = [S1; S2; S3; S4; S5; S6; S7; S8; S9; S10; S11] in
  let free_caller = ref caller_saved in
  let free_callee = ref callee_saved in
  let active = ref [] in
  List.iter (fun (vreg, interval) ->
    let (still_active, expired) = List.partition (fun (_, _, i) -> i.end_of > interval.start) !active in
    active := still_active;
    List.iter (fun (_, preg, _) ->
      if List.mem preg caller_saved then free_caller := preg :: !free_caller
      else if List.mem preg callee_saved then free_callee := preg :: !free_callee
    ) expired;
    let need_callee =
      try Hashtbl.find live_across_call vreg with Not_found -> false
    in
    let alloc_reg =
      if need_callee then !free_callee else !free_caller @ !free_callee
    in
    match alloc_reg with
    | preg :: rest ->
      if need_callee then free_callee := rest else
        if List.mem preg caller_saved then free_caller := List.filter ((<>) preg) !free_caller
        else free_callee := List.filter ((<>) preg) !free_callee;
      Hashtbl.add allocation vreg (Some preg);
      active := (vreg, preg, interval) :: !active;
      active := List.sort (fun (_, _, a) (_, _, b) -> compare a.end_of b.end_of) !active
    | [] ->
      let last_in_active = List.hd (List.rev !active) in
      let (spill_vreg, spill_preg, spill_interval) = last_in_active in
      if spill_interval.end_of > interval.end_of then (
        active := List.filter (fun (v, _, _) -> v <> spill_vreg) !active;
        Hashtbl.add allocation spill_vreg None;
        Hashtbl.add allocation vreg (Some spill_preg);
        active := (vreg, spill_preg, interval) :: !active;
        active := List.sort (fun (_, _, a) (_, _, b) -> compare a.end_of b.end_of) !active
      ) else (
        Hashtbl.add allocation vreg None
      )
  ) sorted_intervals;
  allocation
;;

(* 检查关于s1~s11的寄存器使用情况，输出携带的s寄存器 *)
let check_s_regs_usage (instrs : instruction list) (vreg_map : (vreg, preg option) Hashtbl.t) =
  try
  let reg r =
    match Hashtbl.find_opt vreg_map r with
    | Some preg -> preg
    | None -> None
  in
  
  let is_s_reg preg_opt =
    match preg_opt with
    | Some (S0 | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10 | S11) -> true
    | _ -> false 
  in

  let remove_opt preg_opt =
    match preg_opt with
    | Some preg -> preg
    | _ -> failwith "Failed when removing optionals(check_s_regs_usage)"
  in

  instrs
  |> List.concat_map (fun x -> snd (get_vreg_uses_and_defs x))
  |> List.map reg
  |> List.filter is_s_reg
  |> List.map remove_opt
  |> List.sort_uniq (fun a b -> compare (string_of_preg a) (string_of_preg b))
  with Not_found ->
    failwith "vreg_map does not contain all vregs used in instructions";
;;

(* 调用函数相关汇编 *)
let code_of_call func_name (vreg_map : (vreg, preg option) Hashtbl.t) buf live_intervals cnt = 
  let reg r =
    match Hashtbl.find vreg_map r with
    | Some preg -> preg
    | None -> failwith ("vreg " ^ string_of_int r ^ " was spilled (not implemented, from call code generation)")
  in
  
  let is_t_reg preg = 
    match preg with
    | T0 | T1 | T2 | T3 | T4 | T5 | T6 -> true
    | _ -> false
  in

  (* 找到live_intervals中区间内有cnt的区间 *)
  let live_int = List.filter (fun (_, interval) ->
    interval.start <= !cnt && interval.end_of >= !cnt
  ) (VRegMap.bindings live_intervals) in

  (* 找到所有活跃的t寄存器 *)
  let t_regs = live_int
  |> List.map (fun x -> reg (fst x))
  |> List.filter is_t_reg
  |> List.sort_uniq (fun a b -> compare (string_of_preg a) (string_of_preg b)) in

  (* 计算保存t寄存器所需堆栈大小 *)
  let t_regs_size = List.length t_regs * 4 in

  (* 调整堆栈指针, 保存t寄存器 *)
  if (t_regs_size > 0) then(
    Printf.bprintf buf "\taddi sp, sp, -%d\n" t_regs_size;
    List.iteri (fun i preg ->
      Printf.bprintf buf "\tsw %s, %d(sp)\n" (string_of_preg preg) (i * 4)
    ) t_regs;
  );
  
  (* 调用函数 *)
  Printf.bprintf buf "\tjal ra, %s\n" func_name;

  (* 恢复t寄存器 *)
  if (t_regs_size > 0) then(
    List.iteri (fun i preg ->
      Printf.bprintf buf "\tlw %s, %d(sp)\n" (string_of_preg preg) (i * 4)
    ) t_regs;
    Printf.bprintf buf "\taddi sp, sp, %d\n" t_regs_size;
  );
;;

(* IR to Assembly *)
let code_of_ir (instrs : instruction list) (vreg_map : (vreg, preg option) Hashtbl.t) live_intervals =
  let counter = ref 0 in
  let out = Buffer.create 1024 in
  let reg r =
    match Hashtbl.find vreg_map r with
    | Some preg -> string_of_preg preg
    | None -> failwith ("vreg " ^ string_of_int r ^ " was spilled (not implemented, from code_of_ir)")
  in
  let op_to_s = function
    | VReg r -> reg r
    | Imm i -> string_of_int i
  in
  let code_of_ir_instr instr = 
    match instr with
    | IR_Label s -> Buffer.add_string out (s ^ ":\n")
    | IR_Comment _ -> ()
    | IR_Li (r, i) -> 
        (* 替换 li 伪指令，对于小的立即数使用 addi，大的立即数仍然使用 li *)
        if i >= -2048 && i <= 2047 then
          Printf.bprintf out "\taddi %s, x0, %d\n" (reg r) i
        else
          Printf.bprintf out "\tli %s, %d\n" (reg r) i
    | IR_Mv (rd, rs) ->
        let physical_rd = Hashtbl.find vreg_map rd in
        let physical_rs = Hashtbl.find vreg_map rs in
        if physical_rd <> physical_rs then
          Printf.bprintf out "\taddi %s, %s, 0\n" (reg rd) (reg rs)
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
    | IR_Beq (r1, r2, l) -> Printf.bprintf out "\tbeq %s, %s, %s\n" (reg r1) (reg r2) l
    | IR_Bne (r1, r2, l) -> Printf.bprintf out "\tbne %s, %s, %s\n" (reg r1) (reg r2) l
    | IR_Blt (r1, r2, l) -> Printf.bprintf out "\tblt %s, %s, %s\n" (reg r1) (reg r2) l
    | IR_Bge (r1, r2, l) -> Printf.bprintf out "\tbge %s, %s, %s\n" (reg r1) (reg r2) l
    | IR_Call s -> code_of_call s vreg_map out live_intervals counter;
    | IR_Ret -> Buffer.add_string out "\tjalr x0, ra, 0\n"
    | IR_Adjust_SP i -> Printf.bprintf out "\taddi sp, sp, %d\n" i
    | IR_Push_Caller_Stack_Arg (rs, offset) -> Printf.bprintf out "\tsw %s, %d(sp)\n" (reg rs) offset
    | IR_Load_Callee_Stack_Arg (rd, offset) -> Printf.bprintf out "\tlw %s, %d(s0)\n" (reg rd) offset
    ;
  in

  let code_and_count instr =
    code_of_ir_instr instr;
    counter := !counter + 1;
  in

  List.iter code_and_count instrs;
  Buffer.contents out
;;


(* 生成最终的risc-v汇编代码 *)
let generate_riscv (Program_ir prog_ir) =
  let final_code = Buffer.create(4096) in
  
  (* 重新生成 .globl main 和 .text *)
  Buffer.add_string final_code ".globl main\n";
  Buffer.add_string final_code ".text\n";
  
  List.iter (fun func_def ->
    (* 输出函数名 *)
    Printf.bprintf final_code "%s:\n" func_def.name;
    
    (* 获取函数体并计算变量活跃区间 *)
    let instrs = func_def.body in
    let intervals = compute_live_intervals instrs in

    (* 是否是叶子函数（继承自func_def），在计算保存栈帧等有用 *)
    let is_leaf = func_def.is_leaf in

    (* 新增：分析哪些vreg活跃穿越call *)
    let live_across_call = compute_live_across_call instrs in
    
    (* Separate pre-colored vregs (0-8 for args/fp) from the rest *)
    let (_, other_vregs) =
      VRegMap.partition (fun vreg _ -> vreg >= 0 && vreg <= 8) intervals in
    
    (* 分配其他寄存器，其中传入live_across_call *)
    let allocation = linear_scan_allocator other_vregs live_across_call in
    
    (* 在分配表中添加预涂色的寄存器 *)
    Hashtbl.add allocation 0 (Some S0); (* FP is s0 *)
    Hashtbl.add allocation 1 (Some A0);
    Hashtbl.add allocation 2 (Some A1);
    Hashtbl.add allocation 3 (Some A2);
    Hashtbl.add allocation 4 (Some A3);
    Hashtbl.add allocation 5 (Some A4);
    Hashtbl.add allocation 6 (Some A5);
    Hashtbl.add allocation 7 (Some A6);
    Hashtbl.add allocation 8 (Some A7);
    Hashtbl.add allocation t_spill1_vreg (Some T5);
    Hashtbl.add allocation t_spill2_vreg (Some T6);

    (* 检查S型寄存器的情况以及ra的使用，决定对应大小 *)
    let s_regs_save = check_s_regs_usage instrs allocation in
    let s_slot_size = if func_def.name <> "main" then List.length s_regs_save * 4 else 0 in
    let ra_slot_size = if is_leaf then 0 else 4 in
    let s0_slot_size = 4 in

    (* 计算并利用总偏移进行指令重写，并得到溢出帧大小 *)
    let total_save_bisas = s0_slot_size + s_slot_size + ra_slot_size in
    let (rewritten_instrs, spill_frame_size) = rewrite_spills instrs allocation total_save_bisas in

    (* 计算帧的总大小 *)
    let total_frame_size = spill_frame_size + ra_slot_size + s0_slot_size + s_slot_size in
    
    (* 将帧大小对齐至16字节 *)
    let frame_size =
      if total_frame_size <= 16 then 16
      else (total_frame_size + 15) / 16 * 16
    in

    (* Check if the frame size is allocated correctly *)
    (* Uncomment for debugging
    Printf.printf "Func name: %s\n" func_def.name;
    Printf.printf "is_leaf: %b\n" is_leaf;
    Printf.printf "spill_frame_size: %d\n" spill_frame_size;
    Printf.printf "ra_slot_size: %d\n" ra_slot_size;
    Printf.printf "s0_slot_size: %d\n" s0_slot_size;
    Printf.printf "s_slot_size: %d\n" s_slot_size;
    Printf.printf "total_frame_size: %d\n" total_frame_size;
    Printf.printf "Frame size: %d\n" frame_size;
    Printf.printf "\n";*)

    (* Offsets for saved registers *)
    let ra_offset = frame_size - 4 in
    let s0_offset = frame_size - 4 - ra_slot_size in

    (* Prologue *)
    Printf.bprintf final_code "\taddi sp, sp, -%d\n" frame_size;
    if not is_leaf then
      Printf.bprintf final_code "\tsw ra, %d(sp)\n" ra_offset;
    Printf.bprintf final_code "\tsw s0, %d(sp)\n" s0_offset;
    if s_slot_size > 0 then
      List.iteri (fun i preg ->
        Printf.bprintf final_code "\tsw %s, %d(sp)\n" (string_of_preg preg) 
        (frame_size - 8 - ra_slot_size - i * 4)
      ) s_regs_save;
    
    (* Set up frame pointer *)
    Printf.bprintf final_code "\taddi s0, sp, %d\n" frame_size;

    (* Calculate new live intervals after rewritten*)
    let new_live_intervals = compute_live_intervals rewritten_instrs in
    
    (* Print the allocation table for checking the allocation *)
    (* Uncomment for debugging
    print_endline ("Function: " ^ func_def.name);
    print_live_intervals_and_allocation new_live_intervals allocation;
    print_endline (string_of_inst_list rewritten_instrs);
    print_endline "";*)
    
    (* Generate assembly code for the function body *)
    let func_asm = code_of_ir rewritten_instrs allocation new_live_intervals in
    Buffer.add_string final_code func_asm;

    (* Epilogue: the return label is added here, and jumps from 'ret' statements will land here. *)
    let return_label = func_def.return_label in 
    Buffer.add_string final_code (return_label ^ ":\n");
    if not is_leaf then
      Printf.bprintf final_code "\tlw ra, %d(sp)\n" ra_offset;
    Printf.bprintf final_code "\tlw s0, %d(sp)\n" s0_offset;
    if s_slot_size > 0 then
      List.iteri (fun i preg ->
        Printf.bprintf final_code "\tlw %s, %d(sp)\n" (string_of_preg preg) 
        (frame_size - 8 - ra_slot_size - i * 4)
      ) s_regs_save;
    Printf.bprintf final_code "\taddi sp, sp, %d\n" frame_size;
    Buffer.add_string final_code "\tjalr x0, ra, 0\n\n";

  ) prog_ir;

  Buffer.contents final_code