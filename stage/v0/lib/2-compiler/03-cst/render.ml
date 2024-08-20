open Ephel_compiler_utils

module Cst = struct
  open Cst

  let rec render : type a. Format.formatter -> t -> unit =
   fun ppf ->
    let open Format in
    function
    | Ident (s, _) -> fprintf ppf "%s" s
    | Literal (Integer i, _) -> fprintf ppf "%d" i
    | Literal (String s, _) -> fprintf ppf "%s" s
    | App (f, t, _) -> fprintf ppf "(%a %a)" render f render t
    | Abs (l, t, _) -> fprintf ppf "(%a => %a)" render_parameters l render t
    | Let (s, t, b, _) -> fprintf ppf "let %s = %a in %a" s render t render b
    | BuildIn (Inl, _) -> fprintf ppf "inl"
    | BuildIn (Inr, _) -> fprintf ppf "inr"
    | BuildIn (Fst, _) -> fprintf ppf "fst"
    | BuildIn (Snd, _) -> fprintf ppf "snd"
    | Pair (l, r, _) -> fprintf ppf "(%a, %a)" render l render r
    | Case (s, l, r, _) -> fprintf ppf "case %s %a %a" s render l render r

  and render_parameters ppf =
    let open Format in
    function [] -> () | a :: l -> fprintf ppf "%s %a" a render_parameters l

  let to_string : t -> string = fun o -> Render.to_string render o
end
