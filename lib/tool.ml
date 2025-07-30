(* tool.ml：用于存放其他自己编写的相关工具 *)
let is_power_of_two n =
  n > 0 && (n land (n - 1)) = 0
;;

(* 获取2的幂次 *)
let log2 n =
  if n <= 0 then failwith "log2 of non-positive number"
  else
    let rec aux p i =
      if p = n then i
      else if p > n then failwith (Printf.sprintf "Not a power of 2: %d" n)
      else aux (p * 2) (i + 1)
    in
    aux 1 0
;;

let is_12bit n =
  -2048 <= n && n < 2047
;;