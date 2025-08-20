open Ast
(*open String_of_ast*)

module VMap = Map.Make(String)
module SSet = Set.Make(String)

(* 常量环境，即一个嵌套的哈希表*)
type const_env = int option VMap.t list

(* 创建一个新的作用域 *)
let new_scope () = [VMap.empty]

(* 推入作用域 *)
let push_scope = function env -> VMap.empty :: env

(* 弹出作用域 *)
let pop_scope = function
  | [] -> new_scope ()
  | [_] -> new_scope ()
  | _ :: rest -> rest

(* 查找变量在最近作用域中的值 *)
let rec lookup_var name = function
  | [] -> None
  | scope :: rest ->
      match VMap.find_opt name scope with
      | Some v -> Some v
      | None -> lookup_var name rest

(* 在变量最近的定义处更新其值 *)
let rec update_var name value = function
  | [] -> []
  | scope :: rest ->
      if VMap.mem name scope then
        (VMap.add name value scope) :: rest
      else
        scope :: (update_var name value rest)

(* 在当前作用域声明新变量 *)
let declare_var name value = function
  | [] -> [VMap.singleton name value]
  | scope :: rest ->
      (VMap.add name value scope) :: rest

(* 合并两个环境，将不确定的变量标记为非常量 *)
let rec merge_envs env1 env2 =
  match env1, env2 with
  | [], _ -> env2
  | _, [] -> env1
  | scope1 :: rest1, scope2 :: rest2 ->
      let merged_scope = 
        VMap.merge (fun _ v1 v2 ->
          match v1, v2 with
          | Some (Some n1), Some (Some n2) when n1 = n2 -> Some (Some n1)
          | Some _, Some _ -> Some None  (* 不同的值或其中之一不确定 *)
          | Some v, None -> Some v
          | None, Some v -> Some v
          | None, None -> None
        ) scope1 scope2
      in
      merged_scope :: (merge_envs rest1 rest2)

(* 标记变量为非常量 *)
let mark_non_constant name env =
  let rec mark_in_scopes = function
    | [] -> []
    | scope :: rest ->
        if VMap.mem name scope then
          (VMap.add name None scope) :: rest
        else
          scope :: (mark_in_scopes rest)
  in
  mark_in_scopes env

(* 判断表达式是否有副作用（不纯）*)
let expr_has_side_effects e =
  let rec check = function
   | ECall _ -> true (* 函数调用视为有副作用 *)
   | EUnop (_, e1) -> check e1
   | EBinop (_, e1, e2) -> check e1 || check e2
   | EVar _ | EInt _ -> false (* 变量读取和常量无副作用 *)
  in
  check e

(* 找出循环体中修改的变量，并在外部环境中标记为非常量 *)
let mark_modified_vars stmt env =
  let rec collect_vars s =
    match s with
    | SEmpty | SBreak | SContinue -> []
    | SExpr e -> if expr_has_side_effects e then [] else []
    | SReturn (Some e) -> if expr_has_side_effects e then [] else []
    | SReturn None -> []
    | SDeclare (name, _) -> [name]
    | SAssign (name, _) -> [name]
    | SIf (_, then_s, else_opt) ->
        let vars_then = collect_vars then_s in
        let vars_else = match else_opt with Some s -> collect_vars s | None -> [] in
        vars_then @ vars_else
    | SWhile (_, body) -> collect_vars body
    | SBlock stmts -> List.flatten (List.map collect_vars stmts)
  in
  let modified_vars = collect_vars stmt in
  List.fold_left (fun acc name -> mark_non_constant name acc) env modified_vars
;;

let pack_block stmt =
  match stmt with
  | SBlock _ -> stmt
  | st -> SBlock [st]
;;

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

(* 简化表达式 *)
(* 
  不知道为什么如果真的执行常量传播优化，那么性能测试P1将会不通过 
  尝试排查了部分env，但是还是找不到错误在哪里 
  又没有测试用例做例子，我是真的不知道怎么优化了，抱歉
*)

(* 循环最大展开次数，若超过，则取消循环展开优化 *)
let loop_count_limit = 16

(* 表达式优化（含常量折叠与展开）*)
let rec simplify_expr env = function
  | EInt _ as c -> c
  | EVar name -> 
    (match lookup_var name env with
      (*| Some (Some value) -> EInt value*)
      | _ -> EVar name)
  | EUnop (op, e) ->
      let se = simplify_expr env e in
      (match op, se with
       | Plus, _ -> se
       | Neg, EInt n -> EInt (-n)
       | Not, EInt n -> EInt (if n = 0 then 1 else 0)
       | _, _ -> EUnop (op, se))
  | EBinop (op, e1, e2) ->
      let se1 = simplify_expr env e1 in
      let se2 = simplify_expr env e2 in
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
      let sargs = List.map (simplify_expr env) args in
      ECall (name, sargs)

(* 优化语句 *)
let rec optimize_stmt (stmt, const_env) =
  match stmt with
  | SEmpty -> (SEmpty, const_env)
  | SExpr e ->
      let se = simplify_expr const_env e in
      if not (expr_has_side_effects se) 
        then (SEmpty, const_env) else (SExpr se, const_env)
  | SReturn None -> (SReturn None, const_env)
  | SReturn (Some e) -> 
    (SReturn (Some (simplify_expr const_env e)), const_env)
  | SDeclare (name, e) ->
    let se = simplify_expr const_env e in
    let const_value = match se with
      | EInt n -> Some n
      | _ -> None
    in
    let new_env = declare_var name const_value const_env in
    (SDeclare (name, se), new_env)
  | SAssign (name, expr) ->
    let se = simplify_expr const_env expr in
    let const_value = match se with
      | EInt n -> Some n
      | _ -> None
    in
    let new_env = update_var name const_value const_env in
    (SAssign (name, se), new_env)
  | SIf (cond, then_s, else_opt) ->
      let then_s = pack_block then_s in
      let else_opt = Option.map pack_block else_opt in
      let sc = simplify_expr const_env cond in(
      match sc with
        | EInt n when n <> 0 ->
          let stmt, stack = optimize_stmt (then_s, push_scope const_env) in
          (stmt, pop_scope stack)
        | EInt n when n = 0 ->(
          match else_opt with 
            | Some s -> 
              let stmt, stack = optimize_stmt (s,push_scope const_env) in
              (stmt,pop_scope stack)
            | None -> (SEmpty, const_env)
          )
        | _ ->
          let(them_stmt, env_1) = optimize_stmt (then_s,push_scope const_env) in
          let(else_stmt_opt, env_2) = 
            match else_opt with
              | Some s -> let (os, oe) = optimize_stmt (s,push_scope const_env) in 
              (Some os, oe)
              | None -> (None,push_scope const_env)
          in
          let const_env = merge_envs (pop_scope env_1) (pop_scope env_2) in
          (SIf (sc, them_stmt, else_stmt_opt), const_env)
      )
  | SWhile (cond, body) ->
      let body = pack_block body in
      let try_cond = simplify_expr const_env cond in(
      match try_cond with
      | EInt 0 -> (SEmpty, const_env) (* 如果条件为0，直接删除循环 *)
      | _ ->
        let (unrolled, new_body, new_env) = unroll_loops cond body const_env in
        if unrolled then
          (new_body, new_env) (* 如果循环展开成功，返回展开后的body和环境 *)
        else
          (* 否则继续优化循环体 *)
          let const_env = mark_modified_vars stmt const_env in
          let sc = simplify_expr const_env cond in
          let (new_body, new_env) = optimize_stmt (body, push_scope const_env) in
          let final_env = mark_modified_vars new_body new_env in
          (SWhile (sc, new_body), final_env)
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
          ([], push_scope const_env) stmts
      in
      let new_stmts_rev = List.rev new_stmts in
      let final_stmt = match new_stmts_rev with
                       | [] -> SEmpty
                       | [SDeclare (_, _)] -> SEmpty
                       | _ -> SBlock new_stmts_rev
      in
      (final_stmt, pop_scope new_env)
  | SBreak | SContinue as s -> (s, const_env)

(* 循环展开正式代码，输出展开是否成功，展开后的body和循环后的env *)
and unroll_loops cond body env = 
  (* 检测body内是否含有break和continue，若有，拒绝优化*)
  let has_break_or_continue stmt =
    let rec check s =
      match s with
      | SEmpty | SReturn _ -> false
      | SBreak | SContinue -> true
      | SExpr e -> expr_has_side_effects e
      | SIf (_, then_s, else_opt) ->
          (match else_opt with
          | None -> check then_s
          | Some else_s -> check then_s || check else_s)
      | SWhile (_, body) -> check body
      | SBlock stmts -> List.exists check stmts
      | _ -> false
    in
    check stmt
  in

  (* 将语句结合在一起的函数 *)
  let combine_stmt stmt1 stmt2 =
    match stmt1, stmt2 with
    | SBlock st1, SBlock st2 -> SBlock (st1 @ st2)
    | SBlock st1, _ -> SBlock (st1 @ [stmt2])
    | _, SBlock st2 -> SBlock ([stmt1] @ st2)
    | _ -> SBlock [stmt1; stmt2]
  in

  (* 递归展开循环 *)
  let rec unroll cond body env cur_cnt cur_stmt =
    if cur_cnt > loop_count_limit then
      (false, SEmpty, env) (* 超过限制，返回原始语句 *)
    else if has_break_or_continue body then
      (false, SEmpty, env) (* 循环体含有break或continue，拒绝展开 *)
    else
      let try_cond = simplify_expr env cond in(
      match try_cond with
      | EInt 0 -> 
        (true, cur_stmt, env) (* 条件为0，循环结束，输出 *)
      | EInt n when n <> 0 ->
        let new_body, new_env = optimize_stmt (body, env) in
        let new_stmt = combine_stmt cur_stmt new_body in
        unroll cond body new_env (cur_cnt + 1) new_stmt (* 递归展开 *)
      | _ ->
        (false, SEmpty, env) (* 无法得知是否继续，返回原始语句 *)
      )
  in

  unroll cond body env 0 SEmpty

(* --- 死代码消除 --- *)
(* 从表达式中收集被使用的变量 *)
let rec collect_reads_expr expr =
  match expr with
  | EVar name -> SSet.singleton name
  | EInt _ -> SSet.empty
  | EUnop (_, e) -> collect_reads_expr e
  | EBinop (_, e1, e2) -> SSet.union (collect_reads_expr e1) (collect_reads_expr e2)
  | ECall (_, args) -> List.fold_left (fun acc e -> SSet.union acc (collect_reads_expr e)) SSet.empty args

(* 在语句中收集被使用的变量 *)
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

(* 去除死代码生成的部分 *)
(* 去除死代码的时候感觉也得考虑一下作用域的问题啊…… *)
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
      | [SDeclare (_, _)] -> SEmpty
      | ss -> SBlock ss)
  | other -> other

let dce_pass stmt =
  let used_vars = collect_reads_stmt stmt in
  dce_stmt used_vars stmt

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
        let simplified_args = List.map (simplify_expr (new_scope ()) ) args in
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
  let (body1, _) = optimize_stmt (f.body, new_scope () )  in
  let body2 = dce_pass body1 in

  (*
  print_endline ("Optimizing function: " ^ f.name);
  print_endline (string_of_stmt "" body2);
  print_endline "";*)

  { f with body = body2 }

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