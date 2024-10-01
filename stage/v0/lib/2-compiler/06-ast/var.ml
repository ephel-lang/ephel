open Term

let rec free : type a. a t -> string list =
  let remove n l = List.filter (fun v -> v != n) l in
  function
  | Abs (n, c) -> remove n (free c)
  | App (l, r) -> free l @ free r
  | Var n -> [ n ]
  | Unit -> []
  | Int _ -> []
  | Inl c -> free c
  | Inr c -> free c
  | Case (c, l, r) -> free c @ free l @ free r
  | Pair (l, r) -> free l @ free r
  | Fst e -> free e
  | Snd e -> free e
  | Let (n, e, f) -> free e @ remove n (free f)
  | Rec (n, c) -> remove n (free c)
  | Ffi _ -> []
