type t =
  | VAL of string
  | VAR of string

let fold ~value ~variable = function VAL s -> value s | VAR s -> variable s

let rec remove n s =
  if n = 0
  then Ok s
  else
    match s with
    | [] -> Error "Cannot remove from an empty stack"
    | _ :: s -> remove (n - 1) s

let rec render_stack ppf =
  let open Format in
  function
  | [] -> fprintf ppf ""
  | VAL s :: l -> fprintf ppf "VAL(%s), %a" s render_stack l
  | VAR n :: l -> fprintf ppf "VAR(%s), %a" n render_stack l
