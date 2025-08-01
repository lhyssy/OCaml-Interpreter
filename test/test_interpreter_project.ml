open Interpreter_lib.String_of_ast
open Interpreter_lib.Optimizer
open Interpreter_lib.Optimizer2
open Interpreter_lib.Irgen
open Interpreter_lib.Codegen

(* 跟main差不多但是是把所有测试源程序编译成汇编，放置于对应位置 *)
let filenames = [
  "01_minimal";
  "02_assignment";
  "03_if_else";
  "04_while_break";
  "05_function_call";
  "06_continue";
  "07_scope_shadow";
  "08_short_circuit";
  "09_recursion";
  "10_void_fn";
  "11_precedence";
  "12_division_check";
  "13_scope_block";
  "14_nested_if_while";
  "15_multiple_return_paths";
  "16_complex_syntax";
  "17_complex_expressions";
  "18_many_variables";
  "19_many_arguments";
  "20_comprehensive";
  "test";
]

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
;;

let test_file filename =
  let in_filepath = 
  let project_root = Sys.getenv "PWD" in  (* 获取项目根目录 *)
  Filename.concat project_root ("test/" ^ filename ^ ".tc") in

  let out_filepath =
  let build_dir = Sys.getenv "PWD" in  (* 构建目录 *)
  Filename.concat build_dir ("test_results/" ^ filename ^ ".s") in

  reset_label_count ();

  let in_channel = open_in in_filepath in
  let out_channel = open_out out_filepath in
  let ast = parse_input in_channel filename in
  let optimized_ast = optimize_program ast in
  let ir_code = generate_ir optimized_ast in
  let optimized_ir_code = optimize_program2 ir_code in
  let asm_code = generate_riscv optimized_ir_code in
  output_string out_channel asm_code;
  
  if false then (* 可以添加条件来决定是否显示AST和IR *)
    Printf.printf "AST for %s:\n%s\n" filename (string_of_program optimized_ast);
  
  if false then (* 可以添加条件来决定是否显示IR *)
    Printf.printf "IR for %s:\n%s\n" filename (string_of_ir_program ir_code);
  
  close_in in_channel;
  close_out out_channel
;;

let main () =
  (* 确保输出目录存在 
  let () = Sys.mkdir "test_results" 0o755 in*)
  
  (* 遍历所有测试文件 *)
  List.iter test_file filenames;
  
  Printf.printf "所有测试文件已编译完成，结果存储在 test_results 目录中\n";
  Printf.printf "请自行使用venus插件测试实际的代码运行结果.\n";
;;

(* 启动主函数 *)
let () = main ()