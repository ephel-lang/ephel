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
    variable
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
    
variable ::=
    id
    
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
    process '||' process
    <id:term>.process
    <process>
    term    
```