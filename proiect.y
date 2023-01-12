%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    
    extern char* yytext;
    extern int yylineno;
    extern FILE* yyin;
    void yyerror(const char *s);

    
 %}

%token GLOBAL_VAR FUN PREDEF MAIN
%token TYPE NATURAL INTEGER FLOAT CHAR STRING BOOL MATRIX 
%token CLASS PRIVATE PUBLIC CLASS_OP
%token IDENTIFIER CONST 
%token DEFINE
%token RETURN
%token BLOCK_BEGIN BLOCK_END TUPLE_BEGIN TUPLE_END MAT_BEGIN MAT_END INSTR_END COMMA_SEP ASSIGN
%token IF ELSE FOR WHILE
%token ADD SUB MUL DIV MOD LOGICAL_OPERATOR OR AND NOT
%start program

%%

program: section_GlobalVar section_Functions section_PredefData section_Main  {
    printf("Program corect sintactic\n");
}
;

section_GlobalVar: 
       GLOBAL_VAR  BLOCK_BEGIN BLOCK_END
       | GLOBAL_VAR  BLOCK_BEGIN lista_GlobalVar BLOCK_END
       ;

lista_GlobalVar:
       declarareVar  
       | lista_GlobalVar declarareVar  
       | declarareClass
       | lista_GlobalVar declarareClass
       ;

declarareClass:
      CLASS IDENTIFIER BLOCK_BEGIN bloc_clasa BLOCK_END
      |CLASS IDENTIFIER BLOCK_BEGIN  BLOCK_END
      ;

bloc_clasa:
      PUBLIC CLASS_OP bloc2_clasa PRIVATE CLASS_OP bloc2_clasa
      | PUBLIC CLASS_OP  PRIVATE CLASS_OP bloc2_clasa
      |  PUBLIC CLASS_OP bloc2_clasa PRIVATE CLASS_OP 
     ;

bloc2_clasa:
      declarareFunctieClasa
      | declarareVar
      | bloc2_clasa declarareFunctieClasa
      | bloc2_clasa declarareVar
      ;

declarareVar:
       TYPE declarare 
       | CONST TYPE atribuire
       | IDENTIFIER declarare
       | CONST IDENTIFIER atribuire
       ;

declarareFunctieClasa:
      IDENTIFIER TUPLE_BEGIN lista_parametri TUPLE_END
     |  IDENTIFIER TUPLE_BEGIN TUPLE_END 
               ;

declarare :
      IDENTIFIER  
               | IDENTIFIER MAT_BEGIN NATURAL MAT_END MAT_BEGIN NATURAL MAT_END
               | atribuire
               ;

value: 
    STRING 
    | CHAR 
    | NATURAL
    | INTEGER 
    | FLOAT 
    | IDENTIFIER
    | BOOL
    | IDENTIFIER MAT_BEGIN NATURAL MAT_END MAT_BEGIN NATURAL MAT_END
    ;

section_Functions: 
       FUN BLOCK_BEGIN BLOCK_END 
       | FUN BLOCK_BEGIN lista_Functions BLOCK_END
       ;
    
lista_Functions:
       declarareFunctie
       | lista_Functions declarareFunctie 
       ;

declarareFunctie:
     TYPE IDENTIFIER TUPLE_BEGIN lista_parametri TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END 
               | TYPE IDENTIFIER TUPLE_BEGIN lista_parametri TUPLE_END  BLOCK_BEGIN BLOCK_END  
               | TYPE IDENTIFIER TUPLE_BEGIN TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END 
               | TYPE IDENTIFIER TUPLE_BEGIN TUPLE_END BLOCK_BEGIN BLOCK_END  
               ;

lista_parametri : 
        parametru 
        | lista_parametri COMMA_SEP parametru 
        ;

bloc_functie:
     declarareVar 
    | atribuire
    | called_function 
    | control_instruction
    | RETURN value 
    | RETURN expression
    | bloc_functie declarareVar 
    | bloc_functie atribuire
    | bloc_functie called_function 
    | bloc_functie control_instruction
    | bloc_functie RETURN value
    | bloc_functie RETURN expression
    ;

atribuire:
    IDENTIFIER ASSIGN value
    | IDENTIFIER MAT_BEGIN NATURAL MAT_END MAT_BEGIN NATURAL MAT_END ASSIGN value
    | IDENTIFIER ASSIGN expression
    | IDENTIFIER MAT_BEGIN NATURAL MAT_END MAT_BEGIN NATURAL MAT_END ASSIGN expression
    | IDENTIFIER ASSIGN called_function
    | IDENTIFIER MAT_BEGIN NATURAL MAT_END MAT_BEGIN NATURAL MAT_END ASSIGN called_function

expression:
    value ADD value
    | value SUB value
    | value MUL value
    | value DIV value
    | value MOD value
    | value AND value
    | value OR value
    | NOT value
    | value LOGICAL_OPERATOR value
    | value ADD expression
    | value SUB expression
    | value MUL expression
    | value DIV expression
    | value MOD expression
    | value AND expression
    | value OR expression
    | NOT expression
    | value LOGICAL_OPERATOR expression
    ;
    
parametru:
    TYPE IDENTIFIER
    | CONST TYPE IDENTIFIER 
    | expression
    | called_function
    ;

called_function:
    IDENTIFIER TUPLE_BEGIN called_lista_parametri TUPLE_END
    | IDENTIFIER  TUPLE_BEGIN  TUPLE_END
    ;

called_lista_parametri:
    value
    | expression
    | called_function
    | called_lista_parametri COMMA_SEP value
    | called_lista_parametri COMMA_SEP expression
    | called_lista_parametri COMMA_SEP called_function
    ;

control_instruction:
    if_instruction
    | while_instruction
    | for_instruction
    ;

if_instruction:
    IF TUPLE_BEGIN expression TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END
    | IF TUPLE_BEGIN expression TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END ELSE BLOCK_BEGIN bloc_functie BLOCK_END
    | IF TUPLE_BEGIN value TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END
    | IF TUPLE_BEGIN value TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END ELSE BLOCK_BEGIN bloc_functie BLOCK_END
    ;

while_instruction:
    WHILE TUPLE_BEGIN expression TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END
    | WHILE TUPLE_BEGIN value TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END
    ;

for_instruction:
    FOR TUPLE_BEGIN atribuire_for INSTR_END condition_for INSTR_END pas_for TUPLE_END BLOCK_BEGIN bloc_functie BLOCK_END
    ;

atribuire_for:
    IDENTIFIER ASSIGN NATURAL
    ;

condition_for:
    IDENTIFIER LOGICAL_OPERATOR NATURAL 
    | IDENTIFIER LOGICAL_OPERATOR IDENTIFIER
    ;

pas_for:    
    IDENTIFIER ASSIGN IDENTIFIER ADD value
    | IDENTIFIER ASSIGN IDENTIFIER SUB value
    | IDENTIFIER ASSIGN IDENTIFIER MUL value
    | IDENTIFIER ASSIGN IDENTIFIER DIV value 
    ;

section_PredefData: 
       PREDEF BLOCK_BEGIN BLOCK_END
       | PREDEF BLOCK_BEGIN lista_PredefData BLOCK_END
       ;

lista_PredefData:
       declararePredef 
       | lista_PredefData declararePredef 
       ;

declararePredef:
    DEFINE IDENTIFIER STRING
    | DEFINE IDENTIFIER CHAR
    | DEFINE IDENTIFIER NATURAL
    | DEFINE IDENTIFIER INTEGER
    | DEFINE IDENTIFIER FLOAT
    | DEFINE IDENTIFIER BOOL
    ;

section_Main: 
       MAIN  BLOCK_BEGIN BLOCK_END
       | MAIN  BLOCK_BEGIN bloc_functie BLOCK_END
       ;

 
%%

int main(int argc, char **argv) {
    yyin  = fopen(argv[1], "r");
    yyparse();

    fclose(yyin);
    return 0;
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s linie: %d \n", msg,yylineno);
}
