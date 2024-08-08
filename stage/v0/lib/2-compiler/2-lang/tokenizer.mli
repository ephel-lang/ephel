open Ephel_parser_parsec

module Tokens (Parsec : Specs.PARSEC with type Source.e = char) : sig
  val token : Token.with_location Parsec.t
end

val tokenize :
  'a.
     (module Specs.PARSEC with type Source.t = 'a and type Source.e = char)
  -> 'a
  -> (Token.with_location, 'a) Response.t
