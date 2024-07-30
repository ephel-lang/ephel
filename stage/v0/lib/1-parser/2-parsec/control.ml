module Functor (P : Specs.PARSEC) = Preface.Make.Functor.Via_map (struct
  type 'a t = 'a P.t

  let map f p s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (a, b, s) -> success (f a, b, s))
      ~failure:(fun (m, b, s) -> failure (m, b, s))
      (p s)
end)

module Monad (P : Specs.PARSEC) = Preface.Make.Monad.Via_return_and_bind (struct
  type 'a t = 'a P.t

  let return v s =
    let open Response.Construct in
    success (v, false, s)

  let bind f p s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (p, b1, s) ->
        fold
          ~success:(fun (a, b2, s) -> success (a, b1 || b2, s))
          ~failure:(fun (m, b, s) -> failure (m, b, s))
          (f p s) )
      ~failure:(fun (m, b, s) -> failure (m, b, s))
      (p s)
end)
