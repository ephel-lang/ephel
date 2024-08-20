open Ephel_parser_parsec
open Ephel_compiler_tokenizer
open Ephel_compiler_cst

module Rules
    (Parsec : Specs.PARSEC with type Source.e = Token.with_location) : sig
  val term : Cst.with_location Parsec.t
  val declaration : (string * Cst.with_location) Parsec.t
end

val term :
  'a.
     (module Specs.PARSEC
        with type Source.t = 'a
         and type Source.e = Token.with_location )
  -> 'a
  -> (Cst.with_location, 'a) Response.t

val declaration :
  'a.
     (module Specs.PARSEC
        with type Source.t = 'a
         and type Source.e = Token.with_location )
  -> 'a
  -> (string * Cst.with_location, 'a) Response.t
