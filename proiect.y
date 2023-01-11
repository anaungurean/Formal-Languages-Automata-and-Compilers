%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    void yyerror(const char *s);
    int yylex();
    int yywrap();
%}

%token GLOBAL_VAR FUN PREDEF MAIN
%token TYPE NATURAL INTEGER FLOAT CHAR STRING BOOL MATRIX CLASS
%token IDENTIFIER CONST 
%token DEFINE
%token BLOCK_BEGIN BLOCK_END TUPLE_BEGIN TUPLE_END MAT_BEGIN MAT_END INSTR_END COMMA_SEP ASSIGN
%token IF ELSE FOR WHILE
%token ADD SUB MUL DIV MOD LOGICAL_OPERATOR OR AND NOT

%%

program: section_GlobalVar section_Functions section_PredefData section_Main 
;

section_GlobalVar: 
       GLOBAL_VAR '{' '}' 
       | GLOBAL_VAR '{' lista_GlobalVar '}'
       ;

section_Functions: 
       FUN '{' '}' 
       | FUN '{' lista_Functions '}'
       ;
    
section_PredefData: 
       PREDEF '{' '}' 
       | PREDEF '{' lista_PredefData '}'
       ;

section_Main: 
       MAIN '{' '}' 
       | MAIN '{' section_Cod  '}'
       ;

lista_GlobalVar:
       declarareVar ';'
       | lista_GlobalVar declarareVar ';'
       ;

lista_Functions:
       declarareFunctie
       | lista_Functions declarareFunctie 
       ;

lista_PredefData:
       declararePredef 
       | lista_PredefData declararePredef';'
       ;

section_Cod:
       linie_Cod
       | section_Cod linie_Cod
       ;


declarareVar:
       TYPE declarare 
       | CONST TYPE atribuire_declarare 
       | IDENTIFIER declarare
       | CONST IDENTIFIER atribuire_declarare 
       ;

declarareFunctie:
     TYPE IDENTIFIER '(' lista_parametri ')' '{' bloc_functie '}' 
               | TYPE IDENTIFIER '(' lista_parametri ')' '{' '}'  
               | TYPE IDENTIFIER '(' ')' '{' bloc_functie '}'  
               | TYPE IDENTIFIER '(' ')' '{' '}'  
               ;

declararePredef:
    DEFINE IDENTIFIER STRING
    | DEFINE IDENTIFIER CHAR
    | DEFINE IDENTIFIER NATURAL
    | DEFINE IDENTIFIER INTEGER
    | DEFINE IDENTIFIER FLOAT
    | DEFINE IDENTIFIER BOOL
    ;
      
linie_Cod:
    declarareVar ';'
    | atribuire ';'
    | control_instruction
    | called_function ';'
    ;
    
declarare :
      IDENTIFIER  
               | IDENTIFIER '['NATURAL']' '['NATURAL']'  
               | atribuire_declarare 
               | declarare ',' IDENTIFIER  
               | declarare ',' IDENTIFIER '[' NATURAL ']' '['NATURAL']'  
               | declarare ',' atribuire_declarare  
               ;

atribuire_declarare :
        IDENTIFIER ASSIGN expression
        IDENTIFIER ASSIGN STRING

lista_parametri : 
        parametru 
        | lista_parametri ',' parametru 
        ;

bloc_functie:
     declarareVar ';'
    | atribuire ';'
    | control_instruction
    | called_function ';'
    | bloc_functie declarareVar ';'
    | bloc_functie atribuire ';'
    | bloc_functie control_instruction
    | bloc_functie called_function ';'

value: 
    STRING 
    | CHAR 
    | NATURAL
    | INTEGER 
    | FLOAT 
    | IDENTIFIER
    ;

expression:
    value
    | expression ADD expression 
    | expression SUB expression 
    | expression MUL expression 
    | expression DIV expression 
    | expression MOD expression 
    | '-' expression 
    | NOT expression 
    | expression AND expression 
    | expression OR expression 
    | expression LOGICAL_OPERATOR expression 
    | '(' expression ')' 
    ;

parametru:
    TYPE IDENTIFIER
    | CONST TYPE IDENTIFIER 
    ;

atribuire:
    IDENTIFIER ASSIGN expression 
    | IDENTIFIER '[' NATURAL ']' '[' NATURAL ']' ASSIGN expression
    ;

control_instruction:
    if_instruction
    | while_instruction
    | for_instruction
    ;

called_function:
    IDENTIFIER '(' called_lista_parametri ')' 
    | IDENTIFIER '(' ')'
    ;

if_instruction:
    IF '(' expression ')' '{' bloc_functie '}'
    | IF '(' expression ')' '{' bloc_functie '}' ELSE '{' bloc_functie '}'
    ;

while_instruction:
    WHILE '(' expression ')' '{' bloc_functie '}'
    ;

for_instruction:
    FOR '(' atribuire_for ';' condition_for ';' pas_for ')' '{' bloc_functie '}'
    ;

called_lista_parametri:
    value
    | expression
    | called_function
    | called_lista_parametrii ',' value
    | called_lista_parametrii ',' expression
    | called_lista_parametrii ',' called_function
    ;

atribuire_for:
    IDENTIFIER ASSIGN NATURAL
    ;

condition_for:
    IDENTIFIER LOGICAL_OPERATOR NATURAL 
    | IDENTIFIER LOGICAL_OPERATOR IDENTIFIER
    ;

pas_for:    
    IDENTIFIER ASSIGN IDENTIFIER ADD IDENTIFIER 
    | IDENTIFIER ASSIGN IDENTIFIER SUB IDENTIFIER 
    | IDENTIFIER ASSIGN IDENTIFIER MUL IDENTIFIER 
    | IDENTIFIER ASSIGN IDENTIFIER DIV IDENTIFIER 
    ;

%%

int main() {
    yyparse();
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}
