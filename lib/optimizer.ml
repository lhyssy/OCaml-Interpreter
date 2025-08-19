open Ast

module VMap = Map.Make(String)
module SSet = Set.Make(String)

type env_stack = {
  current: (int option) VMap.t;  (* 当前作用域 *)
  parent: env_stack option (* 仅允许访问直接父级 *)
}

let new_env_stack () =
  { current = VMap.empty; parent = None }

let rec lookup_var stack name =
  match stack with
  | {current; parent} ->
      match VMap.find_opt name current with
      | Some v -> v
      | None -> 
          match parent with
          | Some p -> lookup_var p name
          | None -> None (* 严格作用域隔离 *)
;;

let add_var stack name value =
  { current = VMap.add name (Some value) stack.current; parent = stack.parent }
;;

let rec update_stack stack name value =
  if VMap.mem name stack.current then
    { current = VMap.add name value stack.current; parent = stack.parent }
  else
    match stack.parent with
    | Some parent -> { current = stack.current; parent = Some (update_stack parent name value) }
    | None -> stack (* 如果没有父级，则不更新 *)
;;

let rec remove_var_through stack name = 
  let new_cur = VMap.add name None stack.current in
  let new_parent = 
    match stack.parent with
    | Some p -> Some (remove_var_through p name)
    | None -> None
  in
  { current = new_cur; parent = new_parent }
;;

let rec merge_stacks stack1 stack2 =
  let merge_vmap st1 st2 = VMap.merge (fun _ v1 v2 ->
      match v1, v2 with
      | Some (Some n), Some (Some m) -> Some ((if n = m then Some(n) else None))
      | Some (Some _), Some (None) 
      | Some (None), Some (Some _)
      | Some (None), Some (None) -> Some (None)
      | _ ->
        (*Printf.printf "Warning: Merging varible has unknown value\n"; *)
        None
  ) st1 st2 in

  let merged_current = merge_vmap stack1.current stack2.current in
  let merged_parent = 
    match stack1.parent, stack2.parent with
    | Some p1, Some p2 -> Some (merge_stacks p1 p2)
    | Some p, None -> Some p
    | None, Some p -> Some p
    | None, None -> None
  in
  { current = merged_current; parent = merged_parent }
;;

let enter_stack stack =
  { current = VMap.empty; parent = Some stack } (* 进入新作用域，当前作用域为空 *)
;;

let exit_stack stack =
  match stack.parent with
  | Some parent -> parent (* 返回到父级作用域 *)
  | None -> new_env_stack () (* 如果没有父级，则返回一个新的空栈 *)
;;

let rec remove_const stack stmt = 
  match stmt with
  | SAssign (name, _) ->
      remove_var_through stack name
  | SDeclare (name, _) ->
      remove_var_through stack name
  | SBlock stmts ->
      List.fold_left remove_const stack stmts
  | SIf (_, then_s, else_s_opt) ->
      let stack = remove_const stack then_s in
      (match else_s_opt with
      | Some else_s -> remove_const stack else_s
      | None -> stack)
  | SWhile (_, body) ->
      remove_const stack body
  | _ -> stack
;;

(*
let print_stack stack =
  let rec string_of_stack st =
    match st with
    | {current; parent} -> 
      let cur_str = String.concat ", " (VMap.bindings current 
      |> List.map (fun (k, v) -> k ^ ": " ^ string_of_int v)) in
      match parent with
      | Some p -> cur_str ^ " | " ^ string_of_stack p
      | None -> cur_str
  in
  Printf.printf "Current scope: %s\n" (string_of_stack stack);
;;*)

(* 计算二元运算结果 *)
let eval_binop op n1 n2 =
  match op with
  | Add -> n1 + n2
  | Sub -> n1 - n2
  | Mul -> n1 * n2
  | Div -> if n2 <> 0 then n1 / n2 else failwith "Division by zero"
  | Mod -> if n2 <> 0 then n1 mod n2 else failwith "Modulo by zero"
  | Eq  -> if n1 = n2 then 1 else 0
  | Neq -> if n1 <> n2 then 1 else 0
  | Lt  -> if n1 <  n2 then 1 else 0
  | Le  -> if n1 <= n2 then 1 else 0
  | Gt  -> if n1 >  n2 then 1 else 0
  | Ge  -> if n1 >= n2 then 1 else 0
  | And -> if (n1 <> 0 && n2 <> 0) then 1 else 0
  | Or  -> if (n1 <> 0 || n2 <> 0) then 1 else 0

(* 判断表达式是否有副作用（不纯）*)
let expr_has_side_effects e =
  let rec check = function
   | ECall _ -> true (* 函数调用视为有副作用 *)
   | EUnop (_, e1) -> check e1
   | EBinop (_, e1, e2) -> check e1 || check e2
   | EVar _ | EInt _ -> false (* 变量读取和常量无副作用 *)
  in
  check e

(* 简化表达式 *)
let rec simplify_expr stack_env expr =
  match expr with
  | EInt _ as c -> c
  | EVar name -> 
    (* 
    不知道为什么如果真的执行此优化，那么性能测试P1将会不通过 
    尝试排查了部分env，但是还是找不到错误在哪里 
    又没有测试用例做例子，我是真的不知道怎么优化了，抱歉
    *)
    (match lookup_var stack_env name  with
      (*| Some n -> EInt n *)
      | _ -> EVar name
    )
  | EUnop (op, e) ->
      let se = simplify_expr stack_env e in
      (match op, se with
       | Plus, _ -> se
       | Neg, EInt n -> EInt (-n)
       | Not, EInt n -> EInt (if n = 0 then 1 else 0)
       | _, _ -> EUnop (op, se))
  | EBinop (op, e1, e2) ->
      let se1 = simplify_expr stack_env e1 in
      let se2 = simplify_expr stack_env e2 in
      (match se1, se2 with
       | EInt n1, EInt n2 -> 
           (* 常量折叠 *)
           (try EInt (eval_binop op n1 n2)
            with _ -> EBinop (op, se1, se2))
       | _, _ ->
           (* 代数简化 *)
           (match op with
            | Add -> 
                (match se1, se2 with
                 | EInt 0, e -> e
                 | e, EInt 0 -> e
                 | EInt n1, EBinop(Add, EInt n2, e) -> EBinop(Add, EInt(n1 + n2), e) (* 合并常量: (C1 + (C2 + E)) -> ((C1+C2) + E) *)
                 | EInt n1, EBinop(Add, e, EInt n2) -> EBinop(Add, EInt(n1 + n2), e)
                 | EVar v1, EVar v2 when v1 = v2 -> EBinop(Mul, EInt 2, se1) (* x + x = 2 * x *)
                 | _, _ -> EBinop (Add, se1, se2))
            | Mul -> 
                (match se1, se2 with
                 | EInt 0, _ -> EInt 0
                 | _, EInt 0 -> EInt 0
                 | EInt 1, e -> e
                 | e, EInt 1 -> e
                 | EInt (-1), e -> EUnop(Neg, e)
                 | e, EInt (-1) -> EUnop(Neg, e)
                 | EInt n1, EBinop(Mul, EInt n2, e) -> EBinop(Mul, EInt(n1 * n2), e) (* 合并常量: (C1 * (C2 * E)) -> ((C1*C2) * E) *)
                 | EInt n1, EBinop(Mul, e, EInt n2) -> EBinop(Mul, EInt(n1 * n2), e)
                 | _, _ -> EBinop (Mul, se1, se2))
            | Div -> 
                (match se1, se2 with
                 | EInt 0, _ -> EInt 0
                 | e, EInt 1 -> e
                 | e, EInt (-1) -> EUnop(Neg, e)
                 | EInt n1, EInt n2 when n1 mod n2 = 0 -> EInt (n1 / n2) (* 除法结果为整数时直接计算 *)
                 | _, _ -> EBinop (Div, se1, se2))
            | Sub -> 
                (match se1, se2 with
                 | e, EInt 0 -> e
                 | EInt n1, EInt n2 -> EInt (n1 - n2) (* 常量折叠 *)
                 | EVar v1, EVar v2 when v1 = v2 -> EInt 0 (* x - x = 0 *)
                 | _, _ -> EBinop (Sub, se1, se2))
            | Mod ->
                (match se1, se2 with
                 | EInt 0, _ -> EInt 0 (* 0 % n = 0 *)
                 | _, EInt 1 -> EInt 0 (* n % 1 = 0 *)
                 | _, EInt (-1) -> EInt 0
                 | EInt n1, EInt n2 when n2 <> 0 -> EInt (n1 mod n2) (* 常量折叠 *)
                 | _, _ -> EBinop (Mod, se1, se2))
            | Eq ->
                (match se1, se2 with
                 | EInt n1, EInt n2 -> EInt (if n1 = n2 then 1 else 0) (* 常量折叠 *)
                 | EVar v1, EVar v2 when v1 = v2 -> EInt 1 (* x == x = 1 *)
                 | _, _ -> EBinop (Eq, se1, se2))
            | Neq ->
                (match se1, se2 with
                 | EInt n1, EInt n2 -> EInt (if n1 <> n2 then 1 else 0) (* 常量折叠 *)
                 | EVar v1, EVar v2 when v1 = v2 -> EInt 0 (* x != x = 0 *)
                 | _, _ -> EBinop (Neq, se1, se2))
            | Lt | Le | Gt | Ge as op ->
                (match se1, se2 with
                 | EInt n1, EInt n2 -> EInt (eval_binop op n1 n2) (* 常量折叠 *)
                 | EVar v1, EVar v2 when v1 = v2 -> (* 自比较优化 *)
                   (match op with
                    | Lt | Gt -> EInt 0 (* x < x 或 x > x 始终为假 *)
                    | Le | Ge -> EInt 1 (* x <= x 或 x >= x 始终为真 *)
                    | _ -> failwith "Unreachable code")
                 | _, _ -> EBinop (op, se1, se2))
            | And ->
                (match se1, se2 with
                 | EInt 0, _ | _, EInt 0 -> EInt 0 (* 0 && e 或 e && 0 = 0 *)
                 | EInt n1, e when n1 <> 0 -> e (* 1 && e = e *)
                 | e, EInt n2 when n2 <> 0 -> e (* e && 1 = e *)
                 | EInt n1, EInt n2 -> EInt (if n1 <> 0 && n2 <> 0 then 1 else 0) (* 常量折叠 *)
                 | _, _ -> EBinop (And, se1, se2))
            | Or ->
                (match se1, se2 with
                 | EInt n1, _ when n1 <> 0 -> EInt 1 (* 1 || e = 1 *)
                 | _, EInt n2 when n2 <> 0 -> EInt 1 (* e || 1 = 1 *)
                 | EInt 0, e -> e (* 0 || e = e *)
                 | e, EInt 0 -> e (* e || 0 = e *)
                 | EInt n1, EInt n2 -> EInt (if n1 <> 0 || n2 <> 0 then 1 else 0) (* 常量折叠 *)
                 | _, _ -> EBinop (Or, se1, se2))))
  | ECall (name, args) ->
      let sargs = List.map (simplify_expr stack_env) args in
      ECall (name, sargs)

(* 优化语句 *)
let rec optimize_stmt (stmt, const_env) =
  match stmt with
  | SEmpty -> (SEmpty, const_env)
  | SExpr e ->
      let se = simplify_expr const_env e in
      if not (expr_has_side_effects se) then (SEmpty, const_env) else (SExpr se, const_env)
  | SReturn None -> (SReturn None, const_env)
  | SReturn (Some e) -> 
    (SReturn (Some (simplify_expr const_env e)), const_env)
  | SDeclare (name, e) ->
      let se = simplify_expr const_env e in
      let new_env = 
        match se with
        | EInt n -> add_var const_env name n
        | _ -> update_stack const_env name None
      in
      (SDeclare (name, se), new_env)
  | SAssign (name, expr) ->
    let se = simplify_expr const_env expr in
    let new_stack = match se with
    | EInt n -> update_stack const_env name (Some n)
    | _ -> update_stack const_env name None
    in
    (SAssign (name, se), new_stack)
  | SIf (cond, then_s, else_opt) ->
      let sc = simplify_expr const_env cond in(
      match sc with
        | EInt n when n <> 0 ->
          let stmt, stack = optimize_stmt (then_s, enter_stack const_env) in
          (stmt, exit_stack stack)
        | EInt n when n = 0 ->(
          match else_opt with 
            | Some s -> 
              let stmt, stack = optimize_stmt (s, enter_stack const_env) in
              (stmt, exit_stack stack)
            | None -> (SEmpty, const_env)
          )
        | _ ->
           let (st, st1) = optimize_stmt (then_s, enter_stack const_env) in
           let (se_opt, st2) = 
            match else_opt with
              | Some s -> let (os, oe) = 
              optimize_stmt (s, enter_stack const_env) in (Some os, oe)
              | None -> (None, enter_stack const_env)
           in
           let const_env = merge_stacks st1 st2 in
           (SIf (sc, st, se_opt), const_env)
      )
  | SWhile (cond, body) ->
      let try_cond = simplify_expr const_env cond in(
      match try_cond with
      | EInt 0 -> (SEmpty, const_env) (* 如果条件为0，直接删除循环 *)
      | _ ->
        let const_env = remove_const const_env stmt in
        let sc = simplify_expr const_env cond in
        let (new_body, _) = optimize_stmt (body, enter_stack const_env) in
        (SWhile (sc, new_body), const_env)
      )
  | SBlock stmts ->
      let (new_stmts, new_env) =
        List.fold_left
          (fun (acc_stmts, current_env) s ->
            let (os, next_env) = optimize_stmt (s, current_env) in
            match os with
            | SEmpty -> (acc_stmts, next_env)
            | SReturn _ -> (os :: acc_stmts, next_env) (* Stop processing after return *)
            | _ -> (os :: acc_stmts, next_env)
          )
          ([], enter_stack const_env) stmts
      in
      let new_stmts_rev = List.rev new_stmts in
      let final_stmt = match new_stmts_rev with
                       | [] -> SEmpty
                       | [single] -> single
                       | _ -> SBlock new_stmts_rev
      in
      (final_stmt, exit_stack new_env)
  | SBreak | SContinue as s -> (s, const_env)
;;

(* --- Dead Code Elimination --- *)

(* Collect variables read in an expression *)
let rec collect_reads_expr expr =
  match expr with
  | EVar name -> SSet.singleton name
  | EInt _ -> SSet.empty
  | EUnop (_, e) -> collect_reads_expr e
  | EBinop (_, e1, e2) -> SSet.union (collect_reads_expr e1) (collect_reads_expr e2)
  | ECall (_, args) -> List.fold_left (fun acc e -> SSet.union acc (collect_reads_expr e)) SSet.empty args

(* Collect variables read in a statement *)
let rec collect_reads_stmt stmt =
  match stmt with
  | SEmpty | SBreak | SContinue | SReturn None -> SSet.empty
  | SExpr e | SReturn (Some e) | SDeclare (_, e) | SAssign (_, e) -> collect_reads_expr e
  | SIf (cond, then_s, else_opt) ->
      let used = collect_reads_expr cond in
      let used_then = collect_reads_stmt then_s in
      let used_else = match else_opt with Some s -> collect_reads_stmt s | None -> SSet.empty in
      SSet.union used (SSet.union used_then used_else)
  | SWhile (cond, body) ->
      SSet.union (collect_reads_expr cond) (collect_reads_stmt body)
  | SBlock stmts ->
      List.fold_left (fun acc s -> SSet.union acc (collect_reads_stmt s)) SSet.empty stmts

(* The DCE transformation pass *)
let rec dce_stmt used_vars stmt =
  match stmt with
  | SDeclare (name, e) ->
      if SSet.mem name used_vars || expr_has_side_effects e then
        stmt
      else
        SEmpty
  | SAssign (name, e) ->
      if SSet.mem name used_vars || expr_has_side_effects e then
        stmt
      else
        SEmpty
  | SIf (cond, then_s, else_opt) ->
      SIf (cond, dce_stmt used_vars then_s, Option.map (dce_stmt used_vars) else_opt)
  | SWhile (cond, body) ->
      SWhile (cond, dce_stmt used_vars body)
  | SBlock stmts ->
      let new_stmts = List.map (dce_stmt used_vars) stmts in
      let filtered_stmts = List.filter (function SEmpty -> false | _ -> true) new_stmts in
      (match filtered_stmts with
      | [] -> SEmpty
      | [s] -> s
      | ss -> SBlock ss)
  | other -> other

let dce_pass stmt =
  let used_vars = collect_reads_stmt stmt in
  dce_stmt used_vars stmt

(* --- Loop Unrolling --- *)
let unroll_loops (stmt, env_stack) = (* 参数改为env_stack *)
  let rec unroll_stmt s =
    match s with
    | SWhile (EBinop(Le, EVar loop_var, EInt max_val), SBlock body) ->
        let start_val = 
          match lookup_var env_stack loop_var with
          | Some n when n > 0 && n <= max_val -> n
          | _ -> -1 (* 无法展开 *)
        in
        if start_val > 0 then
          let unrolled_body = ref [] in
          let current_val = ref start_val in
          while !current_val <= max_val do
            (* 创建带新作用域的栈 *)
            let iter_stack = 
              add_var env_stack loop_var !current_val 
            in
            let (unrolled_iter_body, _) = 
              optimize_stmt (SBlock body, iter_stack)
            in
            unrolled_body := unrolled_iter_body :: !unrolled_body;
            current_val := !current_val + 1
          done;
          SBlock (List.rev !unrolled_body)
        else s
    | SIf (c, ts, es) -> SIf (c, unroll_stmt ts, Option.map unroll_stmt es)
    | SBlock stmts -> SBlock (List.map unroll_stmt stmts)
    | other -> other
  in
  unroll_stmt stmt


(* --- Function Inlining --- *)

(* A simple counter for generating unique variable names during inlining. *)
let unique_id = ref 0
let fresh_name name =
  unique_id := !unique_id + 1;
  "__" ^ name ^ "_" ^ (string_of_int !unique_id)

(* Substitution map for renaming variables. *)

let rec substitute_vars_expr (map: Ast.expr VMap.t) expr =
  match expr with
  | EVar v -> (try VMap.find v map with Not_found -> EVar v)
  | EUnop (op, e) -> EUnop (op, substitute_vars_expr map e)
  | EBinop (op, e1, e2) -> EBinop (op, substitute_vars_expr map e1, substitute_vars_expr map e2)
  | ECall (name, args) -> ECall (name, List.map (substitute_vars_expr map) args)
  | EInt _ as i -> i

let rec substitute_vars_stmt (map: Ast.expr VMap.t) stmt =
  let substitute_name name =
    try match VMap.find name map with
        | EVar new_name -> new_name
        | _ -> name
    with Not_found -> name
  in
  match stmt with
  | SEmpty | SBreak | SContinue -> stmt
  | SExpr e -> SExpr (substitute_vars_expr map e)
  | SReturn (Some e) -> SReturn (Some (substitute_vars_expr map e))
  | SReturn None -> SReturn None
  | SDeclare (name, e) -> SDeclare (substitute_name name, substitute_vars_expr map e)
  | SAssign (name, e) -> SAssign (substitute_name name, substitute_vars_expr map e)
  | SIf (cond, then_s, else_s) ->
      SIf (substitute_vars_expr map cond,
           substitute_vars_stmt map then_s,
           Option.map (substitute_vars_stmt map) else_s)
  | SWhile (cond, body) ->
      SWhile (substitute_vars_expr map cond, substitute_vars_stmt map body)
  | SBlock stmts -> SBlock (List.map (substitute_vars_stmt map) stmts)


let get_all_decls_stmt stmt =
  let rec walk acc_decls s =
    match s with
    | SDeclare (name, _) -> VMap.add name name acc_decls
    | SIf (_, ts, Some es) ->
        let acc = walk acc_decls ts in
        walk acc es
    | SIf (_, ts, None) -> walk acc_decls ts
    | SWhile (_, body) -> walk acc_decls body
    | SBlock stmts -> List.fold_left walk acc_decls stmts
    | _ -> acc_decls
  in
  walk VMap.empty stmt

let perform_inlining (target_var: string) (func_def: func_def) (args: expr list) =
  (* 1. Create unique names for all params and local vars of the func to be inlined. *)
  let param_names = List.map (function P n -> n) func_def.params in
  let local_decls = get_all_decls_stmt func_def.body in
  
  let subst_map = ref VMap.empty in
  List.iter (fun p -> subst_map := VMap.add p (EVar (fresh_name p)) !subst_map) param_names;
  VMap.iter (fun l _ -> subst_map := VMap.add l (EVar (fresh_name l)) !subst_map) local_decls;
  
  let get_new_name_for v = match VMap.find v !subst_map with EVar n -> n | _ -> failwith "invalid map" in
  
  (* 2. Create SDeclare statements to assign call-site args to the new unique param names. *)
  let arg_setup_stmts =
    List.map2
      (fun p_name arg_expr -> SDeclare (get_new_name_for p_name, arg_expr))
      param_names args
  in
  
  (* 3. Substitute the body of the function. *)
  let substituted_body = substitute_vars_stmt !subst_map func_def.body in

  (* 4. In the new body, replace SReturn with SAssign to the target variable. *)
  let rec replace_return_stmt stmt =
    match stmt with
    | SReturn (Some e) -> SAssign (target_var, e)
    | SIf (c, ts, es) -> SIf (c, replace_return_stmt ts, Option.map replace_return_stmt es)
    | SWhile (c, b) -> SWhile (c, replace_return_stmt b)
    | SBlock stmts -> SBlock (List.map replace_return_stmt stmts)
    | other -> other
  in
  let final_body = replace_return_stmt substituted_body in
  
  SBlock (arg_setup_stmts @ [final_body])

let inline_pass (Program funcs) =
  let func_map = Hashtbl.create (List.length funcs) in
  List.iter (fun f -> Hashtbl.add func_map f.name f) funcs;

  (* Simple heuristic: inline non-recursive functions called in assignments. *)
  let is_recursive func =
    let rec check_expr = function
      | ECall (name, _) -> name = func.name
      | EUnop (_, e) -> check_expr e
      | EBinop (_, e1, e2) -> check_expr e1 || check_expr e2
      | _ -> false
    in
    let rec check_stmt = function
      | SExpr e | SReturn (Some e) | SDeclare (_, e) | SAssign (_, e) -> check_expr e
      | SIf (c, ts, es) -> check_expr c || check_stmt ts || (match es with Some s -> check_stmt s | _ -> false)
      | SWhile (c, b) -> check_expr c || check_stmt b
      | SBlock stmts -> List.exists check_stmt stmts
      | _ -> false
    in
    check_stmt func.body
  in
  
  let non_recursive_funcs = Hashtbl.create (List.length funcs) in
  List.iter (fun f -> if not (is_recursive f) then Hashtbl.add non_recursive_funcs f.name ()) funcs;

  let rec inline_stmt_pass stmt =
    match stmt with
    | SAssign (v, ECall (name, args)) when Hashtbl.mem non_recursive_funcs name ->
        let func_to_inline = Hashtbl.find func_map name in
        let simplified_args = List.map (simplify_expr (new_env_stack ()) ) args in
        perform_inlining v func_to_inline simplified_args
    | SIf (c, ts, es) -> SIf(c, inline_stmt_pass ts, Option.map inline_stmt_pass es)
    | SWhile (c, b) -> SWhile(c, inline_stmt_pass b)
    | SBlock stmts -> SBlock (List.map inline_stmt_pass stmts)
    | other -> other
  in
  
  let new_funcs = List.map (fun f -> { f with body = inline_stmt_pass f.body }) funcs in
  Program new_funcs


(* 优化函数 *)
let optimize_func (f: func_def) : func_def =
  (*print_endline ("Optimizing function: " ^ f.name);*)
  let (body1, env1) = optimize_stmt (f.body, new_env_stack () )  in
  let body2 = unroll_loops (body1, env1) in
  (*
  print_endline (string_of_stmt "" body2);
  print_endline "";*)
  
  let (body3, _) = optimize_stmt (body2, new_env_stack () ) in
  let body4 = dce_pass body3 in
  (*
  print_endline (string_of_stmt "" body4);
  print_endline "";*)

  { f with body = body4 }

let optimize_program (Program funcs) =
  let rec run_to_fixed_point p =
    let inlined_p = inline_pass p in
    let (Program funcs) = inlined_p in
    let optimized_funcs = List.map optimize_func funcs in
    let final_p = Program optimized_funcs in
    (* Compare original program with the result of one full optimization pass *)
    if p = final_p then
      final_p
    else
      run_to_fixed_point final_p
  in
  run_to_fixed_point (Program funcs)