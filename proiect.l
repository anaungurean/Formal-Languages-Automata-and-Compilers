%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"



%}

%%
"int"|"float"|"char"|"string"|"bool" {yylval.strval = strdup(yytext); return VAR_TYPE;}
"list"|"array" {return LIST;}
"class" {yylval.strval = strdup(yytext); return CLASS;}

[a-zA-Z_][a-zA-Z0-9_]* {yylval.strval = strdup(yytext); return IDENTIFIER;}
"const" {return CONST;}

"if" {yylval.string = strdup(yytext); return IF;}
"else" {yylval.string = strdup(yytext); return ELSE;}
"for" {yylval.string = strdup(yytext); return FOR;};
"while" {yylval.string = strdup(yytext); return WHILE;};



"print" {return PRINT;}
"println" {return PRINTLN;}

"{" {return BLOCK_BEGIN;}
"}" {return BLOCK_END;}
"(" {return TUPLE_BEGIN;}
")" {return TUPLE_END;}
"[" {return ARR_BEGIN;}
"]" {return ARR_END;}
";" {return INSTR_END;}
"," {return COMMA_SEP;}
"." {return STRUCT_ACCESS;}
":=" {yylval.character = yytext[0]; return ASSIGN;}

":+" {return ADD;}
":-" {return SUB;}
":*" {return MUL;}
":/" {return DIV;}
":%" {return MOD;}
":=="|":<"|":>"|":<="|":>=" {yylval.string = strdup(yytext); return LOGICAL_OPERATOR;}
"or" {yylval.string = strdup(yytext); return OR;}
"and" {yylval.string = strdup(yytext); return AND;}
"not" {yylval.string = strdup(yytext); return NOT;}


0|[1-9][0-9]* {yylval.intval = (double)atoi(yytext); return INTEGER;}
(0|[1-9][0-9]*)"."([0-9]*) {yylval.floatval = atof(yytext); return FLOAT;}
\'[0-9a-zA-Z_=+\[\]{};':",./<>?-]\' {yylval.character = yytext[1]; return CHAR;}
\"[0-9a-zA-Z_=+\[\]{};':",./<>?-]*\" {yylval.string = strdup(yytext); return STRING;}
 "true"|"false" {if(strcmp(yytext, "true") == 0) yylval.intval = 1; else yylval.intval = 0; return BOOL;}


[\s\t\r] {}
\n {}
. {}

%%
