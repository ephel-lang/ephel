module Expr : functor (P : Specs.PARSEC) -> sig
  val term : ('a -> 'a) P.t -> 'a P.t -> ('a -> 'a) P.t -> 'a P.t
  val infixN : ('a -> 'a -> 'a) P.t -> 'a P.t -> 'a -> 'a P.t
  val infixL : ('a -> 'a -> 'a) P.t -> 'a P.t -> 'a -> 'a P.t
  val infixR : ('a -> 'a -> 'a) P.t -> 'a P.t -> 'a -> 'a P.t
end
