module Flow (P : Specs.PARSEC) = struct
  module Functor = Control.Functor (P)

  let sequence p1 p2 s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (a1, b1, s1) ->
        fold
          ~success:(fun (a2, b2, s2) -> success ((a1, a2), b1 || b2, s2))
          ~failure:(fun (m, b2, s2) -> failure (m, b1 || b2, s2))
          (p2 s1) )
      ~failure:(fun (m, b1, s1) -> failure (m, b1, s1))
      (p1 s)

  let choice p1 p2 s =
    let open Response.Destruct in
    let open Response.Construct in
    let open Functor in
    fold
      ~success:(fun (a, b, s) -> success (a, b, s))
      ~failure:(fun (m, b, s) -> if b then failure (m, b, s) else (p2 <&> fun e -> Either.Right e) s)
      ((p1 <&> fun e -> Either.Left e) s)

  let eager_choice p1 p2 s =
    let open Ephel_parser_source.Location.Access in
    let open P.Source.Access in
    let open Response.Destruct in
    let open Response.Construct in
    let open Functor in
    let r1 = (p1 <&> fun e -> Either.Left e) s in
    let r2 = (p2 <&> fun e -> Either.Right e) s in
    fold
      ~success:(fun (a, b, s) ->
        fold
          ~success:(fun (a', b', s') ->
            if position (location s) < position (location s')
            then success (a', b', s')
            else success (a, b, s) )
          ~failure:(fun _ -> success (a, b, s))
          r2 )
      ~failure:(fun _ -> r2)
      r1

  let unify p = Functor.(p <&> function Either.Left a | Either.Right a -> a)
end
