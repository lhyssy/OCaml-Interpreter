open Ast

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
  | IR_Lw of vreg * int * vreg (* Lw rd, offset(rs1) - for local variables on stack, rs1 is FP *)
  | IR_Sw of vreg * int * vreg (* Sw rs1, offset(rd) - for local variables on stack, rd is FP *)
  (* Control Flow *)
  | IR_J of string
  | IR_Beqz of vreg * string
  | IR_Bnez of vreg * string
  | IR_Beq of vreg * vreg * string
  | IR_Bne of vreg * vreg * string
  | IR_Blt of vreg * vreg * string
  | IR_Bge of vreg * vreg * string
  | IR_Call of string
  | IR_Ret
  (* New for stack argument passing *)
  | IR_Adjust_SP of int (* addi sp, sp, imm *)
  | IR_Push_Caller_Stack_Arg of vreg * int (* sw rs, offset(sp) - for caller pushing args *)
  | IR_Load_Callee_Stack_Arg of vreg * int (* lw rd, offset(s0) - for callee loading args from above frame *)
;;

(* 最终得到的，优化过后的IR结构 *)
type func_ir_def = {
  return_type: typ;
  return_label: string;
  name: string;
  params: param list;
  body: instruction list; 
  (*与func_def类似但是将body换成了instruction list*)
  is_leaf: bool
};;

type program_ir = Program_ir of func_ir_def list;;