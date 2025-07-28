open Ir

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

(* IR to Assembly *)
let code_of_ir (instrs : instruction list) (vreg_map : (vreg, preg option) Hashtbl.t) =
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
    | IR_Call s -> Printf.bprintf out "\tjal ra, %s\n" s
    | IR_Ret -> Buffer.add_string out "\tjalr x0, ra, 0\n"
    | IR_Adjust_SP i -> Printf.bprintf out "\taddi sp, sp, %d\n" i
    | IR_Push_Caller_Stack_Arg (rs, offset) -> Printf.bprintf out "\tsw %s, %d(sp)\n" (reg rs) offset
    | IR_Load_Callee_Stack_Arg (rd, offset) -> Printf.bprintf out "\tlw %s, %d(s0)\n" (reg rd) offset
  ) instrs;
  Buffer.contents out

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
      | IR_Adjust_SP _ -> ([], [])
      | IR_Push_Caller_Stack_Arg (s, _) -> [s], []
      | IR_Load_Callee_Stack_Arg (d, _) -> [], [d]
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
  | IR_Adjust_SP _ -> ([], [])
  | IR_Push_Caller_Stack_Arg (s, _) -> [s], []
  | IR_Load_Callee_Stack_Arg (d, _) -> [], [d]
  | _ -> ([], []) (* Should not happen with exhaustive matching *)

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
      | IR_Adjust_SP i -> IR_Adjust_SP i
      | IR_Push_Caller_Stack_Arg (s, off) -> IR_Push_Caller_Stack_Arg (map_use s, off)
      | IR_Load_Callee_Stack_Arg (d, off) -> IR_Load_Callee_Stack_Arg (map_def d, off)
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
  
  (* 移除 S0，因为它被用作帧指针FP *) 
  let physical_regs = [T0; T1; T2; T3; T4; S1; S2; S3; S4; S5; S6; S7; S8; S9; S10; S11] in (* T5, T6 are reserved for spills *)
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

let generate_riscv (Program_ir prog_ir) =
  let final_code = Buffer.create(4096) in
  
  (* 重新生成 .globl main 和 .text *)
  Buffer.add_string final_code ".globl main\n";
  Buffer.add_string final_code ".text\n";
  
  List.iter (fun func_def ->
    let return_label = func_def.return_label in 
    Printf.bprintf final_code "%s:\n" func_def.name;
    
    let instrs = func_def.body in
    let intervals = compute_live_intervals instrs in
    
    (* Separate pre-colored vregs (0-8 for args/fp) from the rest *)
    let (_, other_vregs) =
      VRegMap.partition (fun vreg _ -> vreg >= 0 && vreg <= 8) intervals in
    
    (* Allocate only the other vregs *)
    let allocation = linear_scan_allocator other_vregs in
    
    let is_leaf = func_def.is_leaf in
    
    let (rewritten_instrs, spill_frame_size) = rewrite_spills instrs allocation in

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

    (* Add the pre-colored vregs to the allocation table *)
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

    let func_asm = code_of_ir rewritten_instrs allocation in
    Buffer.add_string final_code func_asm;

    (* Epilogue: the return label is added here, and jumps from 'ret' statements will land here. *)
    Buffer.add_string final_code ("\n" ^ return_label ^ ":\n");
    if not is_leaf then
      Printf.bprintf final_code "\tlw ra, %d(sp)\n" ra_offset;
    Printf.bprintf final_code "\tlw s0, %d(sp)\n" s0_offset;
    Printf.bprintf final_code "\taddi sp, sp, %d\n" frame_size;
    Buffer.add_string final_code "\tjalr x0, ra, 0\n\n";

  ) prog_ir;

  Buffer.contents final_code 