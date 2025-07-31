(* optimzer2.ml：用于处理IR层次上的优化 *)
open Ir

let remove_adjacent_jumps (instructions : instruction list) : instruction list =
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_J l1 :: IR_J l2 :: rest when l1 = l2 ->
        aux acc (IR_J l1 :: rest)  (* 合并连续的跳转 *)
    | IR_J l1 :: IR_Label l2 :: rest when l1 = l2 ->
        aux acc (IR_Label l2 :: rest)  (* 跳转到标签的情况 *)
    | instr :: rest ->
        aux (instr :: acc) rest
  in
  aux [] instructions
;;


let collect_used_labels (instructions : instruction list) : string list =
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_J l          :: rest -> aux (l :: acc) rest
    | IR_Beqz (_, l)  :: rest -> aux (l :: acc) rest
    | IR_Bnez (_, l)  :: rest -> aux (l :: acc) rest
    | IR_Beq (_, _, l):: rest -> aux (l :: acc) rest
    | IR_Bne (_, _, l):: rest -> aux (l :: acc) rest
    | IR_Blt (_, _, l):: rest -> aux (l :: acc) rest
    | IR_Bge (_, _, l):: rest -> aux (l :: acc) rest
    | _               :: rest -> aux acc rest
  in
  aux [] instructions
;;

let remove_dead_labels (instructions : instruction list) : instruction list =
  let labels = collect_used_labels instructions in
  let rec aux acc = function
    | [] -> List.rev acc
    | IR_Label l :: rest ->
        if List.mem l labels then
          aux (IR_Label l :: acc) rest  (* 保留存在的标签 *)
        else
          aux acc rest  (* 跳过不存在的标签 *)
    | instr :: rest ->
        aux (instr :: acc) rest  (* 保留存在的标签 *)
  in
  aux [] instructions
;;

let optimize_program2 (program : program_ir) : program_ir =
  match program with
  | Program_ir funcs ->
      let optimized_funcs = List.map (fun func ->
        let optimized_body = 
          func.body
          |> remove_adjacent_jumps
          |> remove_dead_labels
        in
        { func with body = optimized_body }
      ) funcs in
      Program_ir optimized_funcs
;;