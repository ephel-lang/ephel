module Core : functor (P : Specs.PARSEC) -> sig
  include module type of Control.Monad (P)
  include module type of Eval.Eval (P)
  include module type of Flow.Flow (P)
  include module type of Operator.Operator (P)
  include module type of Occurrence.Occurrence (P)
  include module type of Atomic.Atomic (P)
  include module type of Expr.Expr (P)
end
