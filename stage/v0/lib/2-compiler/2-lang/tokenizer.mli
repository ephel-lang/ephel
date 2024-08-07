module Tokens
    (Parsec : Ephel_parser_parsec.Specs.PARSEC with type Source.e = char) : sig
  val token : Token.with_location Parsec.t
end
