%{
#include <stdio.h>

#include "y.tab.h"


%}


%%
[0-9]+             yylval.number=atoi(yytext); return NUMBER;
stab               return TOKSTAB;
give               return TOKGIVE;
gold|key            yylval.string=strdup(yytext);  return TOKITEM;
 /* gold               return TOKGOLD;
key                return TOKKEY; */
Thorin             return TOKTHORIN;
 /* to death               return TOKTO_DEATH; */
death               return TOKDEATH;
to                 return TOKTO;
and                 return TOKAND;
then                 return TOKTHEN;
[A-Z][a-z]+             yylval.string=strdup(yytext); return CHAR_NAME;

\n                 /* ignore end of line */;
[ \t]+             /* ignore whitespace */;
%%