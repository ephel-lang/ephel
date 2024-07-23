# Stage 0

This is the first minimal language to be compiled. It does not manage types and accept 
the code without any kind of verification.

### Concrete Syntax

```
s0 ::=
    value*
    
value ::=
    'val' id '= term

term ::=
    literal
    id
    functional
    product
    coproduct
    type
    group

group ::= 
    '(' term ')' 
    
literal ::=
    NUMBER
    STRING
    CHARACTER
  
functional_term ::= 
    -- abstraction and PM
    (id)+ '=>' term
    ('|' term => term)+
    -- application   
    term term
    -- let binding
    'let' id = term 'in' term
    
product ::=
    term ',' term
    'fst' term
    'snd' term    
```

### Abstract Syntax Tree

```ocaml
type lit =
  | Int of int
  | Char of char
  | String of string

type builtin =
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
  -- builtin
  | BuiltIn of builtin * t
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
  | APPLY
```
