type t = Location.t * Location.t

module Construct = struct
  let create first last = (first, last)
end

module Access = struct
  let file (l, _) = Location.Access.file l
  let first (l, _) = l
  let last (_, l) = l
end

module Render = struct
  let render ppf region =
    let open Format in
    let open Location.Render in
    let file = Access.file region
    and first = Access.first region
    and last = Access.first region in
    match file with
    | Some file ->
      fprintf ppf "in %s from %a to %a" file render first render last
    | None -> fprintf ppf "from %a to %a" render first render last
end
