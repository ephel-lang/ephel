open Ephel_compiler_utils
open Term

let rec render : type a. Format.formatter -> a t -> unit =
 fun ppf ->
  let open Format in
  function
  | Abs (n, c) -> fprintf ppf "%s => %a" n render c
  | App (l, r) -> fprintf ppf "%a (%a)" render l render r
  | Var n -> fprintf ppf "%s" n
  | Unit -> fprintf ppf "()"
  | Int i -> fprintf ppf "%d" i
  | Inl c -> fprintf ppf "inl (%a)" render c
  | Inr c -> fprintf ppf "inr (%a)" render c
  | Case (c, l, r) -> fprintf ppf "case (%a) (%a) (%a)" render c render l render r
  | Pair (l, r) -> fprintf ppf "(%a, %a)" render l render r
  | Fst e -> fprintf ppf "fst (%a)" render e
  | Snd e -> fprintf ppf "snd (%a)" render e
  | Let (n, e, f) -> fprintf ppf "let %s = %a in %a" n render e render f
  | Rec (n, c) -> fprintf ppf "rec(%s).(%a)" n render c
  | Ffi (f, a) -> fprintf ppf "native %s %i" f a

let to_string : type a. a t -> string = fun o -> Render.to_string render o
