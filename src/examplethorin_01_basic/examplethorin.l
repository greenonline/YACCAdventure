%{
#include <stdio.h>
#define YYSTYPE char *

#include "y.tab.h"


%}


%%
give               return TOKGIVE;
gold|key            yylval=strdup(yytext);  return TOKITEM;
 /* gold               return TOKGOLD;
key                return TOKKEY; */
thorin             return TOKTHORIN;
to                 return TOKTO;
[a-z]+             yylval=strdup(yytext); return CHAR_NAME;

\n                 /* ignore end of line */;
[ \t]+             /* ignore whitespace */;
%%