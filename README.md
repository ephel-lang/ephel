# Ephel

Ephel is a language mixing [functional programming](https://en.wikipedia.org/wiki/Functional_programming) and [Ambient Calculus](https://en.wikipedia.org/wiki/Ambient_calculus).

The functional paradigm is dedicated to the expression of behaviors, while the ambient paradigm is dedicated to structuring and topological management.

## Functional programming layer

- [Parsing Mixfix Operators](https://www.cse.chalmers.se/~nad/publications/danielsson-norell-mixfix.pdf)
- [The calculus of constructions](https://hal.inria.fr/inria-00076024/document)
- [A simple type-theoretic language: Mini-TT](https://www.cse.chalmers.se/~bengt/papers/GKminiTT.pdf)
- [ΠΣ: Dependent Types without the Sugar](http://www.cs.nott.ac.uk/~psztxa/publ/pisigma-new.pdf)
- [Cayenne a language with dependent types](https://dl.acm.org/doi/pdf/10.1145/289423.289451)
- [Implementing Dependent Types in pi-forall](https://arxiv.org/pdf/2207.02129.pdf)
- [Complete and Easy Bidirectional Typechecking for Higher-Rank Polymorphism](https://www.cl.cam.ac.uk/~nk480/bidir.pdf)
- [Homotopy Type Theory](https://homotopytypetheory.org/book/)

The functional layer is strongly statically typed with dependent types.

It covers:

- the core lambda calculus
- dependent function types,
- dependent product types,
- dependent coproduct types,
- dependent records (can subsume sigma type) and
- dependent recursive types.

Cf. work on [Nehtra](https://github.com/lambe-lang/nethra) for the type checker and [Mitch](https://github.com/lambe-lang/mitch/) for the execution.

### A taste of Ephel functional programming layer

#### Module  category.functor

```ocaml
sig Map : (type -> type) -> type
val Map = F =>
    sig struct
        sig map : {A B:type} -> (A -> B) -> F A -> F B
        val _<$>_ : sig of map = map
    end

sig Functor : (type -> type) -> type
val Functor = F =>
    sig struct
        open Map F

        sig Laws :
            let open std.core in
            sig struct
                sig ''map id :=: id'' :
                    {A:type}
                    -> (a:F A)
                    -----------------
                    -> map id a :=: a

                sig ''map f <| map g :=: map (f <| g)'' :
                    {A B C:type}
                    -> {f:B -> C} -> {g:A -> B}
                    -> (a:F A)
                    ----------------------------------------
                    -> (map f <| map g) a :=: map (f <| g) a
            end
    end

sig Api : type
val Api = Functor
```

#### Module option

```ocaml
-{ Type definition }-

sig _? : type -> type (infix 200)
val _? = A =>
    | None : A?
    | Some : A -> A?

-{ Constructors }-

val none : {A:type} -> A? = None
val some : {A:type} -> A -> A? = Some

-{ Functor }-

val Functor : category.functor.Api _? =
    val struct
        val map = f =>
            | None => None
            | Some a => Some $ f a

        val Laws =
            val struct
                val ''map id :=: id'' =
                    | None   => refl
                    | Some _ => refl

                val ''map f <| map g :=: map (f <| g)'' =
                    | None   => refl
                    | Some _ => refl
            end
    end
```

## Ambient programming layer

References:
- [Ambient Calculus](https://en.wikipedia.org/wiki/Ambient_calculus)
- [Mobile Safe Ambients](https://dl.acm.org/doi/pdf/10.1145/596980.596981)
- [The synchronized ambient calculus](https://www.sciencedirect.com/science/article/pii/S030439752400094X)
- [Types for the Ambient Calculus](https://www.microsoft.com/en-us/research/wp-content/uploads/2002/01/Types-for-the-ambient-calculus.pdf)
- [A Dependently Typed Ambient Calculus](https://eprints.soton.ac.uk/262298/1/dtaESOPoff.pdf)

Ephel provides three types dedicated to Ambient Calculus.

### Ambient name

```ocaml
val name: ambient name =
    `test
```

### Ambient capability

```ocaml
val in_action : ambient name -> ambient capability
    = name p => in name

val out_action : ambient name -> ambient capability
    = name p => out name

val open_action : ambient name -> ambient capability
    = name p => open name

val combine_action : ambient capability -> ambient capability -> ambient capability
    = a1 a2 => a1.a2 
```

### Ambient process

```ocaml
val output : {A:type} -> A -> ambient process =
    = m => <m>
     
val input : (A:type) -> (A -> ambient process) -> ambient process =
    = A f => <x:A>.(f x)

val zero : ambient process =
    ()

val amb : ambient name -> ambient process -> ambient process 
    = n p => n[ p ] 

val parallel : ambient process -> ambient process -> ambient process
    = p1 p2 => p1 | p2 
    
val cap : ambient capability -> ambient process -> ambient process
    = c p => c.p     

-- Objective move
val go_cap : ambient capability -> ambient process -> ambient process
    = c p => go c.p       
```

### A taste of Ephel Ambient Calculus layer

A basic ping pong game can be proposed using Ephel. 

#### Topological approach

We identify three scoped ambient:
- `ping` for the first player,
- `pong` for the second player and
- `printer` in charge of printing the winner

```ocaml
sig play : ambient name -> ambient name -> Nat -> ambient process
val play = sender receiver =>
    | Zero   => go (out sender.in `printer).<sender> 
    | Succ n => <x:Nat>.(play sender receiver x) | go (out sender.in receiver).<n> in

sig to : @infix (ambient name -> ambient process) -> ambient name -> ambient process
val to = f p => f p

sig player : ambient name -> ambient name -> ambient process
val player = sender receiver =>
    sender[ <x:Nat>.(play sender receiver x) ]

 val _ : ambient process =
    (player `ping to `pong)                  |
    (player `pong to `ping)                  |
    `printer[ (x:ambient name).(println x) ] |
    go in `ping.<42>
```

#### Functional approach

Since types are used for behavior selection this code can be revisited by removing 
all scoped Ambient for a simpler implementation using dependent type.

```ocaml
val ping : type = Ping : nat -> ping
val ping_to_nat : ping -> nat = Ping n => n

val pong : type = Pong : nat -> pong
val pong_to_nat : pong -> nat = Pong n => n

sig play : {A:type} -> string -> (nat -> A) -> (A -> nat) -> nat -> ambient process
val play = {A} who to_a from_a =>
    | Zero   => <who>
    | Succ n => <x:A>.(play who fa from_a $ from_a a) | <to_a n>

val _ : ambient process =
    <n:pong>.(play "Bob"   Ping pong_to_nat $ pong_to_nat n) | 
    <n:ping>.(play "Alice" Pong ping_to_nat $ ping_to_nat n) |
    <x:string>.(println x)                                   |
    <Pong 42>
```

Such an Ambient process implicitly captures the Actor paradigm.

## Ambient and physical distribution [WIP]

References:
-  [Safe Ambients: Abstract machine and distributed implementation](https://www.sciencedirect.com/science/article/pii/S016764230500064X)
- [An efficient abstract machine for Safe Ambients](https://www.sciencedirect.com/science/article/pii/S1567832607000033?via%3Dihub)
- [Boxed Ambients](https://www.irif.fr/~gc/papers/tacs01.pdf)
- [A Distributed Abstract Machine for Boxed Ambient Calculi
](https://www.microsoft.com/en-us/research/publication/a-distributed-abstract-machine-for-boxed-ambient-calculi/)

Since Ambient calculus targets concurrent systems with mobility we would like to distribute an ambient hierarchy physically. 

For example, we can imagine the following ambient process

```
`A[ `B[ P ] | `C[ Q ] | `D[ R ] | <x:T>.F ]
```

with \`A and \`D ambients located in a physical process `P1`, \`B in `P2` and \'C in `P3`.

```
`A[ `B[ P ] | `C[ Q ] | `D[ R ] | <x:T>.F ]
 |   |    |     |    |                    |
 |   P2---+     P3---+                    |
 |                                        |
 P1---------------------------------------+
```

### Ambient Scope and capability reduction

Each capability requires a specific scope:

- in m: instructs the surrounding ambient to enter some sibling ambient m
- out m: instructs the surrounding ambient to exit its parent ambient m
- open m: instructs the surrounding ambient to dissolve the boundary of an ambient m

- Note: `A@ in this formalism means ambient hosted in another **physical** process.

```
    P1: `A[ `B@ | `C@ | `D[ R ] | <x:T>.F ]
    P2: `A@[ `B[ P ] | `C@ | `D@ ]
    P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

For instance, in P2 \`B (resp. P3 \`C and P1 \`D) has information related to:
- its sibling ambient
- its parent ambient

### Reduction implementation sketch

Each scoped Ambient process is in charge of performing embedded capability and function application on the presence of events.

So, with this minimal representation, each Ambient can perform
`in`, `out` and `open` with or without an objective move.

Functions are not represented in remote processes because the event used for its reduction is managed by the surrounding ambient.

#### Message movement using objective ambient capability

```
P1: `A[ `B@ | `C@ | `D[ R ] | <x:T>.F ]
P2: `A@[ `B[ go (out `B).<m> ] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

reduces to

```
P1: `A[ <m> | `B@ | `C@ | `D[ R ] | <x:T>.F ]
P2: `A@[ `B[] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

reduces to

```
P1: `A[ `B@ | `C@ | `D[ R ] | F{x:=m} ]
P2: `A@[ `B[] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

#### Message movement using ambient capability

```
P1: `A[ `B@ | `C@ | `D[ R ] | open `M.<x:T>.F ]
P2: `A@[ `B[ `M[ out `B.<m> ] ] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

reduces to

```
P1: `A[ `M[ <m> ] | `B@ | `C@ | `D[ R ] | open `M.<x:T>.F ]
P2: `A@[ `B[] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

reduces to

```
P1: `A[ <m> | `B@ | `C@ | `D[ R ] | <x:T>.F ]
P2: `A@[ `B[] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

reduces to

```
P1: `A[ `B@ | `C@ | `D[ R ] | F{x:=m} ]
P2: `A@[ `B[] | `C@ | `D@ ]
P3: `A@[ `B@ | `C[ Q ] | `D@ ]
```

## About Ephel

[Ephel](https://www.elfdict.com/wt/21382)

## License

MIT License

Copyright (c) 2024 Didier Plaindoux

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
