open Ephel_parser_parsec
open Ephel_compiler_token

module Tokens (Parsec : Specs.PARSEC with type Source.e = char) : sig
  val token : Token.with_region Parsec.t
end

val tokenize :
  'a.
     (module Specs.PARSEC with type Source.t = 'a and type Source.e = char)
  -> 'a
  -> (Token.with_region, 'a) Response.t
