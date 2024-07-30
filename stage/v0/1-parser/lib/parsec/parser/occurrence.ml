module Occurrence (P : Specs.PARSEC) = struct
  module Monad = Control.Monad (P)
  module Eval = Eval.Eval (P)
  module Operator = Operator.Operator (P)

  let opt p s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (a, b, s) -> success (Some a, b, s))
      ~failure:(fun (m, b, s) ->
        if b then failure (m, b, s) else success (None, b, s) )
      (p s)

  let sequence optional p s =
    (* sequence is tail recursive *)
    let open Response.Destruct in
    let open Response.Construct in
    let rec sequence s aux b =
      fold
        ~success:(fun (a, b', s') -> sequence s' (a :: aux) (b || b'))
        ~failure:(fun (m, b', s') ->
          if b' || (aux = [] && not optional)
          then failure (m, b || b', s')
          else success (List.rev aux, b || b', s) )
        (p s)
    in
    sequence s [] false

  let rep p = sequence false p
  let opt_rep p = sequence true p
end
