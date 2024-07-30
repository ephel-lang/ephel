module Literal : functor (P : Specs.PARSEC with type Source.e = char) -> sig
  val char : char -> char P.t
  val char_in_range : char * char -> char P.t
  val char_in_ranges : (char * char) list -> char P.t
  val char_in_list : char list -> char P.t
  val char_in_string : string -> char P.t
  val digit : char P.t
  val alpha : char P.t
  val natural : int P.t
  val integer : int P.t
  val string : string -> string P.t
  val string_in_list : string list -> string P.t
  val sequence : char P.t -> string P.t

  module Delimited : sig
    val string : string P.t
    val char : char P.t
  end
end
