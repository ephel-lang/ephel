open Ephel_parser_parsec
open Ephel_compiler_tokenizer

module Rules
    (Parsec : Specs.PARSEC with type Source.e = Token.with_location) : sig
  val declarations : (string * Cst.with_location) list Parsec.t
end

val analyse :
  'a.
     (module Specs.PARSEC
        with type Source.t = 'a
         and type Source.e = Token.with_location )
  -> 'a
  -> ((string * Cst.with_location) list, 'a) Response.t
