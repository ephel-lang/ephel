module Parsec : sig
  module Source : Ephel_parser_source.Specs.SOURCE

  type 'a t = Source.t -> ('a, Source.t) Response.t

  val source : ?file:string option -> Source.Construct.c -> Source.t
end

module type PARSEC = module type of Parsec

type ('a, 'b) parsec =
  (module PARSEC with type Source.t = 'a and type Source.e = 'b)
