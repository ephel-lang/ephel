declaration ::=
    value

value ::=
    'val' id '=' term

term ::=
    group
    literal
    id
    functional
    product
    coproduct

group ::=
    '(' term ')'

literal ::=
    STRING

functional_term ::=
    -- abstraction and PM
    (id)+ '=>' term
    -- application   
    term term
    -- let binding
    'let' id = term 'in' term

product ::=
    term ',' term
    'fst' term
    'snd' term

coproduct ::=
    'case' term term term
    'inl' term
    'inr' term
