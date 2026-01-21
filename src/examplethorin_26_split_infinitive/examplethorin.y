%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 /* #define YYSTYPE char * */

int yylex(void);
int yyparse(void);

void yyerror(const char *str)
{
  if (!strcmp(str,"syntax error")){
    printf("I don\'t know how to do that\n");
  } else {
    fprintf(stderr,"error: %s\n",str);
  }
}

int yywrap()
{
  return 1;
}

int main()
{
  while(1){
  yyparse();};
}

%}

%token TOKGIVE TOKTAKE TOKLOOK TOKKILL TOKSTAB TOKGOLD TOKAND TOKTHEN TOKTHE TOKEND TOKKEY TOKTHORIN TOKTO TOKHELP TOKQUIT ANY
%token TOKDEATH TOKTODEATH TOKCOIN TOKGOLDCOIN TOKSILVERCOIN TOKCOPPERCOIN TOKPICK TOKUP

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
take_number
|
take_number_coins
|
take_number_goldcoins
|
take_unknown
|
pick_item_up
|
pick_number_up
|
pick_number_coins_up
|
pick_number_goldcoins_up
|
pick_unknown_up
|
give_item_to_char
|
give_unknown_to_char
|
give_item_to_unknown
|
give_unknown_to_unknown
|
give_char_item
|
give_char_unknown
|
give_unknown_item
|
give_unknown_unknown
|
give_char_the_item
|
give_char_the_unknown
|
give_unknown_the_item
|
give_unknown_the_unknown
|
give_key_to_thorin
|
give_item_to_thorin
|
give_gold_to_thorin
|
give_gold_to_char
|
give_number_to_char
|
give_coins_to_char
|
give_goldcoins_to_char
|
give_char_number
|
give_char_coins
|
give_char_goldcoins
|
stab_thorin
|
kill_thorin
|
stab_thorin_to_death
|
unknown_verb
|
unknown_noun
;


help:
TOKHELP
{
  printf("\tVerbs:\n");
  printf("\t\tget | take | pick up\n");
  printf("\t\tgive\n");
  printf("\t\tstab\n");
  printf("\t\tlook\n");
  printf("\t\tkill\n");
  printf("\tNouns:\n");
  printf("\t\tkey\n");
  printf("\t\tgold\n");
  printf("\t\tknife\n");
  printf("\t\tgold | silver | copper coin[s]\n");
  printf("\tNumbers:\n");
  printf("\t\t0 - 9\n");
  printf("\tActors:\n");
  printf("\t\tThorin\n");
  printf("\tProper names:\n");
  printf("\t\tWord beginning with a capital letter\n");
  printf("\t\ti.e. Gandalf, Gimli\n");
  printf("\tMisc (prepositions, conjunctions, coordinates, articles):\n");
  printf("\t\tto\n");
  printf("\t\tand\n");
  printf("\t\tthen\n");
  printf("\t\tthe\n");
  printf("\tAdjectives:\n");
  printf("\t\tgold\n");
  printf("\t\tsilver\n");
  printf("\t\tcopper\n");
  printf("\tAdverbs:\n");
  printf("\t\tto death\n");
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
  printf("\t\tA lump of gold\n");
  printf("\t\tA knife\n");
}
;

take_item:
TOKTAKE TOKITEM
{
  printf("\tYou take the %s\n", $2);
}
;

take_number:
TOKTAKE NUMBER
{
  printf("\tYou take %d gold coins\n", $2);
}
;

take_number_coins:
TOKTAKE NUMBER TOKCOIN
{
  printf("\tYou take %d gold coins\n", $2);
}
;

take_number_goldcoins:
TOKTAKE NUMBER TOKGOLDCOIN
{
  printf("\tYou take %d gold coins\n", $2);
}
;

take_unknown:
TOKTAKE TOKUNKNOWN
{
  printf("\tYou can't take a \"%s\".\n", $2);
  printf("\tI don't know what a \"%s\" ia.\n", $2);
}
;

pick_item_up:
TOKPICK TOKITEM TOKUP
{
  printf("\tYou take the %s\n", $2);
}
;

pick_number_up:
TOKPICK NUMBER TOKUP
{
  printf("\tYou take %d gold coins\n", $2);
}
;

pick_number_coins_up:
TOKPICK NUMBER TOKCOIN TOKUP
{
  printf("\tYou take %d gold coins\n", $2);
}
;

pick_number_goldcoins_up:
TOKPICK NUMBER TOKGOLDCOIN TOKUP
{
  printf("\tYou take %d gold coins\n", $2);
}
;

pick_unknown_up:
TOKPICK TOKUNKNOWN TOKUP
{
  printf("\tYou can't take a \"%s\".\n", $2);
  printf("\tI don't know what a \"%s\" ia.\n", $2);
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

give_number_to_char:
TOKGIVE NUMBER TOKTO CHAR_NAME
{
  printf("\tYou give %d gold pieces to %s\n", $2,$4);
}
;

give_coins_to_char:
TOKGIVE NUMBER TOKCOIN TOKTO CHAR_NAME
{
  printf("\tYou give %d gold pieces to %s\n", $2,$5);
}
;

give_goldcoins_to_char:
TOKGIVE NUMBER TOKGOLDCOIN TOKTO CHAR_NAME
{
  printf("\tYou give %d gold pieces to %s\n", $2,$5);
}
;

give_char_number:
TOKGIVE CHAR_NAME NUMBER
{
  printf("\tYou give %d gold pieces to %s\n", $3,$2);
}
;

give_char_coins:
TOKGIVE CHAR_NAME NUMBER TOKCOIN
{
  printf("\tYou give %d gold pieces to %s\n", $3,$2);
}
;

give_char_goldcoins:
TOKGIVE CHAR_NAME NUMBER TOKGOLDCOIN
{
  printf("\tYou give %d gold pieces to %s\n", $3,$2);
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

give_item_to_unknown:
TOKGIVE TOKITEM TOKTO TOKUNKNOWN
{
  printf("\tYou can't give the %s to \"%s\"\n", $2,$4);
  printf("\tI don't what a \"%s\" is...\n",$4);
}
;

give_unknown_to_char:
TOKGIVE TOKUNKNOWN TOKTO CHAR_NAME
{
  printf("\tYou can't give the \"%s\" to %s\n", $2,$4);
  printf("\tI don't what a \"%s\" is...\n",$2);
}
;

give_unknown_to_unknown:
TOKGIVE TOKUNKNOWN TOKTO TOKUNKNOWN
{
  printf("\tYou can't give the \"%s\" to \"%s\"\n", $2,$4);
  printf("\tI don't what a \"%s\" is...\n",$2);
  printf("\tI don't what a \"%s\" is...\n",$4);
}
;

give_char_item:
TOKGIVE CHAR_NAME TOKITEM
{
  printf("\tYou give the %s to %s\n", $3,$2);
}
;

give_char_unknown:
TOKGIVE CHAR_NAME TOKUNKNOWN
{
  printf("\tYou can't give the \"%s\" to %s\n", $3,$2);
  printf("\tI don't what a \"%s\" is...\n",$3);
}
;

give_unknown_item:
TOKGIVE TOKUNKNOWN TOKITEM
{
  printf("\tYou can't give the %s to \"%s\"\n", $3,$2);
  printf("\tI don't what a \"%s\" is...\n",$2);
}
;

give_unknown_unknown:
TOKGIVE TOKUNKNOWN TOKUNKNOWN
{
  printf("\tYou can't give the \"%s\" to \"%s\"\n", $3,$2);
  printf("\tI don't what a \"%s\" is...\n",$2);
  printf("\tI don't what a \"%s\" is...\n",$3);
}
;

give_char_the_item:
TOKGIVE CHAR_NAME TOKTHE TOKITEM
{
  printf("\tYou give the %s to %s\n", $4,$2);
}
;

give_char_the_unknown:
TOKGIVE CHAR_NAME TOKTHE TOKUNKNOWN
{
  printf("\tYou can't give the \"%s\" to %s\n", $4,$2);
  printf("\tI don't what a \"%s\" is...\n",$4);
}
;

give_unknown_the_item:
TOKGIVE TOKUNKNOWN TOKTHE TOKITEM
{
  printf("\tYou can't give the %s to \"%s\"\n", $4,$2);
  printf("\tI don't what a \"%s\" is...\n",$2);
}
;

give_unknown_the_unknown:
TOKGIVE TOKUNKNOWN TOKTHE TOKUNKNOWN
{
  printf("\tYou can't give the \"%s\" to \"%s\"\n", $4,$2);
  printf("\tI don't what a \"%s\" is...\n",$2);
  printf("\tI don't what a \"%s\" is...\n",$4);
}
;

stab_thorin:
TOKSTAB TOKTHORIN
{
  printf("\tYou stabbed Thorin...\n");
}
;

stab_thorin_to_death:
/*TOKSTAB TOKTHORIN TOKTO TOKDEATH*/
TOKSTAB TOKTHORIN TOKTODEATH
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

unknown_verb:
TOKUNKNOWN
{
  printf("\tWhat does \"%s\" mean?\n", $1);
  printf("\tI don't know how to \"%s\"...\n",$1);
}
;

unknown_noun:
ANY TOKUNKNOWN
{
  printf("\tWhat does \"%s\" mean?\n", $2);
  printf("\tI don't what a \"%s\" is...\n",$2);
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

