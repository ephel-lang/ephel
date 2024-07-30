type t = string option * int * int * int

module Construct = struct
  let initial file = (file, 0, 0, 0)
  let create ~file ~position ~line ~column = (file, position, line, column)
end

module Access = struct
  let file (f, _, _, _) = f
  let position (_, p, _, _) = p
  let line (_, _, l, _) = l
  let column (_, _, _, c) = c
end

module Render = struct
  let render ppf (f, _, l, c) =
    let open Format in
    match f with
    | None -> fprintf ppf "%d:%d" l c
    | Some f -> fprintf ppf "%s:%d:%d" f l c
end
