## Syntax

```
declaration ::=
    signature
    value

signature ::=
    'sig' id ':' term
    
value ::=
    'val' id (':' term)? =' term

term ::=
    literal
    functional
    product
    coproduct
    structural
    recursion <- Need to be considered differently
    equality
    type
    ambient
    
literal ::=
    NUMBER
    STRING
    CHARACTER
    
functional ::= 
    (id | '{' id+ '}')+ '=>' term
    ('|' term => term)+
    '{' id+ ':' term '}' '->' term  
    '(' id+ ':' term ')' '->' term
    term '->' term
    term term
    term 'match' ('|' term => term)+
    'let' id (':' term)? = term in term
    '(' term ')'
    
product ::=
    term ',' term
    term '*' term
    '(' id+ ':' term) '*' term
    'fst' term
    'snd' term    
    
coproduct ::=
    term '|' term
    'inl' term
    'inr' r
    'case' id term term
    
structural ::= 
    'sig' 'struct' signature* 'end'
    'val' 'struct' value* 'end'
    
recursion ::=
    'rec' '(' id ':' term ')' '.' term
    'fold' term
    'unfold' term
    
 equality ::=
    'refl'
    'subst' term 'by' term
    term '=' term
    
 type ::=
    'type'   
    
 ambient ::=
    name
    capability
    process

name ::=
    '`' id '@'? 
   
capability ::=
    'nothing' 
    'in' (name | id)
    'out' (name | id)
    'open' (name | id)
    capability '.' capability
process ::=
    (name | id) '[' process ']'
    'go' (capability | id) '.' process
    (capability | id) '.' process
    process '||' process
    <id:term>.process
    <process>
    term    
```