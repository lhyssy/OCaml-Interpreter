open Interpreter_lib.String_of_ast
open Interpreter_lib.Optimizer
open Interpreter_lib.Irgen
open Interpreter_lib.Codegen

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

(* 命令行参数记录类型 *)
type cli_options = {
  mutable input : in_channel;    (* 输入通道 *)
  mutable output : out_channel;  (* 输出通道 *)
  mutable show_ast : bool;       (* 是否显示AST *)
  mutable show_ir : bool;        (* 新增IR显示标志 *)
}

let main () =
  let options = {
    input = stdin;
    output = stdout;
    show_ast = false;
    show_ir = false;
  } in
  
  (* 定义参数解析规则 *)
  let speclist = [
    ("-i", Arg.String (fun filename -> 
       options.input <- open_in filename), 
     "<file>  指定输入文件");
    ("-o", Arg.String (fun filename -> 
       options.output <- open_out filename), 
     "<file>  指定输出文件");
    ("-ast", Arg.Unit (fun () -> options.show_ast <- true), 
     "        显示抽象语法树");
    ("-ir", Arg.Unit (fun () -> options.show_ir <- true), 
     "         显示中间表示")
  ] in
  
  (* 解析命令行参数 *)
  Arg.parse speclist (fun _ -> ()) "编译器使用说明：";
  
  (* 核心处理逻辑 *)
  let ast = 
    try parse_input options.input "<stdin>" 
    with e -> 
      close_in options.input;
      raise e
  in

  let optimized_ast = optimize_program ast in
  let ir_code = generate_ir optimized_ast in
  let asm_code = generate_riscv ir_code in
  output_string options.output asm_code;

  (* 处理输出模式 *)
  if options.show_ast then
    Printf.printf "%s\n" (string_of_program optimized_ast);
  if options.show_ir then
    Printf.printf "%s\n" (string_of_ir_program ir_code);

  (* 清理资源 *)
  if options.input != stdin then close_in options.input;
  if options.output != stdout then close_out options.output
;;

(* 启动主函数 *)
let () = main ()