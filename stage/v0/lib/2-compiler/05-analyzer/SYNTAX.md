```ebnf
declaration ::=
    value

value ::=
    'val' id '=' term

term ::=
    ident
    literal
    product
    coproduct
    functional
    group

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
    'fst'
    'snd'

coproduct ::=
    'case' term term term
    'inl'
    'inr'
```