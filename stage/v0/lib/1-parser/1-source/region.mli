type t

module Construct : sig
  val create : first:Location.t -> last:Location.t -> t
  val combine : t -> t -> t
end

module Access : sig
  val file : t -> string option
  val first : t -> Location.t
  val last : t -> Location.t
end

module Render : sig
  val render : Format.formatter -> t -> unit
end
