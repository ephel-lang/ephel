module Parsec : functor (Source : Ephel_parser_source.Specs.SOURCE) ->
  Specs.PARSEC with module Source = Source
