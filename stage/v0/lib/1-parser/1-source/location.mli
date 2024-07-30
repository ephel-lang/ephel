type t

module Construct : sig
  val initial : string option -> t
  val create : file:string option -> position:int -> line:int -> column:int -> t
end

module Access : sig
  val file : t -> string option
  val position : t -> int
  val line : t -> int
  val column : t -> int
end

module Render : sig
  val render : Format.formatter -> t -> unit
end
