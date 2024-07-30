open Ephel_parsec_source.Source
open Ephel_parsec_parser.Parser

let response r =
  let open Response.Destruct in
  fold
    ~success:(fun (a, b, _) -> (Some a, b))
    ~failure:(fun (_, b, _) -> (None, b))
    r

module Parsec = Parsec (FromChars)
