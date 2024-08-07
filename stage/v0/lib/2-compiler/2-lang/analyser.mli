open Ephel_parser_parsec

module Rules
    (Parsec : Specs.PARSEC with type Source.e = Token.with_location) : sig
  val term : Cst.term Parsec.t
end

val analyse :
  (module Specs.PARSEC) -> ('a Ephel_compiler_ast.Term.t, string) result
