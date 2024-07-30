module Syntax : functor (P : Specs.PARSEC) -> sig
  val ( and<+> ) : 'a P.t -> 'b P.t -> ('a * 'b) P.t
end
