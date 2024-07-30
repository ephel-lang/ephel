module Parsec : functor (Source : Ephel_parsec_source.Specs.SOURCE) ->
  Specs.PARSEC with module Source = Source
