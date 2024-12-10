open Term

let rec free =
  let remove ln l = List.filter (fun v -> List.for_all (fun n -> n <> v) ln) l in
  function
  | Abs (ln, c) -> remove ln (free c)
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
  | Rec (ln, c) -> remove [ ln ] (free c)
  | Ffi _ -> []
