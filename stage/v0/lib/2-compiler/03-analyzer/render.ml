open Ephel_compiler_utils

module Cst = struct
  open Cst

  let rec render : type a. Format.formatter -> t -> unit =
   fun ppf ->
    let open Format in
    function
    | Ident s -> fprintf ppf "%s" s
    | Literal (Integer i) -> fprintf ppf "%d" i
    | Literal (String s) -> fprintf ppf "%s" s
    | App (f, t) -> fprintf ppf "(%a %a)" render f render t
    | Abs (l, t) -> fprintf ppf "(%a => %a)" render_parameters l render t
    | Let (s, t, b) -> fprintf ppf "let %s = %a in %a" s render t render b
    | BuildIn Inl -> fprintf ppf "inl"
    | BuildIn Inr -> fprintf ppf "inr"
    | BuildIn Fst -> fprintf ppf "fst"
    | BuildIn Snd -> fprintf ppf "snd"
    | Pair (l, r) -> fprintf ppf "(%a, %a)" render l render r
    | Case (s, l, r) -> fprintf ppf "case %s %a %a" s render l render r

  and render_parameters ppf =
    let open Format in
    function [] -> () | a :: l -> fprintf ppf "%s %a" a render_parameters l

  let to_string : t -> string = fun o -> Render.to_string render o
end
