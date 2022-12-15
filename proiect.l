%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
%}

alpha [a-zA-Z]
digit [0-9]

%%
"int" return INT;
"float" return FLOAT;
"char" return CHAR;
"string" return STRING;
"bool" return BOOL;

"-" return MINUS;
"+" return ADDITION;
"*" return MULTIPLICATION;
"/" return DIVISION;
">=" return GREATEROREQUAL;
"<=" return LESSOREQUAL;
"==" return EQUAL;
"=" return ASSIGN;
"&&" return AND;
"||" return OR;
"^" return XOR;

"if" return IF;
"else" return ELSE;
"for" return FOR;
"while" return WHILE;
"switch" return SWITCH;
"case" return CASE;
"break" return BREAK;

{alpha}({alpha}|{digit})* return IDENTIFIER;
{digit}+  return NUM;
";" return SEMICOLON;
"," return COMMA;
"(" return OP;
")" return CP;
"{" return OB;
"}" return CB;
. ;
[ \n] ;
%%
