type value =
  | INT of int
  | UNIT

type t =
  (* Lambda operation and terms "à la Michelson" *)
  | APPLY
  | EXEC
  | LAMBDA of string list * t list
  | LAMBDA_REC of string * string list * t list
  (* Sum operations *)
  | LEFT
  | RIGHT
  | CASE of t list * t list
  (* Product operations *)
  | PAIR
  | FST
  | SND
  | UNPAIR
  (* Basic stack operation *)
  | PUSH of value
  | DIG of int * string
  | DUP of int * string
  | DROP of int * string
  | SWAP
  (* Foreign Function Interface *)
  | FFI of string * int
