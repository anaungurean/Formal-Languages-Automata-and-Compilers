%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
%}

%token IDENTIFIER NUM
%token INT FLOAT CHAR STRING BOOL
%token GREATEROREQUAL LESSOREQUAL  EQUAL ASSIGN OR XOR AND
%token IF ELSE FOR  WHILE SWITCH CASE BREAK 
%token ADDITION MINUS MULTIPLICATION DIVISION 
%token SEMICOLON COMMA
%token OP CP OB CB

%start program

%%
program 
	: declarations function {printf("Input accepted\n");exit(0);}
	;
declarations 
	: type variables SEMICOLON
	| 
	;
type 
	: INT
	| CHAR
	| FLOAT
	| STRING
    | BOOL
	;
variables
	: IDENTIFIER
	| IDENTIFIER COMMA variables
	;
function
	: type IDENTIFIER OP argumentlist CP OB statements CB
	;
argumentlist
	: variables
	;
statements
	: expressions SEMICOLON
	;
expressions
	: IDENTIFIER ASSIGN expressions
	| IDENTIFIER
	| NUM
	;
%%

#include "lex.yy.c"
int main()
{
	yyin=fopen("input.c","r");
	yyparse();
	fclose(yyin);
	return 0;
}



