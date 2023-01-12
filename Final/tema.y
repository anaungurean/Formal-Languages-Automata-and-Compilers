%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "temafinal.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern char* yytext;

%}
%union {
  int intVal; //valoare
  char* dataType; // tip de data
  char* strVal; // IDENTIFIER
  char *key;
}

%token EQ PLUS MINUS FUNC CLASA DEQ DIF LEQ GEQ LE GE AND OR EVAL OBJ BEG END RETURN TRUE FALSE WHILE FOR IF ELSE CHARVAL STRINGVAL
%token <dataType> INT BOOL STRING CHAR FLOAT VOID MATRIX
%token <intVal> NR
%token <strVal> IDENTIFIER
%token GLOBAL_VAR FUN PREDEF MAIN 
%token DEFINE

%type <intVal> exp e 

%start s
%left PLUS MINUS
%left DIV MUL
%%

s: progr {printf ("\n Limbajul este corect din punct de vedere sintactic.\n"); Print(); Write();WriteFunc();}

progr : section_global_variables section_functions section_predefData section_main
section_global_variables:
     GLOBAL_VAR BEG END
     | GLOBAL_VAR BEG global_variables END
     ;

global_variables : objects
                 | EVAL '(' exp ')'
                 ;

objects : objects object variabileplus
        | object variabileplus
        ;

object : CLASA OBJ IDENTIFIER BEG variabile OBJEnd 
       | CLASA OBJ IDENTIFIER BEG OBJEnd
       ;

variabileplus  : { instruction_add(); }
               ;

OBJEnd    : END { instruction_minus(); }
          ;

variabile    : variabile variabila
             | variabila
             ;

variabila : INT IDENTIFIER EQ NR';' {insert($1,$2,$4);}
          | INT IDENTIFIER';'       {insert($1, $2, 9999);}
          | CHAR IDENTIFIER EQ CHARVAL';'{insert($1, $2, -1);}
          | CHAR IDENTIFIER';'        {insert($1, $2, -1);}
          | STRING IDENTIFIER EQ STRINGVAL';'{insert($1, $2, -1);}
          | STRING IDENTIFIER';'{insert($1, $2, -1);}
          | BOOL IDENTIFIER EQ TRUE';'{insert($1, $2, 1);}
          | BOOL IDENTIFIER EQ FALSE';'{insert($1, $2, 0);}
          | BOOL IDENTIFIER';'{insert($1,$2,-1);}
          | MATRIX IDENTIFIER EQ matrixlist';'{insert($1, $2, -1);}
          | OBJ IDENTIFIER object';'
          | OBJ IDENTIFIER';'
          | EVAL '(' exp ')'
          | IDENTIFIER '(' calls ')'  {    inserareNume($1);
                                                   if (verificareIdentitate($1)==0)
                                                       printf("Tipul functiei apelate nu se potriveste cu tipurile declarate pentru %s \n", $1);
                                             }

matrixlist : '['']'
          | '['list']'
          | '['']' matrixlist 
          | '['list']' matrixlist
          ;

list : list ',' listval
     | listval
     ;

listval : NR
        | CHARVAL
        | STRINGVAL
        | IDENTIFIER
        | object
        | matrixlist
        ;

section_functions:
     FUN BEG END
     | FUN BEG functions END
     ; 

functions : functions function variabileplus
          | function variabileplus
          ;
function  : FUNC INT IDENTIFIER  functionBody { insert_in_Func($2); insert_in_Func($3); inserareNumeMatrix($3); insert_Func();}
          | FUNC CHAR IDENTIFIER   functionBody { insert_in_Func($2); insert_in_Func($3); inserareNumeMatrix($3); insert_Func();}
          | FUNC VOID IDENTIFIER  functionBody { insert_in_Func($2); insert_in_Func($3); inserareNumeMatrix($3); insert_Func();}
          | FUNC BOOL IDENTIFIER   functionBody { insert_in_Func($2); insert_in_Func($3); inserareNumeMatrix($3); insert_Func();}
          | FUNC STRING IDENTIFIER functionBody { insert_in_Func($2); insert_in_Func($3); inserareNumeMatrix($3); insert_Func();}
          | FUNC INT EVAL '(' exp ')'
          | IDENTIFIER '(' calls ')' {    inserareNume($1);
                                                   if (verificareIdentitate($1)==0)
                                                       printf("Tipul functiei apelate nu se potriveste cu tipurile declarate pentru %s \n", $1);
                                             }
          ;

functionBody   : '(' decls ')' body
               ;

calls    : calls ',' call
         | call
         ;

call     : INT IDENTIFIER {inserareMatrixUser($1);}
                    | CHAR IDENTIFIER {inserareMatrixUser($1);}
                    | STRING IDENTIFIER {inserareMatrixUser($1);}
                    | BOOL IDENTIFIER {inserareMatrixUser($1);}
                    | function      
                    | NR {inserareMatrixUser("int");}
                    ;

decls    : decls ',' decl
         | decl
         ;

decl     : INT IDENTIFIER    {  inserareMatrixParam($1);}
         | CHAR IDENTIFIER   {  inserareMatrixParam($1);}
         | STRING IDENTIFIER {  inserareMatrixParam($1);}
         | BOOL IDENTIFIER   {  inserareMatrixParam($1);}
         ;


exp       : e  {$$=$1; printf("Valoarea expresiei este %d\n",$$);} 
          ;

e : e PLUS e   {$$=$1+$3; }
  | e MINUS e   {$$=$1-$3; }
  | e MUL e   {$$=$1*$3; }
  | e DIV e   {$$=$1/$3; }
  | NR {$$=$1; }
  | INT IDENTIFIER EQ NR';' { int i; 
                              if((i= search($2)) != -1)
                              { 
                                   update_VAL($2, $4);
                                   $$ =  tabel[i].valoare ;
                                   
                              }
                              else {
                                  printf("Variabila nu exista\n"); 
                                  printf("Eroare: argumentul pentru Eval nu este valid!\n");
                                   exit(0);
                              }
                              }
  | INT IDENTIFIER';' { int i;
                         if((i= search($2)) != -1)
                         {   
                              $$= tabel[i].valoare;
                         }
                          else 
                          {
                                   printf("Variabila nu exista\n"); 
                                   printf("Eroare: argumentul pentru Eval nu este valid!\n");
                                   exit(1);
                          }
                        }
  ;

body      : BEG blocks RETURN BODYEnd
          | BEG blocks BODYEnd
          | BEG END
          ;

BODYEnd   : END { instruction_minus(); }
          ;

blocks   : blocks block 
         | block
         ;

block    : variabila
         | assignment
         | while
         | for
         | if
         ;

while : WHILE variabileplus '(' conditii ')' body
      ;

for  : FOR variabileplus '(' assignment conditii ';' assignment ')' body
     ;

if   : IF variabileplus '(' conditii ')' body
     | IF variabileplus '(' conditii ')' body ELSE variabileplus body
     ;


assignment : IDENTIFIER EQ NR';' { update_VAL($1, $3); }
           | IDENTIFIER EQ CHARVAL';'
           | IDENTIFIER EQ STRINGVAL';'
           | IDENTIFIER EQ TRUE';'
           | IDENTIFIER EQ FALSE';'
           | IDENTIFIER EQ matrixlist';'
           | IDENTIFIER EQ operatie';' 
           | IDENTIFIER EQ IDENTIFIER';' { update_ID($1, $3); }
           ;

operatie  : plus
          | minus
          | mul
          | div
          ;

plus : IDENTIFIER PLUS IDENTIFIER { check_declarations($1); check_declarations($3); }
     | IDENTIFIER PLUS NR { check_declarations($1);}
     | NR PLUS IDENTIFIER { check_declarations($3);}
     ;

minus : IDENTIFIER MINUS IDENTIFIER { check_declarations($1); check_declarations($3); }
      | IDENTIFIER MINUS NR { check_declarations($1);}
      | NR MINUS IDENTIFIER { check_declarations($3);}
      ;

div  : IDENTIFIER DIV IDENTIFIER { check_declarations($1); check_declarations($3); }
     | IDENTIFIER DIV NR { check_declarations($1);}
     | NR DIV IDENTIFIER { check_declarations($3);}
     ;

mul  : IDENTIFIER MUL IDENTIFIER { check_declarations($1); check_declarations($3); }
     | IDENTIFIER MUL NR { check_declarations($1);}
     | NR MUL IDENTIFIER { check_declarations($3);}
     ;



conditii  : conditii Op conditie
          | conditie
          ;

Op : AND
   | OR
   ;

conditie  : TRUE
          | FALSE
          | NR bool NR
          | IDENTIFIER bool NR
          | NR bool IDENTIFIER
          | IDENTIFIER bool IDENTIFIER
          ;

bool    : DEQ
        | GEQ
        | LEQ
        | DIF
        | LE
        | GE
        ;

section_predefData:
     PREDEF BEG END
     | PREDEF BEG lista_PredefData END
     ;

lista_PredefData:
     declararePredef 
     | lista_PredefData declararePredef 
     ;

declararePredef:
    DEFINE IDENTIFIER STRINGVAL {insert("DEFINE",$2,-1);}
    | DEFINE IDENTIFIER CHARVAL {insert("DEFINE",$2,-1);}
    | DEFINE IDENTIFIER NR {insert("DEFINE",$2,$3);}
    | DEFINE IDENTIFIER FALSE {insert("DEFINE",$2,0);}
    | DEFINE IDENTIFIER TRUE {insert("DEFINE",$2,1);}
    ;

section_main:
     MAIN body
     ;

%%

int yyerror(char * s){
printf("Eroare: %s pe linia:%d si yytext este %s\n",s,yylineno,yytext);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     yyparse();
}
