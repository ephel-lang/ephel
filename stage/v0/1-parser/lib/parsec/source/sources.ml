type 'a t = 'a list * Location.t

module FromList (Locator : Specs.LOCATOR) = struct
  type e = Locator.e
  type nonrec t = e t

  module Construct = struct
    type c = e list

    let create ~file s = (s, Location.Construct.initial file)
  end

  module Access = struct
    let next = function
      | [], l -> (None, ([], l))
      | a :: s, l -> (Some a, (s, Locator.locate l a))

    let eos (s, _) = s = []
    let location (_, l) = l
  end
end

module FromChars = FromList (struct
  type e = char

  let locate l =
    let open Location.Construct in
    let open Location.Access in
    function
    | '\n' ->
      create ~file:(file l)
        ~position:(position l + 1)
        ~line:(line l + 1)
        ~column:1
    | _ ->
      create ~file:(file l)
        ~position:(position l + 1)
        ~line:(line l)
        ~column:(column l + 1)
end)
