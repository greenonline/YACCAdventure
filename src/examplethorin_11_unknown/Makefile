YACC          = yacc

LEX           = flex

YFLAGS        = -d

PROGRAM       = examplethorin

OBJS          = calcparse.tab.o lex.yy.o fmath.o const.o

SRCS          = y.tab.c lex.yy.c 

CC            = gcc 

all:            $(PROGRAM)

$(PROGRAM):	y.tab.c
		$(CC) -o $(PROGRAM) y.tab.c


y.tab.c:        $(PROGRAM).y lex.yy.c
		$(YACC) $(YFLAGS) $(PROGRAM).y

lex.yy.c:       $(PROGRAM).l 
		$(LEX) $(PROGRAM).l

clean:;         rm ‑f  $(PROGRAM) y.* lex.yy.* 
