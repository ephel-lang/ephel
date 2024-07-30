module Flow : functor (P : Specs.PARSEC) -> sig
  val sequence : 'a P.t -> 'b P.t -> ('a * 'b) P.t
  val choice : 'a P.t -> 'b P.t -> ('a, 'b) Either.t P.t
  val unify : ('a, 'a) Either.t P.t -> 'a P.t
  val eager_choice : 'a P.t -> 'b P.t -> ('a, 'b) Either.t P.t
end
