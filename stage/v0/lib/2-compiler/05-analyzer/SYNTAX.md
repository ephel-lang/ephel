```ebnf
declaration ::=
    value

value ::=
    'val' id '=' term

term ::=
    unit
    IDENT
    literal
    functional
    group
    product
    coproduct

unit ::= 
    '(' ')'

literal ::=
    STRING | INTEGER

functional ::=
    -- abstraction
    (ident)+ '=>' term
    -- application   
    term term
    -- let binding
    'let' ident = term 'in' term

group ::=
    '(' term ')'

product ::=
    term ',' term
    'fst' term
    'snd' term

coproduct ::=
    'case' term term term
    'inl' term
    'inr' term
```