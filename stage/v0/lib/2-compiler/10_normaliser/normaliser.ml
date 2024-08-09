open Ephel_compiler_ir

let rec last =
  let open Preface.Option.Functor.Infix in
  function
  | [] -> None
  | [ a ] -> Some (a, [])
  | a :: l -> last l <&> fun (b, l) -> (b, a :: l)

let rec normalise_sequence =
  let open Objcode in
  function
  | CASE (l, r) :: s -> (
    match (last l, last r) with
    | Some (a, l), Some (a', r) when a = a' -> CASE (l, r) :: a :: s
    | _, _ -> normalise_instruction (CASE (l, r)) :: normalise_sequence s )
  | a :: s -> normalise_instruction a :: normalise_sequence s
  | [] -> []

and normalise_instruction =
  let open Objcode in
  function
  | LAMBDA (n, l) -> LAMBDA (n, normalise_sequence l)
  | LAMBDA_REC (f, n, l) -> LAMBDA_REC (f, n, normalise_sequence l)
  | CASE (l, r) -> CASE (normalise_sequence l, normalise_sequence r)
  | o -> o

let rec normalise o =
  let o' = normalise_sequence o in
  if o' = o then o' else normalise o'

let run o = normalise o
