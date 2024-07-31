# Ephel Roadmap

## Bootstrap

```mermaid
flowchart TD
    Z[v0 - Ephel source code compiler in OCaml] --> Y{{OCaml Compiler}}
    Y .-> X{{v0 - Ephel source code compiler}}
    G[Ephel ObjCode Interpet in Ocaml] --> H{{OCaml Compiler}}
    H .-> I{{OCaml ObjCode Interpet}}
    A[V1 - Ephel source code compiler in Ephel] --> X
    X .-> C[v1 - Ephel source code compiler ObjCode]
    C --> I
    A --> I
    I .-> F[v2 - Ephel source code compiler ObjCode]
```

### Stage 0: In Ocaml

A first compiler of a subset of Ephel source code and a runtime dedicated to the interpretation
are proposed

### Stage 1: Ephel Compiler

This first compiler written in Ephel producing Ephel bytecode. Its compilation produces an 
Ephel source code compiler objcode

### Stage 2: Ephel Compiler once again

We replay the compilation with the v1.

## Extensions

### Stage 1: Type checker

### Stage 2: Level language

