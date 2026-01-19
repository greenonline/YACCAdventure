%{

#include <stdio.h>
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

 /* %token TOKGIVE TOKGOLD TOKKEY TOKITEM TOKTHORIN TOKTO CHAR_NAME NUMBER TOKHEAT STATE TOKTARGET TOKTEMPERATURE */
%token TOKGIVE TOKGOLD TOKKEY TOKTHORIN TOKTO TOKHEAT TOKTARGET TOKTEMPERATURE

%union {
  int number;
  char *string;
}
     %token <number> STATE
     %token <number> NUMBER
     %token <string> TOKITEM
     %token <string> CHAR_NAME

%%

commands: /* empty */
| commands command
;

command:
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

%%


#include "lex.yy.c"

