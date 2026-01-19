%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 /* #define YYSTYPE char * */

int yylex(void);
int yyparse(void);

void yyerror(const char *str)
{
  fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
  return 1;
}

int main()
{
  yyparse();
}

%}

%token TOKGIVE TOKTAKE TOKLOOK TOKKILL TOKSTAB TOKGOLD TOKAND TOKTHEN TOKEND TOKKEY TOKTHORIN TOKTO TOKHELP TOKQUIT
%token TOKDEATH

%union {
  int number;
  char *string;
}
     %token <number> NUMBER
     %token <string> TOKITEM
     %token <string> CHAR_NAME
     %token <string> TOKUNKNOWN

%%

commands: /* empty */
| commands command
| commands command TOKAND
| commands command TOKTHEN
| commands command TOKAND TOKTHEN
| commands command TOKEND
;

command:
quit
|
help
|
look
|
take_item
|
take_coins
|
give_item_to_char
|
give_key_to_thorin
|
give_item_to_thorin
|
give_gold_to_thorin
|
give_gold_to_char
|
give_coins_to_char
|
stab_thorin
|
kill_thorin
|
stab_thorin_to_death
|
unknown
;


help:
TOKHELP
{
  printf("\tVerbs:\n");
  printf("\t\tget | take\n");
  printf("\t\tgive\n");
  printf("\t\tstab\n");
  printf("\t\tlook\n");
  printf("\t\tkill\n");
  printf("\tNouns:\n");
  printf("\t\tkey\n");
  printf("\t\tgold\n");
  printf("\tNumbers:\n");
  printf("\t\t0 - 9\n");
  printf("\tActors:\n");
  printf("\t\tThorin\n");
  printf("\tProper names:\n");
  printf("\t\tWord beginning with a capital letter\n");
  printf("\t\ti.e. Gandalf, Gimli\n");
  printf("\tMisc (prepositions, conjunctions, coordinates):\n");
  printf("\t\tto\n");
  printf("\t\tand\n");
  printf("\t\tthen\n");
  printf("\tMeta Commands:\n");
  printf("\t\thelp\n");
  printf("\t\tquit\n");
}
;

look:
TOKLOOK
{
  printf("\tYou are in a small cave, with a locked door\n");
  printf("\tYou see:\n");
  printf("\t\tThorin\n");
  printf("\t\tA pile of gold coins\n");
  printf("\t\tA key\n");
  printf("\t\tA knife\n");
}
;

take_item:
TOKTAKE TOKITEM
{
  printf("\tYou take the %s\n", $2);
}
;

take_coins:
TOKTAKE NUMBER
{
  printf("\tYou take %d gold coins\n", $2);
}
;

give_key_to_thorin:
TOKGIVE TOKKEY TOKTO TOKTHORIN
{
  printf("\tYou give the key to Thorin\n");
}
;

give_gold_to_thorin:
TOKGIVE TOKGOLD TOKTO TOKTHORIN
{
  printf("\tYou give the gold to Thorin\n");
}
;

give_item_to_thorin:
TOKGIVE TOKITEM TOKTO TOKTHORIN
{
  printf("\tYou give the %s to Thorin\n",$2);
}
;

give_coins_to_char:
TOKGIVE NUMBER TOKTO CHAR_NAME
{
  printf("\tYou give %d gold pieces to %s\n", $2,$4);
}
;

give_gold_to_char:
TOKGIVE TOKGOLD TOKTO CHAR_NAME
{
  printf("\tYou give the gold to %s\n", $4);
}
;

give_item_to_char:
TOKGIVE TOKITEM TOKTO CHAR_NAME
{
  printf("\tYou give the %s to %s\n", $2,$4);
}
;

stab_thorin:
TOKSTAB TOKTHORIN
{
  printf("\tYou stabbed Thorin...\n");
}
;

stab_thorin_to_death:
TOKSTAB TOKTHORIN TOKTO TOKDEATH
{
  printf("\tYou stabbed Thorin to death!\n");
}
;

kill_thorin:
TOKKILL TOKTHORIN
{
  printf("\tYou stabbed Thorin to death!\n");
}
;

unknown:
TOKUNKNOWN
{
  printf("\tWhat does \"%s\" mean?\n", $1);
  printf("\tI don't know how to \"%s\"...\n",$1);
}
;

quit:
TOKQUIT
{
  printf("\tGoing already?\n");
  exit(0);
}
;

%%


#include "lex.yy.c"

