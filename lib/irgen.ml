open Ast
open Ir
open Tool

(* 变量环境 *)
(* 变量环境 *)
type var_env = {
  vars: (string, vreg) Hashtbl.t list; (* 变量名 -> 虚拟寄存器 *)
}

let empty_var_env () = {
  vars = [Hashtbl.create 16];
}

let add_var env name vreg =
  match env.vars with
  | [] -> failwith("Add var when in null env")
  | h::_ -> 
      Hashtbl.add h name vreg; 
      env  (* 返回更新后的环境 *)
;;

let find_var env name =
  let rec find_vars vars name = 
    match vars with
    | [] -> failwith ("Undefined variable: " ^ name)
    | h::t -> 
      match (Hashtbl.find_opt h name) with
      | None -> find_vars t name
      | Some x -> x
  in
  find_vars env.vars name
;;

let in_var env =
  { vars = (Hashtbl.create 16) :: env.vars }
;;

let out_var env =
  match env.vars with
  | [] -> failwith("Out_var when in null env")
  | _::t -> { vars = t }
;;

(* 编译器环境 *)
type compile_env = {
  mutable var_env: var_env;
  mutable vreg_count: int;
  mutable current_loop: (string * string) option;
  mutable current_func_return_label: string;
  mutable instructions: instruction list;
}

let init_compile_env () = {
  var_env = empty_var_env ();
  vreg_count = 16; (* Start vreg counting from 16 to avoid collision with reserved regs (a0-a7 etc) *)
  current_loop = None;
  current_func_return_label = "";
  instructions = [];
}

(* label_count 移动到程序外以防止标签重叠 *)
let label_count = ref 0;;

let reset_label_count () =
  label_count := 0

(* 获取一个新的虚拟寄存器 *)
let fresh_vreg env =
  let v = env.vreg_count in
  env.vreg_count <- v + 1;
  v
;;

(* 获取一个新的标签 *)
let fresh_label prefix =
  let l = !label_count in
  label_count:= l + 1;
  prefix ^ "_" ^ string_of_int l
;;

let emit env instr =
  env.instructions <- instr :: env.instructions
  
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
      
      let num_reg_args = min 8 (List.length arg_vregs) in
      let num_stack_args = (List.length arg_vregs) - num_reg_args in
      let stack_args_size = num_stack_args * 4 in

      (* 1. 调整栈指针为栈上传递参数预留空间，并压入栈参数 (如果存在) *)
      if num_stack_args > 0 then begin
        emit env (IR_Adjust_SP (-stack_args_size));
        (* 栈参数从 arg_vregs 的第 8 个元素开始，逆序压栈 (右到左) *)
        let stack_args = List.filteri (fun i _ -> i >= 8) arg_vregs |> List.rev in
        List.iteri (fun i arg_vreg ->
          let offset = i * 4 in (* 偏移量相对于调整后的 sp *)
          emit env (IR_Push_Caller_Stack_Arg (arg_vreg, offset))
        ) stack_args;
      end;

      (* 2. 寄存器传递参数 (a0-a7) *)
      List.iteri (fun i arg_vreg ->
        if i < 8 then
          emit env (IR_Mv (i+1, arg_vreg)) (* a0-a7 对应 vregs 1-8 *)
      ) arg_vregs;

      (* 3. 调用函数 *)
      emit env (IR_Call func_name);
      
      (* 4. 获取返回值 (总是在 a0, 对应 vreg 1) *)
      emit env (IR_Mv (rd, 1)); 

      (* 5. 恢复栈指针 *)
      if num_stack_args > 0 then begin
        emit env (IR_Adjust_SP stack_args_size);
      end;
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
          let label_false = fresh_label  "and_false" in
          let label_end = fresh_label  "and_end" in
          emit env (IR_Beqz (r1, label_false));
          emit env (IR_Beqz (r2, label_false));
          emit env (IR_Li (rd, 1));
          emit env (IR_J label_end);
          emit env (IR_Label label_false);
          emit env (IR_Li (rd, 0));
          emit env (IR_Label label_end)
      | Or ->
          let label_true = fresh_label  "or_true" in
          let label_end = fresh_label  "or_end" in
          emit env (IR_Bnez (r1, label_true));
          emit env (IR_Bnez (r2, label_true));
          emit env (IR_Li (rd, 0));
          emit env (IR_J label_end);
          emit env (IR_Label label_true);
          emit env (IR_Li (rd, 1));
          emit env (IR_Label label_end)
      );
      rd
;;

let rec compile_cond env cond false_label: unit =
  match cond with
  | EUnop (Not, e) ->
    (* 取反条件 *)
    let cond_vreg = compile_expr env e in
    emit env (IR_Bnez (cond_vreg, false_label));
  | EBinop(binop, e1, e2) -> (
    match binop with
    | Eq -> 
      let r1 = compile_expr env e1 in
      let r2 = compile_expr env e2 in
      emit env (IR_Bne (r1, r2, false_label));
    | Neq -> 
      let r1 = compile_expr env e1 in
      let r2 = compile_expr env e2 in
      emit env (IR_Beq (r1, r2, false_label));
    | Lt -> 
      let r1 = compile_expr env e1 in
      let r2 = compile_expr env e2 in
      emit env (IR_Bge (r1, r2, false_label));
    | Le -> 
      let r1 = compile_expr env e1 in
      let r2 = compile_expr env e2 in
      emit env (IR_Blt (r2, r1, false_label));
    | Gt -> 
      let r1 = compile_expr env e1 in
      let r2 = compile_expr env e2 in
      emit env (IR_Bge (r2, r1, false_label));
    | Ge -> 
      let r1 = compile_expr env e1 in
      let r2 = compile_expr env e2 in
      emit env (IR_Blt (r1, r2, false_label));
    | And -> 
      compile_cond env e1 false_label;
      compile_cond env e2 false_label;
    | Or -> 
      let next_label = fresh_label "or_true" in
      let cond_vreg1 = compile_expr env e1 in
      emit env (IR_Bnez (cond_vreg1, next_label));
      compile_cond env e2 false_label;
      emit env (IR_Label next_label);
    | _ -> 
      let cond_vreg = compile_expr env cond in
      emit env (IR_Beqz (cond_vreg, false_label));
  )
  | _ ->
    let cond_vreg = compile_expr env cond in
    emit env (IR_Beqz (cond_vreg, false_label));
;;
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
      env.var_env <- add_var env.var_env name init_vreg;
  | SAssign (name, expr) ->
      let val_vreg = compile_expr env expr in
      let dest_vreg = find_var env.var_env name in
      emit env (IR_Mv (dest_vreg, val_vreg))
  | SIf (cond, then_s, else_opt) ->
      let else_label = fresh_label "else" in
      let end_label = fresh_label "endif" in
      compile_cond env cond else_label;
      compile_stmt env then_s;
      emit env (IR_J end_label);
      emit env (IR_Label else_label);
      (match else_opt with
      | Some s -> compile_stmt env s
      | None -> ());
      emit env (IR_Label end_label)
  | SWhile (cond, body) ->
    let start_label = fresh_label  "while_start" in
    let continue_label = fresh_label  "while_continue" in
    let end_label = fresh_label  "while_end" in
    let old_loop = env.current_loop in
    (* continue 跳转到 continue_label, break 跳转到 end_label *)
    env.current_loop <- Some (continue_label, end_label);

    emit env (IR_Label start_label);
    compile_cond env cond end_label;
    compile_stmt env body;

    emit env (IR_Label continue_label); (* continue 跳转点 *)
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
  | SBlock stmts -> 
    env.var_env <- in_var env.var_env;
    List.iter (compile_stmt env) stmts;
    env.var_env <- out_var env.var_env;
;;

(* 编译一个函数 *)
let compile_func (func_def: func_def) return_label =
  let env = init_compile_env () in
  env.current_func_return_label <- return_label;

  (* 处理参数: 将参数从物理寄存器/栈移动到新的虚拟寄存器 *)
  let param_pregs = [1; 2; 3; 4; 5; 6; 7; 8] in (* vregs for a0-a7 *)
  let rec process_params params param_idx =
    match params with
    | P name :: rest_params ->
        let param_vreg = fresh_vreg env in
        if param_idx < 8 then begin
            (* 寄存器参数 *)
            let preg_vreg = List.nth param_pregs param_idx in
            emit env (IR_Mv (param_vreg, preg_vreg));
        end else begin
            (* 栈参数. 偏移量相对于 s0 (帧指针) *)
            (* 第一个栈参数 (即第9个参数，param_idx = 8) 位于 s0 向上 0 字节处 *)
            (* param_idx = 8 => offset = 0 *)
            (* param_idx = 9 => offset = 4 *)
            let offset_from_fp = (param_idx - 8) * 4 in
            emit env (IR_Load_Callee_Stack_Arg (param_vreg, offset_from_fp));
        end;
        env.var_env <- add_var env.var_env name param_vreg;
        process_params rest_params (param_idx + 1)
    | [] -> ()
  in
  process_params func_def.params 0;

  (* 编译函数体 *)
  compile_stmt env func_def.body;

  (List.rev env.instructions, env)
;;

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
;;

(* 遍历AST以确定函数是否为叶子函数 (不调用其他函数) *)
let rec is_leaf_function_body stmt =
  match stmt with
  | SEmpty | SBreak | SContinue -> true
  | SExpr e -> is_leaf_function_expr e
  | SReturn exp_opt ->
      (match exp_opt with
      | Some e -> is_leaf_function_expr e
      | None -> true)
  | SDeclare (_, expr) -> is_leaf_function_expr expr
  | SAssign (_, expr) -> is_leaf_function_expr expr
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

(* 将源代码生成为IR形式 *)
let gen_ir_func (func: func_def) = 
  let return_label = func.name ^ "_return" in
  let (instrs, _) = compile_func func return_label in
  let instrs = run_peephole_to_fixed_point instrs in
  {
    return_type = func.return_type;
    return_label = return_label;
    name = func.name;
    params = func.params;
    body = instrs;
    is_leaf = func.name <> "main" && (is_leaf_function_body func.body);
  }
;;

let generate_ir (Program funcs) = 
  Program_ir (List.map gen_ir_func funcs)
;;

(* 将其转变为字符串类型从而易于调试查看 *)
let string_of_operand = function
  | VReg n -> Printf.sprintf "v%d" n
  | Imm i -> string_of_int i
;;

let string_of_instruction = function
  | IR_Label lbl -> lbl ^ ":"
  | IR_Comment cmt -> "; " ^ cmt
  | IR_Li (rd, imm) -> Printf.sprintf "li v%d, %d" rd imm
  | IR_Mv (rd, rs) -> Printf.sprintf "mv v%d, v%d" rd rs
  | IR_Add (rd, rs1, op2) -> 
    Printf.sprintf "add v%d, v%d, %s" rd rs1 (string_of_operand op2)
  | IR_Sub (rd, rs1, op2) ->
    Printf.sprintf "sub v%d, v%d, %s" rd rs1 (string_of_operand op2)
  | IR_Mul (rd, rs1, rs2) -> Printf.sprintf "mul v%d, v%d, v%d" rd rs1 rs2
  | IR_Div (rd, rs1, rs2) -> Printf.sprintf "div v%d, v%d, v%d" rd rs1 rs2
  | IR_Rem (rd, rs1, rs2) -> Printf.sprintf "rem v%d, v%d, v%d" rd rs1 rs2
  | IR_Slli (rd, rs, shamt) -> Printf.sprintf "slli v%d, v%d, %d" rd rs shamt
  | IR_Srli (rd, rs, shamt) -> Printf.sprintf "srli v%d, v%d, %d" rd rs shamt
  | IR_Seqz (rd, rs) -> Printf.sprintf "seqz v%d, v%d" rd rs
  | IR_Snez (rd, rs) -> Printf.sprintf "snez v%d, v%d" rd rs
  | IR_Beq (rs1, rs2, lbl) -> Printf.sprintf "beq v%d, v%d, %s" rs1 rs2 lbl
  | IR_Bne (rs1, rs2, lbl) -> Printf.sprintf "bne v%d, v%d, %s" rs1 rs2 lbl
  | IR_Blt (rs1, rs2, lbl) -> Printf.sprintf "blt v%d, v%d, %s" rs1 rs2 lbl
  | IR_Bge (rs1, rs2, lbl) -> Printf.sprintf "bge v%d, v%d, %s" rs1 rs2 lbl
  | IR_Slt (rd, rs1, rs2) -> Printf.sprintf "slt v%d, v%d, v%d" rd rs1 rs2
  | IR_Sgt (rd, rs1, rs2) -> Printf.sprintf "sgt v%d, v%d, v%d" rd rs1 rs2
  | IR_Sge (rd, rs1, rs2) -> Printf.sprintf "sge v%d, v%d, v%d" rd rs1 rs2
  | IR_Lw (rd, offset, rs1) -> 
    Printf.sprintf "lw v%d, %d(v%d)" rd offset rs1
  | IR_Sw (rs, offset, rd) -> 
    Printf.sprintf "sw v%d, %d(v%d)" rs offset rd
  | IR_J lbl -> Printf.sprintf "j %s" lbl
  | IR_Beqz (rs, lbl) -> Printf.sprintf "beqz v%d, %s" rs lbl
  | IR_Bnez (rs, lbl) -> Printf.sprintf "bnez v%d, %s" rs lbl
  | IR_Call func -> Printf.sprintf "call %s" func
  | IR_Ret -> "ret"
  | IR_Adjust_SP imm -> 
    let op = if imm >= 0 then "+" else "-" in
    Printf.sprintf "addi sp, sp, %s%d" op (abs imm)
  | IR_Push_Caller_Stack_Arg (rs, offset) ->
    Printf.sprintf "sw v%d, %d(sp)" rs offset
  | IR_Load_Callee_Stack_Arg (rd, offset) ->
    Printf.sprintf "lw v%d, %d(s0)" rd offset
;;

let string_of_inst_list li =
  String.concat "\n" (List.map string_of_instruction li)
;;

let string_of_ir_program (Program_ir ir_program) = 
  String.concat "\n\n" (
    List.map (
      fun func_ir ->
        (if (func_ir.is_leaf) then "(leaf)" else "") ^
        func_ir.name ^ ":\n" ^ (string_of_inst_list func_ir.body)
    ) 
    ir_program
  )
;;