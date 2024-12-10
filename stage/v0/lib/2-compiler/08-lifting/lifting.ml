open Ephel_compiler_ast

let rec lift =
  let open Term in
  let open Free in
  function
  | Abs (ln, c) ->
    let vars = free (Abs (ln, c)) in
    List.fold_right (fun v t -> App (t, Var v)) vars (Abs (vars @ ln, c))
  | App (f, e) -> App (lift f, lift e)
  | Var n -> Var n
  | Unit -> Unit
  | Int i -> Int i
  | Inl e -> Inl (lift e)
  | Inr e -> Inr (lift e)
  | Case (c, l, r) -> Case (lift c, lift l, lift r)
  | Pair (l, r) -> Pair (lift l, lift r)
  | Fst e -> Fst (lift e)
  | Snd e -> Snd (lift e)
  | Rec (n, c) -> Rec (n, lift c)
  | Ffi (f, a) -> Ffi (f, a)

let run e = lift e
