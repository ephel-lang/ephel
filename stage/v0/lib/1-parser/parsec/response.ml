type ('a, 'b) t = (string option * bool * 'b, 'a * bool * 'b) Either.t

module Construct = struct
  let success (a, c, b) = Either.Right (a, c, b)
  let failure (m, c, b) = Either.Left (m, c, b)
end

module Destruct = struct
  let fold ~success ~failure = function
    | Either.Right (a, c, b) -> success (a, c, b)
    | Either.Left (m, c, b) -> failure (m, c, b)

  let fold_opt =
    let none _ = None in
    fun ?(success = none) ?(failure = none) r -> fold ~success ~failure r
end
