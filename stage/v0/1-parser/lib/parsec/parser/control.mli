module Functor : functor (P : Specs.PARSEC) ->
  Preface.Specs.FUNCTOR with type 'a t = 'a P.t

module Monad : functor (P : Specs.PARSEC) ->
  Preface.Specs.MONAD with type 'a t = 'a P.t
