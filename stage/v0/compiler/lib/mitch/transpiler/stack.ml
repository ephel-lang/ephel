type t =
  | VAL of string
  | VAR of string

let fold ~value ~variable = function VAL s -> value s | VAR s -> variable s

let rec render_stack ppf =
  let open Format in
  function
  | [] -> fprintf ppf ""
  | VAL s :: l -> fprintf ppf "VAL(%s), %a" s render_stack l
  | VAR n :: l -> fprintf ppf "VAR(%s), %a" n render_stack l
