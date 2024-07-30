module Core (P : Specs.PARSEC) = struct
  include Control.Monad (P)
  include Eval.Eval (P)
  include Flow.Flow (P)
  include Operator.Operator (P)
  include Occurrence.Occurrence (P)
  include Atomic.Atomic (P)
  include Expr.Expr (P)
end
