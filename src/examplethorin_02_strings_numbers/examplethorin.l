%{
#include <stdio.h>

#include "y.tab.h"


%}


%%
[0-9]+             yylval.number=atoi(yytext); return NUMBER;
give               return TOKGIVE;
gold|key            yylval.string=strdup(yytext);  return TOKITEM;
 /* gold               return TOKGOLD;
key                return TOKKEY; */
thorin             return TOKTHORIN;
to                 return TOKTO;
[a-z]+             yylval.string=strdup(yytext); return CHAR_NAME;

\n                 /* ignore end of line */;
[ \t]+             /* ignore whitespace */;
%%