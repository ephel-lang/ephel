  open Ephel_compiler_objcode
  open Ephel_compiler_ast

  module Monad = Preface.Result.Monad (struct
    type t = string
  end)

  let consume n s =
    let rec consume i s =
      let open Monad in
      let open Objcode in
      let open Stack in
      match s with
      | [] -> Error ("Transpilation error: " ^ n ^ " not found!")
      | VAR m :: s' when n = m -> Ok ([ DUP (i, n) ], VAR m :: s')
      | v :: s ->
        let+ o, s = consume (i + 1) s in
        (o, v :: s)
    in
    consume 0 s

  let garbage n s =
    let rec garbage i s =
      let open Monad in
      let open Objcode in
      let open Stack in
      match s with
      | [] -> Error ("Transpilation Error: " ^ n ^ " not found!")
      | VAR m :: s when n = m -> Ok (DROP (i, n), s)
      | v :: s ->
        let+ o, s = garbage (i + 1) s in
        (o, v :: s)
    in
    garbage 0 s

  let rec compile_binding :
      type a. string -> a Term.t -> Stack.t list -> (Objcode.t list * Stack.t list, string) result =
   fun n e s ->
    let open Monad in
    let open Stack in
    let* o, s' = compile e (VAR n :: s) in
    let+ g_o, s' = garbage n s' in
    (o @ [ g_o ], s')

  and compile : type a. a Term.t -> Stack.t list -> (Objcode.t list * Stack.t list, string) result =
   fun e s ->
    let open Monad in
    let open Term in
    let open Objcode in
    let open Stack in
    match e with
    (* Atoms *)
    | Unit -> Ok ([ PUSH UNIT ], VAL "unit" :: s)
    | Int i -> Ok ([ PUSH (INT i) ], VAL "int" :: s)
    | Var n ->
      let+ o, s = consume n s in
      (o, VAL n :: s)
    (* Sum *)
    | Inl e ->
      let* o, s = compile e s in
      let+ s = remove 1 s in
      (o @ [ LEFT ], VAL "left" :: s)
    | Inr e ->
      let* o, s = compile e s in
      let+ s = remove 1 s in
      (o @ [ RIGHT ], VAL "right" :: s)
    | Case (e, Abs ([n], l), Abs ([m], r)) -> (* TODO(didier) *)
      let* e_o, s = compile e s in
      let* s = remove 1 s in
      let* l_o, _ = compile_binding n l s in
      let+ r_o, _ = compile_binding m r s in
      (e_o @ [ CASE (l_o, r_o) ], VAL "case" :: s)
    (* Product *)
    | Pair (l, r) ->
      let* r_o, _ = compile r s in
      let+ l_o, _ = compile l (VAL "cdr" :: s) in
      (r_o @ l_o @ [ PAIR ], VAL "pair" :: s)
    | Fst o ->
      let* l_o, s = compile o s in
      let+ s = remove 1 s in
      (l_o @ [ FST ], VAL "fst" :: s)
    | Snd o ->
      let* l_o, s = compile o s in
      let+ s = remove 1 s in
      (l_o @ [ SND ], VAL "snd" :: s)
    (* Abstraction and Application *)
    | Abs ([n], e) -> (* TODO(didier) *)
      let+ o, _ = compile_binding n e [] in
      ([ LAMBDA ([n], o) ], VAL "lambda" :: s)
(*
    | Let (n, e, f) ->
      let* e_o, s = compile e s in
      let* s' = remove 1 s in
      let+ l_o, s = compile_binding n f s' in
      (e_o @ l_o, s)
*)
    | App (l, r) ->
      (* TODO: Track partial applications *)
      let* o_l, s = compile l s in
      let* o_r, s = compile r s in
      let+ s = remove 2 s in
      (o_l @ o_r @ [ EXEC ], VAL "app" :: s)
    | Rec (f, Abs ([n], e)) -> (* TODO(didier) *)
      let* o, s = compile_binding n e [ VAR f ] in
      let+ g, _ = garbage f s in
      ([ LAMBDA_REC (f, [n], o @ [ g ]) ], VAL "lambda-rec" :: s)
    | Ffi (f, a) ->
      let+ s = remove a s in
      ([ FFI (f, a) ], VAR "ffi" :: s)
    | _ -> Error ("Cannot compile expression: " ^ Render.to_string e)

  let run : type a. a Term.t -> (Objcode.t list, string) result =
   fun e ->
    let open Monad in
    compile e [] <&> fst