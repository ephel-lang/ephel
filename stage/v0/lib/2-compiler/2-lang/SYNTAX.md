declaration ::=
    value

value ::=
    'val' id '=' term

term ::=
    group
    literal
    functional
    product
    coproduct
    ident

group ::=
    '(' term ')'

literal ::=
    STRING

functional_term ::=
    -- abstraction and PM
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
