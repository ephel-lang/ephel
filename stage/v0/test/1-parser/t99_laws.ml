open Ephel.Parser.Parsec
open Common

(* Work in progress *)

let functor_law1 t p =
  (* map id = id *)
  let open Control.Functor (Parsec) in
  let lhd = map (fun x -> x)
  and rhd x = x in
  let s = Parsec.source [] in
  let l = response @@ lhd p s
  and r = response @@ rhd p s in
  Alcotest.(check (pair (option t) bool)) "map id = id" l r

let functor_law2 t f g p =
  (* map (f ° g) = (map f) ° (map g) *)
  let open Control.Functor (Parsec) in
  let lhd = map (fun x -> f (g x))
  and rhd x = (map f) (map g x) in
  let s = Parsec.source [] in
  let l = response @@ lhd p s
  and r = response @@ rhd p s in
  Alcotest.(check (pair (option t) bool)) "map (f ° g) = (map f) ° (map g)" l r

let monad_law1 t v p =
  (* return a >>= h = h a *)
  let open Control.Monad (Parsec) in
  let lhd = return v >>= p
  and rhd = p v in
  let s = Parsec.source [] in
  let l = response @@ lhd s
  and r = response @@ rhd s in
  Alcotest.(check (pair (option t) bool)) "return a >> h = h a" l r

let monad_law2 t p =
  (* m >>= return = m *)
  let open Control.Monad (Parsec) in
  let lhd = p >>= return
  and rhd = p in
  let s = Parsec.source [] in
  let l = response @@ lhd s
  and r = response @@ rhd s in
  Alcotest.(check (pair (option t) bool)) "m >>= return = m" l r

let monad_law3 t m g h =
  (* (m >>= g) >>= h = m >>= fun x -> g x >>= h *)
  let open Control.Monad (Parsec) in
  let lhd = m >>= g >>= h
  and rhd = m >>= fun x -> g x >>= h in
  let s = Parsec.source [] in
  let l = response @@ lhd s
  and r = response @@ rhd s in
  Alcotest.(check (pair (option t) bool)) "(m >>= g) >>= h = m >>= fun x -> g x >>= h" l r

(* Quick check should be used here *)

let cases =
  let open Alcotest in
  let open Eval (Parsec) in
  ( "Laws"
  , [
      test_case "map id = id" `Quick (fun () -> functor_law1 int @@ return 1)
    ; test_case "map (f ° g) = (map f) ° (map g)" `Quick (fun () ->
          functor_law2 int (( + ) 1) int_of_string @@ return "1" )
    ; test_case "return a >> h = h a" `Quick (fun () -> monad_law1 int 1 @@ fun v -> return v)
    ; test_case "m >> return = m" `Quick (fun () -> monad_law2 int @@ return 1)
    ; test_case "(m >>= g) >>= h = m >>= fun x -> g x >>= h" `Quick (fun () ->
          monad_law3 int (return "1") (fun v -> return @@ int_of_string v) return )
    ] )
