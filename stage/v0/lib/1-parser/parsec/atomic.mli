module Atomic : functor (P : Specs.PARSEC) -> sig
  val any : P.Source.e P.t
  val atom : P.Source.e -> P.Source.e P.t
  val atom_in : P.Source.e list -> P.Source.e P.t
  val atoms : P.Source.e list -> P.Source.e list P.t
  val not : 'a P.t -> P.Source.e P.t
end
