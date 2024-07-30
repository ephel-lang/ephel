module Atomic (P : Specs.PARSEC) = struct
  module Monad = Control.Monad (P)
  module Eval = Eval.Eval (P)
  module Operator = Operator.Operator (P)

  let any s =
    let open Response.Construct in
    let open P.Source.Access in
    match next s with
    | Some e, s' -> success (e, true, s')
    | None, s' -> failure (Some "stream consumed", false, s')

  let not p s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (_, _, s) -> failure (None, false, s))
      ~failure:(fun (_, _, s) -> any s)
      (p s)

  let atom e =
    let open Operator in
    any <?> fun e' -> e' = e

  let atom_in l =
    let open Operator in
    any <?> fun e' -> List.mem e' l

  let atoms l =
    let open List in
    let open Monad in
    let open Eval in
    let open Operator in
    do_try
      (fold_left (fun p e -> p <+< atom e) (return ()) l <&> Stdlib.Fun.const l)
end
