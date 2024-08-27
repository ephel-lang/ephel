open Ephel_compiler_utils
open Cst

let rec render : Format.formatter -> t -> unit =
 fun ppf ->
  let open Format in
  function
  | Ident (s, _) -> fprintf ppf "%s" s
  | Literal (Integer i, _) -> fprintf ppf "%d" i
  | Literal (String s, _) -> fprintf ppf "%s" s
  | App (f, t, _) -> fprintf ppf "(%a %a)" render f render t
  | Abs (l, t, _) -> fprintf ppf "(%a=> %a)" render_parameters l render t
  | Let (s, t, b, _) -> fprintf ppf "let %s = %a in %a" s render t render b
  | Builtin (Inl, t, _) -> fprintf ppf "inl %a" render t
  | Builtin (Inr, t, _) -> fprintf ppf "inr %a" render t
  | Builtin (Fst, t, _) -> fprintf ppf "fst %a" render t
  | Builtin (Snd, t, _) -> fprintf ppf "snd %a" render t
  | Pair (l, r, _) -> fprintf ppf "(%a, %a)" render l render r
  | Case (s, l, r, _) -> fprintf ppf "case %s %a %a" s render l render r

and render_parameters ppf =
  let open Format in
  function [] -> () | a :: l -> fprintf ppf "%s %a" a render_parameters l

let to_string : t -> string = fun o -> Render.to_string render o
