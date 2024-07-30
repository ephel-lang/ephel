module Occurrence : functor (P : Specs.PARSEC) -> sig
  val opt : 'a P.t -> 'a option P.t
  val rep : 'a P.t -> 'a list P.t
  val opt_rep : 'a P.t -> 'a list P.t
end
