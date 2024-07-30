module Expr (P : Specs.PARSEC) = struct
  module Monad = Control.Monad (P)
  module Operator = Operator.Operator (P)

  let option x p =
    let open Monad in
    let open Operator in
    p <|> return x

  let term prefix t postfix =
    let open Stdlib.Fun in
    let open Monad in
    let open Monad.Syntax in
    let* pre = option id prefix in
    let* x = t in
    let* post = option id postfix in
    return @@ post @@ pre x

  let infixN op p x =
    let open Monad in
    let open Monad.Syntax in
    let* f = op in
    let* y = p in
    return @@ f x y

  let rec infixL op p x =
    let open Monad in
    let open Monad.Syntax in
    let open Operator in
    let* f = op in
    let* y = p in
    let r = f x y in
    infixL op p r <|> return r

  let rec infixR op p x =
    let open Monad in
    let open Monad.Syntax in
    let open Monad.Infix in
    let open Operator in
    let* f = op in
    let* y = p >>= fun r -> infixR op p r <|> return r in
    return @@ f x y
end
