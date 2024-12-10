type _ t =
  | Unit : 'a t
  | Int : int -> 'a t
  (* Function *)
  | Abs : string list * 'a t -> 'a t
  | App : 'a t * 'a t -> 'a t
  | Var : string -> 'a t
  (* Sum *)
  | Inl : 'a t -> 'a t
  | Inr : 'a t -> 'a t
  | Case : 'a t * 'a t * 'a t -> 'a t
  (* Product *)
  | Pair : 'a t * 'a t -> 'a t
  | Fst : 'a t -> 'a t
  | Snd : 'a t -> 'a t
  (* Extension *)
  | Rec : string * 'a t -> 'a t
  (* FFI *)
  | Ffi : string * int -> 'a t
