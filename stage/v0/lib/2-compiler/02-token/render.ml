open Ephel_compiler_utils
open Token

let render ppf =
  let open Format in
  function
  | INL -> fprintf ppf "inl"
  | INR -> fprintf ppf "inr"
  | CASE -> fprintf ppf "case"
  | VAL -> fprintf ppf "val"
  | LET -> fprintf ppf "let"
  | IN -> fprintf ppf "in"
  | FST -> fprintf ppf "fst"
  | SND -> fprintf ppf "snd"
  | INT i -> fprintf ppf "%d" i
  | STRING s -> fprintf ppf "\"%s\"" s
  | IMPLY -> fprintf ppf "=>"
  | EQUAL -> fprintf ppf "="
  | PRODUCT -> fprintf ppf ","
  | LPAR -> fprintf ppf "("
  | RPAR -> fprintf ppf ")"
  | IDENT s -> fprintf ppf "%s" s

let to_string o = Render.to_string render o
