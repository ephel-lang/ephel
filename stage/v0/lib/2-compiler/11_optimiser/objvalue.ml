open Ephel_compiler_objcode

type t =
  | Var of string
  | Dup of string
  | Val of Objcode.value
  | Code of string list * Objcode.t list
  | RecCode of string * string list * Objcode.t list
  | Exec of t * t
  | Left of t
  | Right of t
  | Pair of t * t
  | Car of t
  | Cdr of t
  | IfLeft of t * Objcode.t list * Objcode.t list

let rec render_value ppf =
  let open Format in
  function
  | Var n -> fprintf ppf "%s" n
  | Dup n -> fprintf ppf "copy(%s)" n
  | Val v -> Render.render_value ppf v
  | Code (ln, c) -> fprintf ppf "Lambda([ %a ],%a)" render_arguments ln Render.render c
  | RecCode (f, ln, c) -> fprintf ppf "Rec(%s,[ %a ],%a)" f render_arguments ln Render.render c
  | Exec (a, b) -> fprintf ppf "Exec(%a,%a)" render_value a render_value b
  | Car a -> fprintf ppf "Car(%a)" render_value a
  | Cdr a -> fprintf ppf "Cdr(%a)" render_value a
  | Pair (a, b) -> fprintf ppf "Pair(%a,%a)" render_value a render_value b
  | Left a -> fprintf ppf "Left(%a)" render_value a
  | Right a -> fprintf ppf "Right(%a)" render_value a
  | IfLeft (a, l, r) ->
    fprintf ppf "IfLeft(%a,%a,%a)" render_value a Render.render l Render.render r

and render_arguments ppf =
  let open Format in
  function [] -> () | a :: l -> fprintf ppf "%s %a" a render_arguments l

let rec render_values ppf =
  let open Format in
  function [] -> () | a :: s -> fprintf ppf "%a; %a" render_value a render_values s
