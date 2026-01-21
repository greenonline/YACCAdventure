YACC          = yacc

LEX           = flex

YFLAGS        = -d

PROGRAM       = examplethorin

OBJS          = calcparse.tab.o lex.yy.o fmath.o const.o

SRCS          = y.tab.c lex.yy.c 

CC            = gcc 

TRANS         = transcript.txt

BASE          = baseline.txt

TEST          = testscript.txt

RM            = rm

SUCCESS       = success.txt

MAKE          = make

all:            $(PROGRAM) success.txt

$(PROGRAM):	y.tab.c
		$(CC) -o $(PROGRAM) y.tab.c


y.tab.c:        $(PROGRAM).y lex.yy.c
		$(YACC) $(YFLAGS) $(PROGRAM).y

lex.yy.c:       $(PROGRAM).l 
		$(LEX) $(PROGRAM).l

$(SUCCESS):	$(PROGRAM) $(TEST) $(BASE)
		cat $(TEST) | ./$(PROGRAM) > $(TRANS)
		cmp $(BASE) $(TRANS)
		mv -f $(TRANS) $(SUCCESS)


clean:         
		$(RM) ‑f $(PROGRAM) y.* lex.yy.* $(SUCCESS)

rebuild:
		$(MAKE) clean
		$(MAKE) all
