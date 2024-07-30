# Ephel Roadmap

## Bootstrap


### Stage 1: Ocaml compiler

```mermaid
flowchart LR
    A[Source code] -->|Ocaml Compiler| B(ObjCode)
    B[ObjCode] -->|OCaml Runtime| C(Value)
```

This compiler is a simple and basic runtime dedicated
to the interpretation of Nethra like source code.

### Stage 2: Ephel Compiler

```mermaid
flowchart LR
    A[Ephel Compiler source code] -->|Ocaml Compiler| B(Ephel Compiler ObjCode)
    B[Source code] -->|OCaml Runtime + Ephel Compiler ObjCode| C(ObjCode)
```

This first compiler written in Ephel produces Compiler bytecode.

### Stage 3: Ephel Runtime

Such a runtime allows Ephel source code to be executed in another runtime. 
For this purpose, the Rust, Go, Java, C#, C++, Javascript and WASM runtimes 
should also be targeted.

## Extensions

### Stage 1: Type checker

### Stage 2: Level language

