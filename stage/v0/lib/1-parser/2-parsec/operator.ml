module Operator (P : Specs.PARSEC) = struct
  module Functor = Control.Functor (P)
  module Eval = Eval.Eval (P)
  module Flow = Flow.Flow (P)

  let ( <+> ) p1 p2 = Flow.sequence p1 p2
  let ( ?= ) p = Flow.unify p
  let ( <?> ) p f = Eval.satisfy p f
  let ( ?! ) p = Eval.do_try p
  let ( <||> ) p1 p2 = Flow.choice p1 p2
  let ( <|> ) p1 p2 = ?=(p1 <||> p2)
  let ( <+< ) p1 p2 = Functor.(p1 <+> p2 <&> fst)
  let ( >+> ) p1 p2 = Functor.(p1 <+> p2 <&> snd)
  let ( <|||> ) p1 p2 = Flow.eager_choice p1 p2
end
