%{
#include <stdio.h>

#include "y.tab.h"

extern YYSTYPE yylval;

%}

D		             		[0-9]
L		             		[a-zA-Z]
B		             		[ \t]+

%%
[0-9]+                yylval.number=atoi(yytext); return NUMBER;
help                  return TOKHELP;
look                  return TOKLOOK;
quit|exit             return TOKQUIT;
stab                  return TOKSTAB;
kill                  return TOKKILL;
give                  return TOKGIVE;
get|take|pick{B}up    return TOKTAKE;

gp|gc|gold{B}+coin[s]?|gold{B}+piece[s]?               return TOKGOLDCOIN;
sp|sc|silver{B}+coin[s]?|silver{B}+piece[s]?           return TOKSILVERCOIN;
cp|cc|copper{B}+coin[s]?|copper{B}+piece[s]?           return TOKCOPPERCOIN;
coin[s]?                                               return TOKCOIN;

gold|key|knife        yylval.string=strdup(yytext);  return TOKITEM;
 /* gold              return TOKGOLD;
key                   return TOKKEY; */
Thorin                return TOKTHORIN;
to{B}death            return TOKTODEATH; 
death                 return TOKDEATH;
to                    return TOKTO;
and                   return TOKAND;
then                  return TOKTHEN;
the                   return TOKTHE;
[A-Z][a-z]+           yylval.string=strdup(yytext); return CHAR_NAME;

\n                    return TOKEND/* ignore end of line */;
[ \t]+                /* ignore whitespace */;
 /* .                 yylval.string=strdup(yytext); return TOKUNKNOWN;  */
{L}+                  yylval.string=strdup(yytext); return TOKUNKNOWN;  
 /* .                  { } */ /* ignore anything else */
 /* <*>.               { } */ /* ignore anything else */

%%