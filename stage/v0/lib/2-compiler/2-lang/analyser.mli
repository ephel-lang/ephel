open Ephel_parser_parsec

module Rules
    (Parsec : Specs.PARSEC with type Source.e = Token.with_location) : sig
  val term : Cst.with_location Parsec.t
end

val analyse :
  'a.
     (module Specs.PARSEC
        with type Source.t = 'a
         and type Source.e = Token.with_location )
  -> 'a
  -> (Cst.with_location, 'a) Response.t
