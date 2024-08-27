module Tokens (Parsec : Ephel_parser_parsec.Specs.PARSEC with type Source.e = char) = struct
  open Ephel_parser_parsec.Core (Parsec)
  open Ephel_parser_parsec.Localise (Parsec)
  open Ephel_parser_parsec.Literal (Parsec)
  open Ephel_parser_source.Utils
  open Preface_core.Fun
  open Ephel_compiler_token.Token
  module StringMap = Map.Make (String)

  let keywords =
    StringMap.of_seq
    @@ List.to_seq
         [
           ("inl", INL)
         ; ("inr", INR)
         ; ("case", CASE)
         ; ("fst", FST)
         ; ("snd", SND)
         ; ("val", VAL)
         ; ("let", LET)
         ; ("in", IN)
         ]

  let to_token s = match StringMap.find_opt s keywords with Some e -> e | None -> IDENT s

  (* skipped characters *)

  let spaces = opt_rep (char_in_string " \t\n\r")

  (* basic parsers *)

  let identifier =
    let operators = "^$+-*/%~@#&!-_?.:*¨°><=[]{}\\|" in
    let first_only = alpha <|> char_in_string operators in
    first_only <+> opt_rep (digit <|> first_only) <&> fun (c, l) -> string_of_chars (c :: l)

  (* tokens *)

  let _INTEGER_ = integer <&> fun s -> INT s
  let _STRING_ = Delimited.string <&> fun s -> STRING s
  let _IMPLY_ = string "=>" <&> const IMPLY
  let _EQUAL_ = char '=' <&> const EQUAL
  let _PRODUCT_ = char ',' <&> const PRODUCT
  let _LPAR_ = char '(' <&> const LPAR
  let _RPAR_ = char ')' <&> const RPAR
  let _IDENT_ = identifier <&> to_token

  (* Main entry *)

  let token =
    spaces
    >+> localise
          ( _INTEGER_
          <|> _STRING_
          <|> _IMPLY_
          <|> _EQUAL_
          <|> _PRODUCT_
          <|> _LPAR_
          <|> _RPAR_
          <|> _IDENT_ )
    <+< spaces
end

let tokenize (type a)
    (module P : Ephel_parser_parsec.Specs.PARSEC with type Source.t = a and type Source.e = char) =
  let module M = Tokens (P) in
  M.token
