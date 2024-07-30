# Ephel Roadmap

## Bootstrap

```mermaid
flowchart TD
    Z[v0 - Ephel source code compiler in OCaml] --> Y{{OCaml Compiler}}
    Y --> X{{v0 - Ephel source code compiler}}
    G[Ephel ObjCode Interpet in Ocaml] --> H{{OCaml Compiler}}
    H --> I{{OCaml ObjCode Interpet}}
    A[V1 - Ephel source code compiler in Ephel] --> X
    X --> C[v1 - Ephel source code compiler ObjCode]
    C --> I
    A .-> I
    I --> F[v2 - Ephel source code compiler ObjCode]   
```

### Stage 1: Ocaml compiler

This compiler is a simple and basic runtime dedicated
to the interpretation of a subset of Ephel source code.

### Stage 2: Ephel Compiler

This first compiler written in Ephel produces Compiler bytecode.

### Stage 3: Ephel Runtime

Such a runtime allows Ephel source code to be executed in another runtime. 
For this purpose, the Rust, Go, Java, C#, C++, Javascript and WASM runtimes 
should also be targeted.

## Extensions

### Stage 1: Type checker

### Stage 2: Level language

