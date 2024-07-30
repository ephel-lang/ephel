module Operator : functor (P : Specs.PARSEC) -> sig
  val ( <+> ) : 'a P.t -> 'b P.t -> ('a * 'b) P.t
  val ( <|> ) : 'a P.t -> 'a P.t -> 'a P.t
  val ( <?> ) : 'a P.t -> ('a -> bool) -> 'a P.t
  val ( ?= ) : ('a, 'a) Either.t P.t -> 'a P.t
  val ( ?! ) : 'a P.t -> 'a P.t
  val ( <+< ) : 'a P.t -> 'b P.t -> 'a P.t
  val ( >+> ) : 'a P.t -> 'b P.t -> 'b P.t
  val ( <||> ) : 'a P.t -> 'b P.t -> ('a, 'b) Either.t P.t
  val ( <|||> ) : 'a P.t -> 'b P.t -> ('a, 'b) Either.t P.t
end
