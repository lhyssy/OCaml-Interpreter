open Interpreter_lib.Ast
open Interpreter_lib.Optimizer
open Interpreter_lib.Codegen

(* Helper function to convert a list of items to a string *)
let string_of_list ?(sep=", ") f l =
  "[" ^ (String.concat sep (List.map f l)) ^ "]"

let string_of_typ = function
  | TInt -> "int"
  | TVoid -> "void"

let string_of_unop = function
  | Neg -> "-"
  | Not -> "!"
  | Plus -> "+"

let string_of_binop =
  let module Ast = Interpreter_lib.Ast in
  function
  | Ast.Add -> "+" | Ast.Sub -> "-" | Ast.Mul -> "*" | Ast.Div -> "/" | Ast.Mod -> "%"
  | Ast.Eq -> "==" | Ast.Neq -> "!=" | Ast.Lt -> "<" | Ast.Le -> "<=" | Ast.Gt -> ">" | Ast.Ge -> ">="
  | Ast.And -> "&&" | Ast.Or -> "||"

let rec string_of_expr = function
  | EInt i -> string_of_int i
  | EVar v -> v
  | EUnop (op, e) -> "(" ^ string_of_unop op ^ " " ^ string_of_expr e ^ ")"
  | EBinop (op, e1, e2) -> "(" ^ string_of_expr e1 ^ " " ^ string_of_binop op ^ " " ^ string_of_expr e2 ^ ")"
  | ECall (name, args) -> name ^ "(" ^ String.concat ", " (List.map string_of_expr args) ^ ")"

let rec string_of_stmt indent = function
  | SEmpty -> indent ^ ";"
  | SExpr e -> indent ^ string_of_expr e ^ ";"
  | SReturn None -> indent ^ "return;"
  | SReturn (Some e) -> indent ^ "return " ^ string_of_expr e ^ ";"
  | SIf (cond, then_s, else_s_opt) ->
      let if_str = indent ^ "if (" ^ string_of_expr cond ^ ")\n" ^ string_of_stmt (indent ^ "  ") then_s in
      if_str ^
      (match else_s_opt with
      | None -> ""
      | Some else_s -> "\n" ^ indent ^ "else\n" ^ string_of_stmt (indent ^ "  ") else_s)
  | SWhile (cond, body) ->
      indent ^ "while (" ^ string_of_expr cond ^ ")\n" ^ string_of_stmt (indent ^ "  ") body
  | SBlock stmts ->
      indent ^ "{\n" ^
      String.concat "\n" (List.map (string_of_stmt (indent ^ "  ")) stmts) ^
      "\n" ^ indent ^ "}"
  | SBreak -> indent ^ "break;"
  | SContinue -> indent ^ "continue;"
  | SDeclare (name, expr) -> indent ^ "int " ^ name ^ " = " ^ string_of_expr expr ^ ";"
  | SAssign (name, expr) -> indent ^ name ^ " = " ^ string_of_expr expr ^ ";"

let string_of_param = function
  | P name -> "int " ^ name

let string_of_func_def (f: func_def) =
  let return_type_str = string_of_typ f.return_type in
  let params_str = String.concat ", " (List.map string_of_param f.params) in
  let body_str = string_of_stmt "  " f.body in
  return_type_str ^ " " ^ f.name ^ "(" ^ params_str ^ ") {\n" ^
  body_str ^
  "\n}\n"

let string_of_program (Program funcs) =
  String.concat "\n" (List.map string_of_func_def funcs)

let parse_input in_channel filename =
  let lexbuf = Lexing.from_channel in_channel in
  Lexing.set_filename lexbuf filename;
  try
    Interpreter_lib.Parser.comp_unit Interpreter_lib.Lexer.token lexbuf
  with
  | Parsing.Parse_error ->
    let pos = lexbuf.lex_curr_p in
    Printf.eprintf "Syntax error at %s:%d:%d\n"
      pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol);
    exit 1
  | Failure msg ->
    let pos = lexbuf.lex_curr_p in
    Printf.eprintf "Lexical error at %s:%d:%d: %s\n"
        pos.pos_fname pos.pos_lnum (pos.pos_cnum - pos.pos_bol) msg;
    exit 1

let generate_output ast =
  let asm_code = generate_riscv ast in
  output_string stdout asm_code

let () =
  let ast = parse_input stdin "<stdin>" in
  (* 进行优化 *)
  let optimized_ast = optimize_program ast in
  
  (* 输出AST信息 *)
  if Array.length Sys.argv > 1 && Sys.argv.(1) = "-ast" then
    print_endline (string_of_program optimized_ast)
  else
    (* 生成汇编代码并输出到 stdout *)
    generate_output optimized_ast
