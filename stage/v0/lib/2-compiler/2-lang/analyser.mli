open Ephel_parser_parsec

module Rules
    (Parsec : Specs.PARSEC with type Source.e = Token.with_location) : sig
  val term : Cst.term Parsec.t
end

val analyse :
  'a.
     (module Specs.PARSEC
        with type Source.e = Token.with_location
         and type Source.t = 'a )
  -> 'a
  -> (Cst.term, 'a) Ephel_parser_parsec.Response.t
