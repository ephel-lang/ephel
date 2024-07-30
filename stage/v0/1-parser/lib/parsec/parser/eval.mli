module Eval : functor (P : Specs.PARSEC) -> sig
  val locate : 'a P.t -> ('a * Ephel_parsec_source.Region.t) P.t
  val eos : unit P.t
  val return : 'a -> 'a P.t
  val fail : ?consumed:bool -> ?message:string option -> 'a P.t
  val do_lazy : 'a P.t Lazy.t -> 'a P.t
  val do_try : 'a P.t -> 'a P.t
  val lookahead : 'a P.t -> 'a P.t
  val satisfy : 'a P.t -> ('a -> bool) -> 'a P.t
  val fix : ('a P.t -> 'a P.t) -> 'a P.t
end
