open Ephel_parser_parsec
open Ephel_compiler_token
open Ephel_compiler_cst

module Rules
    (Parsec : Specs.PARSEC with type Source.e = Token.with_region) : sig
  val term : Cst.t Parsec.t
  val declaration : (string * Cst.t) Parsec.t
end

val term :
  'a.
     (module Specs.PARSEC
        with type Source.t = 'a
         and type Source.e = Token.with_region )
  -> 'a
  -> (Cst.t, 'a) Response.t

val declaration :
  'a.
     (module Specs.PARSEC
        with type Source.t = 'a
         and type Source.e = Token.with_region )
  -> 'a
  -> (string * Cst.t, 'a) Response.t
