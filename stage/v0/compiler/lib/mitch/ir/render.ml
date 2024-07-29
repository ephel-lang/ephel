open Mitch_utils
open Objcode

let render_value ppf =
  let open Format in
  function INT i -> fprintf ppf "INT %d" i | UNIT -> fprintf ppf "UNIT"

let rec render ppf =
  let open Format in
  function
  | [] -> ()
  | [ a ] -> render_t ppf a
  | a :: l -> fprintf ppf "%a; %a" render_t a render l

and render_string ppf s =
  let open Format in
  fprintf ppf {|"%s"|} s

and render_t ppf =
  let open Format in
  function
  | PUSH v -> fprintf ppf "PUSH (%a)" render_value v
  | APPLY -> fprintf ppf "APPLY"
  | LAMBDA (n, l) -> fprintf ppf "LAMBDA( %a, [ %a ])" render_string n render l
  | DIG (i, n) -> fprintf ppf "DIG (%d, %a)" i render_string n
  | DUP (i, n) -> fprintf ppf "DUP (%d, %a)" i render_string n
  | DROP (i, n) -> fprintf ppf "DROP (%d, %a)" i render_string n
  | SWAP -> fprintf ppf "SWAP"
  | LEFT -> fprintf ppf "LEFT"
  | RIGHT -> fprintf ppf "RIGHT"
  | CASE (l, r) -> fprintf ppf "CASE ([ %a ], [ %a ])" render l render r
  | PAIR -> fprintf ppf "PAIR"
  | FST -> fprintf ppf "FST"
  | SND -> fprintf ppf "SND"
  | UNPAIR -> fprintf ppf "UNPAIR"
  | LAMBDA_REC (f, n, l) ->
    fprintf ppf "LAMBDA_REC(%a, %a, [ %a ])" render_string f render_string n
      render l

let to_string o = Render.to_string render o
