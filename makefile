all:
	lex proiect.l
	yacc -d -Wcounterexamples proiect.y
	gcc lex.yy.c y.tab.c -o exec
