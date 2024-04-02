# Ephel

Ephel is a language mixing [functional programming](https://en.wikipedia.org/wiki/Functional_programming) and [Ambient Calculus](https://en.wikipedia.org/wiki/Ambient_calculus).

The functional paradigm is dedicated to the expression of behaviors, while the ambient paradigm is dedicated to structuring and topological management.

## Functional programming layer

The functional layer is strongly statically typed with dependent types.

It covers:

- the core lambda calculus
- dependent function types,
- dependent product types,
- dependent coproduct types,
- dependent records (can subsume sigma type) and
- dependent recursive types.

## Ambient programming layer

Ephel provides three types dedicated to Ambient Calculus.

### Ambient name

```ocaml
val name : ambient name =
    `test
```

### Ambient action

```ocaml
val in_action : ambient name -> ambient action
    = name p => in name

val out_action : ambient name -> ambient action
    = name p => out name

val open_action : ambient name -> ambient action
    = name p => open name

val combine_action = ambient action -> ambient action -> ambient action
    = a1 a2 => a1.a2 
```

### Ambient process

```ocaml
val output : (A:type).A -> ambient process =
    = m => <m>
     
val input : (A:type) -> (A -> ambient process) -> ambient process =
    = A f => <x:A>.(f x)

val zero : ambient process =
    ()

val amb : ambient name -> ambient process -> ambient process 
    = n p => n[ p ] 

val parallel : ambient process -> ambient process -> ambient process
    = p1 p2 => p1 || p2 
    
val cap : ambient action -> ambient process -> ambient process
    = c p => c.p     

-- Objective move
val go_cap : ambient action -> ambient process -> ambient process
    = c p => go c.p       
```

### Example

A basic ping pong game can be proposed using Ephel. 

#### Topological approach

We identify three scoped ambient:
- `ping` for the first player,
- `pong` for the second player and
- `printer` in charge of printing the winner

```ocaml
sig to : @infix ambient name -> ambient name -> nat -> ambient process
val to = sender receiver =>
    | Zero   => go (out sender.in `printer).<ambient name,sender> ]
    | Succ n => <x:nat>.(sender to receiver x) || go (out sender.in receiver).<nat,n>

sig against : @infix ambient name -> ambient name -> ambient process
val against = sender receiver =>
    sender[ <x:nat>.(sender to receiver x) ] || 
    receiver[ <x:nat>.(receiver to sender x) ]

 val _ : ambient process =
    (`ping against `pong) ||
    `printer[ <x:ambient name>.(println $ x value) ] ||
    go in `ping.<nat , 42>
```

#### Functional approach

Since types are used for behavior selection this code can be revisited removing 
all scoped Ambient for a simpler implementation using dependent type.

```ocaml
val ping : type = Ping : nat -> ping
val ping_to_nat : ping -> nat = Ping n => n

val pong : type = Pong : nat -> pong
val pong_to_nat : pong -> nat = Pong n => n

sig play : {A:type} -> string -> (nat -> A) -> (A -> nat) -> nat -> ambient process
val play = {A} who to_a from_a =>
    | Zero   => <string,who>
    | Succ n => <x:A>.(play who fa from_a $ from_a a) || <A,to_a n>

 val _ : ambient process =
    <n:pong>.(play "Bob"   Ping pong_to_nat $ pong_to_nat n) || 
    <n:ping>.(play "Alice" Pong ping_to_nat $ ping_to_nat n) ||
    <x:string>.(println x)                                   ||
    <pong , Pong 42>
```

We can remark that such Ambient process implicitly captures the Actor paradigm.

## About

[Ephel](https://www.elfdict.com/wt/21382)

## License



