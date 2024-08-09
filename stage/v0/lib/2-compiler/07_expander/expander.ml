open Ephel_compiler_objcode

let rec expand_sequence =
  let open Objcode in
  function
  | CASE (l, r) :: s when List.length s > 0 -> [ CASE (l @ s, r @ s) ]
  | a :: l -> expand_instruction a :: expand_sequence l
  | [] -> []

and expand_instruction =
  let open Objcode in
  function
  | LAMBDA (n, l) -> LAMBDA (n, expand_sequence l)
  | LAMBDA_REC (f, n, l) -> LAMBDA_REC (f, n, expand_sequence l)
  | CASE (l, r) -> CASE (expand_sequence l, expand_sequence r)
  | o -> o

let rec expand o =
  let o' = expand_sequence o in
  if o' = o then o' else expand o'

let run o = expand o
