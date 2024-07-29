type t =
  | VAL of string
  | VAR of string

val fold : value:(string -> 'b) -> variable:(string -> 'b) -> t -> 'b
val remove : int -> t list -> (t list, string) result
val render_stack : Format.formatter -> t list -> unit
