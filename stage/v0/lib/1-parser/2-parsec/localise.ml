module Localise (Parsec : Specs.PARSEC) = struct
  let localise p s =
    let open Response.Destruct in
    let open Response.Construct in
    let open Ephel_parser_source.Region.Construct in
    let start = Parsec.Source.Access.location s in
    fold
      ~success:(fun (a, b, s) ->
        let finish = Parsec.Source.Access.location s in
        success ((a, create start finish), b, s) )
      ~failure:(fun (a, b, s) -> failure (a, b, s))
      (p s)
end
