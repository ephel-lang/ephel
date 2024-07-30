module Syntax (P : Specs.PARSEC) = struct
  module Operator = Operator.Operator (P)

  let ( and<+> ) a b = Operator.(a <+> b)
end
