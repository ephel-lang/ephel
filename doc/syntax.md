## Syntax

```
declaration ::=
    signature
    value

signature ::=
    'sig' id ':' term infix?
    
value ::=
    'val' id (':' term infix?)? =' term

term ::=
    literal
    id
    functional
    product
    coproduct
    structural
    equality
    type
    ambient
    group

group ::= 
    '(' term ')' 
    
literal ::=
    NUMBER
    STRING
    CHARACTER
  
functional_term ::= 
    -- abstraction and PM
    (id | '{' id+ '}')+ '=>' term
    ('|' term => term)+
    -- functional type
    '{' id+ ':' term '}' '->' term  
    '(' id+ ':' term ')' '->' term
    term '->' term
    -- application   
    term term
    term '{' term '}'
    -- let binding
    'let' id (':' term)? = term 'in' term
    'let' open 'in' term   
    -- meta
    'sig' 'of' term
    
product ::=
    term ',' term
    term '*' term
    '(' id+ ':' term) '*' term
    'fst' term
    'snd' term    
    
coproduct ::=
    ('|' term ':' term infix?)+
    
structural ::=  -- To be reconsidered ...
    'sig' 'struct' (open | signature | value)* 'end'
    'val' 'struct' (open | signature | value)* 'end'
    term '.' id

open ::=
    'open' term
    
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
    
name_id ::=
    name
    id
   
capability ::=
    'nocap'
    'in' name_id
    'out' name_id
    'open' name_id
    capability '.' capability
    name_id
   
process ::=
    name_id '[' process ']'
    'go' capability '.' process
    capability '.' process
    process '|' process
    <id:term>.process
    <process>
    term  
    
infix ::=
    '(' ('infixl'|'infixr') NAT ')'      
```