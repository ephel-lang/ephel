```ebnf
declaration ::=
    value

value ::=
    'val' id '=' term

term ::=
    ident
    literal
    functional
    group
    product
    coproduct

group ::=
    '(' term ')'

literal ::=
    STRING

functional_term ::=
    -- abstraction
    (ident)+ '=>' term
    -- application   
    term term
    -- let binding
    'let' ident = term 'in' term

product ::=
    term ',' term
    'fst' term
    'snd' term

coproduct ::=
    'case' term term term
    'inl' term
    'inr' term
```