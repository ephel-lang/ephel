module Literal (P : Specs.PARSEC with type Source.e = char) = struct
  module Monad = Control.Monad (P)
  module Atomic = Atomic.Atomic (P)
  module Eval = Eval.Eval (P)
  module Operator = Operator.Operator (P)
  module Occurrence = Occurrence.Occurrence (P)

  let char c =
    let open Operator in
    let open Atomic in
    any <?> fun e' -> e' = c

  let char_in_ranges l =
    let open Operator in
    let open Atomic in
    any <?> fun e' -> List.exists (fun (l, u) -> l <= e' && e' <= u) l

  let char_in_range r = char_in_ranges [ r ]

  let char_in_list l =
    let open Operator in
    let open Atomic in
    any <?> fun e' -> List.mem e' l

  let char_in_string s =
    let open Ephel_parser_source.Utils in
    char_in_list (chars_of_string s)

  let digit = char_in_range ('0', '9')
  let alpha = char_in_ranges [ ('a', 'z'); ('A', 'Z') ]

  let natural =
    let open Monad in
    let open Occurrence in
    let open Ephel_parser_source.Utils in
    rep digit <&> string_of_chars <&> int_of_string

  let integer =
    let open Monad in
    let open Atomic in
    let open Operator in
    let open Occurrence in
    let negative = atom '-' >+> return (( * ) (-1))
    and positive = opt (atom '+') >+> return Stdlib.Fun.id in
    negative <|> positive <+> natural <&> fun (f, i) -> f i

  let string s =
    let open Monad in
    let open Atomic in
    let open Ephel_parser_source.Utils in
    atoms (chars_of_string s) <&> Stdlib.Fun.const s

  let string_in_list l =
    let open List in
    let open Eval in
    let open Operator in
    fold_left (fun p e -> p <|> string e) fail l

  let sequence p =
    let open Monad in
    let open Occurrence in
    let open Ephel_parser_source.Utils in
    rep p <&> string_of_chars

  module Delimited = struct
    let string_delimited =
      let open Monad in
      let open Atomic in
      let open Operator in
      let open Occurrence in
      let open Ephel_parser_source.Utils in
      char '"'
      >+> opt_rep
            (char '\\' >+> char '"' <&> Stdlib.Fun.const '"' <|> not (char '"'))
      <+< char '"'
      <&> string_of_chars

    let char_delimited =
      let open Monad in
      let open Atomic in
      let open Operator in
      char '\''
      >+> (string "\\\'" <&> Stdlib.Fun.const '\'' <|> not (char '\''))
      <+< char '\''

    let string = string_delimited
    let char = char_delimited
  end
end
