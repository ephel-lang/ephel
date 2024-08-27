module Eval (P : Specs.PARSEC) = struct
  module Monad = Control.Monad (P)

  let locate p s =
    let module Region = Ephel_parser_source.Region.Construct in
    let open Response.Destruct in
    let open Response.Construct in
    let open P.Source.Access in
    let l0 = location s in
    fold
      ~success:(fun (a, b, s) -> success ((a, Region.create ~first:l0 ~last:(location s)), b, s))
      ~failure:(fun (m, _, _) -> failure (m, false, s))
      (p s)

  let eos s =
    let open Response.Construct in
    let open P.Source.Access in
    match next s with
    | Some _, s' -> failure (Some "stream not consumed", false, s')
    | None, s' -> success ((), false, s')

  let return = Monad.return

  let fail ?(consumed = false) ?(message = None) s =
    let open Response.Construct in
    failure (message, consumed, s)

  let do_lazy p s = Lazy.force p s

  let do_try p s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (a, b, s) -> success (a, b, s))
      ~failure:(fun (m, _, _) -> failure (m, false, s))
      (p s)

  let lookahead p s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (a, _, _) -> success (a, false, s))
      ~failure:(fun (m, _, _) -> failure (m, false, s))
      (p s)

  let satisfy p f s =
    let open Response.Destruct in
    let open Response.Construct in
    fold
      ~success:(fun (a, b, s') -> if f a then success (a, b, s') else failure (None, false, s))
      ~failure:(fun (m, c, s') -> failure (m, c, s'))
      (p s)

  let rec fix f s = f (fix f) s
end
