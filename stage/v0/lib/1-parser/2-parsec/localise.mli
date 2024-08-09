module Localise (P : Specs.PARSEC) : sig
  val localise : 'a P.t -> ('a * Ephel_parser_source.Region.t) P.t
end
