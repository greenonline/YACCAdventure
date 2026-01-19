%{
#include <stdio.h>

#include "y.tab.h"


%}


%%
[0-9]+             yylval.number=atoi(yytext); return NUMBER;
help               return TOKHELP;
look               return TOKLOOK;
stab               return TOKSTAB;
kill               return TOKKILL;
give               return TOKGIVE;
get|take           return TOKTAKE;
gold|key           yylval.string=strdup(yytext);  return TOKITEM;
 /* gold           return TOKGOLD;
key                return TOKKEY; */
Thorin             return TOKTHORIN;
 /* to death       return TOKTO_DEATH; */
death              return TOKDEATH;
to                 return TOKTO;
and                return TOKAND;
then               return TOKTHEN;
[A-Z][a-z]+        yylval.string=strdup(yytext); return CHAR_NAME;

\n                 return TOKEND/* ignore end of line */;
[ \t]+             /* ignore whitespace */;
%%