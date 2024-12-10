let rec normalise =
  let open Term in
  function
  | Abs (ln, Abs (lm, c)) -> normalise (Abs (ln @ lm, c))
  | Abs (ln, c) -> Abs (ln, normalise c)
  | App (f, e) -> App (normalise f, normalise e)
  | Var n -> Var n
  | Unit -> Unit
  | Int i -> Int i
  | Inl e -> Inl (normalise e)
  | Inr e -> Inr (normalise e)
  | Case (c, l, r) -> Case (normalise c, normalise l, normalise r)
  | Pair (l, r) -> Pair (normalise l, normalise r)
  | Fst e -> Fst (normalise e)
  | Snd e -> Snd (normalise e)
  | Rec (n, c) -> Rec (n, normalise c) (* ? *)
  | Ffi (f, a) -> Ffi (f, a)
