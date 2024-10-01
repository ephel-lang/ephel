# Stage 0

This is the first minimal language to be compiled. It does not manage types and accept 
the code without any kind of verification. 

Source: 

### Concrete Syntax

```
s0 ::=
    value*
    
value ::=
    'val' id '= term

term ::=
    group
    literal
    id
    functional
    product
    coproduct

group ::= 
    '(' term ')' 
    
literal ::=
    NUMBER
    STRING
    CHARACTER
  
functional_term ::= 
    -- abstraction and PM
    (id)+ '=>' term   
    -- application   
    term term
    -- let binding
    'let' id = term 'in' term
    
product ::=
    term ',' term
    'fst' term
    'snd' term  
    
coproduct ::=
    'case' id term term
    'inl' term
    'inr' term      
```

### Abstract Syntax Tree

```ocaml
type lit =
  | Int of int
  | Char of char
  | String of string

type Builtin =
  | Fst
  | Snd
  | Inl
  | Inr

type t =
  -- Basic type, identifier and literals
  | Id of string * string option
  | Literal of lit
  -- Function and application
  | Lambda of string * t
  | Apply of t * t
  | Let of string * t * t
  -- Pair type and data
  | Pair of t * t
  -- Sum data
  | Case of t * t * t
  -- Builtin
  | BuiltIn of Builtin * t
```

### Object Code

The runtime executes the following object code

```ocaml
type value =
  | INT of int
  | STRING of string
  | CHAR of char
  | UNIT

type t =
  -- Stack operations
  | PUSH of value
  | SWAP
  | DROP of int * string
  -- Memory management
  | DIG of int * string
  | DUP of int * string
  -- Sums data
  | LEFT
  | RIGHT
  | IF_LEFT of t list * t list
  -- Products data
  | PAIR
  | CAR
  | CDR
  | UNPAIR
  -- Lambda and closure 
  | EXEC
  | LAMBDA of string * t list
  | LAMBDA_REC of string * string * t list
```

### Compilation 

Partial function compilation using APPLY (Michelson)
Study of PUSH/GRAB instruction addition for closures (Zinc Abstract Machine)

```
===========================================================
((x => y => add x y) 1) 2
(1) ----
PUSH 2;PUSH 1;LAMBDA[UNPAIR;FFI 2 "add"];APPLY;EXEC        {}
PUSH 1;LAMBDA[UNPAIR;FFI 2 "add"];APPLY;EXEC               {2}
LAMBDA[UNPAIR;FFI 2 "add"];APPLY;EXEC                      {1,2}
APPLY;EXEC                                                 {1,[UNPAIR;FFI 2 "add";DROP "(x,y)" 1],2}
EXEC                                                       {[PUSH 1;PAIR;UNPAIR;FFI 2 "add";DROP "(x,y)" 1],2}
(2) ----
PUSH 1;PAIR;UNPAIR;FFI 2 "add"                             {2}
PAIR;UNPAIR;FFI 2 "add"                                    {1,2}
UNPAIR;FFI 2 "add"                                         {(1,2)}
FFI 2 "add"                                                {1,2}
0                                                          {3}
===========================================================
(x => (zero x) (y => y) (y => add x y)) 1 2
- ETA-EXPANSION expressed during compilation ...
  (x => (zero x) (y => y) ((x y => add x y) x)) 1 2
```
