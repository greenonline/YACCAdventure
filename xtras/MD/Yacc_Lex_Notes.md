# `yacc` and `lex` notes

## Links

 - [13. The parser](https://helderman.github.io/htpataic/htpataic13.html)
 - [Elegant command-parsing in an OOP-based text game](https://stackoverflow.com/q/2207168/4424636) - not much yacc stuff
 - [Write text parsers with yacc and lex](https://developer.ibm.com/tutorials/au-lexyacc/) 
   - looks good but full of outrageous typos
 - [How can I program a parser for a text adventure like Zork?](https://www.quora.com/How-can-I-program-a-parser-for-a-text-adventure-like-Zork)

## Quote

From [How can I program a parser for a text adventure like Zork?](https://www.quora.com/How-can-I-program-a-parser-for-a-text-adventure-like-Zork)

> There isn’t much point building a parser using Yacc for this, because a text adventure like Zork doesn’t use semantic tokens that follow patterns that can be captured easily in regular expressions, or BNF, aside from saying something like “alphabetic terms are words,” and “numbers are quantities.”
> 
> By and large, Zork used fairly simple terms, but allowed you to string them together in pretty natural ways that felt like sentences. Verb terms could be more than one word, such as “pick up”. You could use “and”, and “then” as conjunctions to string actions together, so that you didn’t have to only do single actions per line. Simple text adventures only allowed one action per line, something I didn’t like very much. You could use articles, like “the”, or “a” to refer to items in your character’s possession. If you said something that was outside its vocabulary, Zork would say, “I don’t know how to X,” or, “There is no X here,” where X was the term outside its vocabulary.
> 
> It still distinguished between verbs and nouns, but it was based on position. The first term in a “verb-noun” pair would be considered a verb, and the second term, a noun. An article (“the” or “a”) was allowed inside a noun term, “and” was allowed between noun terms, and “and” and “then” were allowed between “verb-noun” pairs.
> 
> As I remember, Zork also allowed punctuation, such as commas and periods, but I don’t think it allowed them to signal anything. It just ignored them. There might have been some terms that it allowed, but ignored, such as “also”.
> 
> The main thing you’d need is a tokenizing routine that separates words via. whitespace (spaces, tabs). You can parse the input stream in a loop that tests each term as it comes in, looking for recognized verbs, articles, conjunctions, and any nouns that happen to be in a “room,” or in the character’s possession, and take commensurate actions.
> 
> In terms of a third party, or open source input library you would want to use, I am not familiar with any of them, other than the standard input routines that would come with the language, such as the standard library in C, C++, C#, Java, or Lisp. In C or C++, you’d likely want to use read(), or one of its variants. In C# or Java, you’d likely want to use something like <some-prefix>.readline(). In Lisp, you’d want to use the read function, or some variant.

## Examples - initial steps

From [Write text parsers with yacc and lex](https://developer.ibm.com/tutorials/au-lexyacc/) , terrible tutorial, lots of errors

```none
%{
#include <stdio.h>
%}

%% 
begin  printf("Started\n");
hello  printf("Hello yourself!\n");
thanks printf("You are welcome\n");
end    printf("Stopped\n");
%%
```

Commands:

```none
flex exampleA.l
gcc -o exampleA -ll lex.yy.c
```

With yacc, all hell breaks lose

```none
%{
#include <stdio.h>
#include "y.tab.h"
%}


%%
begin  return BEGIN;
hello  return HELLO;
thanks return THANKS;
end    return END;
%%
```

and the yacc file

```none
%{
#include <alloca.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include <ctype.h>


%}

%{
int yylex();
%}

%{
int yyerror();
%}


%token BEGIN HELLO THANKS END

%%
words: BEGIN 
         { 
             printf("Already started\n");
         }
         | HELLO 
         { 
             printf("Hello yourself!\n");
         }
         | THANKS 
         { 
             printf("You are welcome\n");
         }
         | END 
         { 
             printf("Stopped\n");
         }
         ;

%%

int yylex(YYSTYPE *, void *);

int yyerror (char *s)
{
  fprintf (stderr, "%s\n", s);
  return 1;
}  

//#include "lex.yy.c"

```

Commands:

```none
flex exampleC.l 
yacc -d exampleC.y
gcc -o exampleC -ll lex.yy.c

```

Useful links:

 - [Bison Syntax Error (Beginner)](https://stackoverflow.com/q/1550902/4424636)
 - [expected identifier or '(' before '{' token in Flex](https://stackoverflow.com/q/13413966/4424636)
 - [Simple yacc grammars give an error](https://stackoverflow.com/q/20106574/4424636)
 - ["Undefined symbols for architecture x86_64:" when compiling lex and yacc](https://stackoverflow.com/q/15212053/4424636)

It is not easy to get a simple example running!

1. Should we be compiling `y.tab.c` or `lex.yy.c` or both or including lex.yy.c in the `.y` file? i.e.  

        gcc -o exampleC -ll y.tab.c lex.yy.c

2. I got one error and one warning if both compiles
1 got no error and two warnings, if `lex.yy.c` is included and compile only `y.tab.c`, i.e.

        gcc -o exampleC -ll y.tab.c 

3. Should `yylex()` and `yyerror()` be included? Both declaraion and definitions? yylex only declare, `yyerror()` both declaration and definition.

The problem seems to be that the code examples on the IBM tutorial page are missing symbols, or the symbols are incorrect. It would be best to ignore that particular tutorial.

## More links

 - https://cse.iitkgp.ac.in/~bivasm/notes/LexAndYaccTutorial.pdf
 - https://www2.cs.arizona.edu/~debray/Teaching/CSc453/DOCS/tutorial-large.pdf
 - [Lex and YACC primer/HOWTO](https://berthub.eu/lex-yacc/cvs/lexyacc.pdf) 
   - page 7, similar to IBM example, but much better
   - returning tokens
 - [Adding Languages to Game Engines](https://www.gamedeveloper.com/programming/adding-languages-to-game-engines)
   - Interesting, but the links to `yacc` and `lex` specs for a game are dead.
 - [Debugging](https://www.cs.man.ac.uk/~pjj/cs2121/debug.html)


## Working examples

### Working example#1

From [Lex and YACC primer/HOWTO](https://berthub.eu/lex-yacc/cvs/lexyacc.pdf)

LEX file: `example4.l`

```none
%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
[0-9]+             return NUMBER;
heat               return TOKHEAT;
on|off             return STATE;
target             return TOKTARGET;
temperature        return TOKTEMPERATURE;
\n                 /* ignore end of line */;
[ \t]+             /* ignore whitespace */;
%%
```

Run: `flex example4.l`

YACC file: `example4.y`

```none
%{

#include <stdio.h>
#include <string.h>

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

%token NUMBER TOKHEAT STATE TOKTARGET TOKTEMPERATURE

%%

commands: /* empty */
| commands command
;

command:
heat_switch
|
target_set
;

heat_switch:
TOKHEAT STATE
{
  printf("\tHeat turned on or off\n");
}
;

target_set:
TOKTARGET TOKTEMPERATURE NUMBER
{
  printf("\tTemperature set\n");
}
;

%%


#include "lex.yy.c"
```

Run: `yacc -d example4.y`

Run: `gcc -o example4 y.tab.c`

This actually works!

Note that `-ll` is not req	uired if we specify a `main()`


### Working example#2

Again specifying main (need to do without `main()` and with `-ll`)

LEX file: `exampleCtest.l`

```none
%{
#include <stdio.h>
#include "y.tab.h"
%}


%%
begin  return BEGAN;
hello  return HELLO;
thanks return THANKS;
end    return END;
%%
```

Run: `flex exampleCtest.l`

YACC file: `exampleCtest.y`

```none
%{
#include <alloca.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include <ctype.h>

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

%token BEGAN HELLO THANKS END

%%

commands: /* empty */
| commands command
;

command:
word1
|
word2
|
word3
|
word4
;


word1: BEGAN 
         { 
             printf("Already started\n");
         };


word2: HELLO 
         { 
             printf("Hello yourself!\n");
         };

word3: THANKS 
         { 
             printf("You are welcome\n");
         };

word4: END 
         { 
             printf("Stopped\n");
         }
         ;

%%


#include "lex.yy.c"
```

Run: `yacc -d exampleCtest.y`

Run: `gcc -o exampleCtest y.tab.c`



## Gotchas!

 - Do not use BEGIN as a token!
 - Note that `-ll` is not required if we specify a `main()`

## Thorin example

 - I have a "give key to thorin" yacc example..! ExampleThorin1
 - I have a "give 10 gold pieces to thorin" yacc example..! ExampleThorin2
 - I have a "give 10 gold pieces to Thorin" yacc example..! ExampleThorin3
 - I have a "give 10 gold pieces to Thorin and then give key to Gandalf" yacc example..! ExampleThorin4



How to do both int and string in yacc - DONE! Use `union`

Use left recursion to save memory `commands command TOKAND TOKTHEN` ExampleThorin6


How to do partial matches and what is the precedence? i.e. "talk Thorin" and "talk Thorin to death" ExampleThorin5, DONE in ExampleThorin8, use the \n

[Writing lex Source](https://docs.oracle.com/cd/E19504-01/802-5880/6i9k05dgk/index.html) - meh

`get|take` ExampleThorin7

newline TOKEND ExampleThorin8

How to do "pick up" with the space? And "to death" with the space?
 - {B} [Writing lex Source](https://docs.oracle.com/cd/E19504-01/802-5880/6i9k05dgk/index.html)
Why crash on syntax error? - DONE! ExampleThorin11

 - help and stab ExampleThorin9
 - look and kill ExampleThorin10
 - unknown ExampleThorin11 - does not work correctly
 - quit ExampleThorin12
 - knife ExampleThorin13 - unknown removed
 - to death and pick up ExampleThorin14

Unknown: [Ignoring errors in yacc/lex ](https://stackoverflow.com/q/4063455/4424636)

 - meh, does not seem to work
 - Hack, re-call `yyparse()` in `yyerror()` ExampleThorin15
   - Seems a bit recursive, could end up overflow

Recognise unknown verb ExampleThorin16

How to restart automatically?

 - Not yywrap(), not work.
 - while(1){}?
   - Is this a hack? At least no overflow  ExampleThorin17

How to recognise unknown noun? 

 - Can we do * for any token, i.e. `* TOKUNKNOWN`? - Nope! * not allowed
 - Can we do ANY for any token, i.e. `ANY TOKUNKNOWN`? - Nope! random tok not matched???
   - or can we do OR, i.e. `TOKVERB1 | TOKVERB2 TOKUNKNOWN`
 - Do we have to do for every verb? - DONE! Probably
   - Take ExampleThorin18 (also has `extern YYSTYPE yylval;` added to lex.l)
   - Give ExampleThorin19
 - Can we group verbs?
 - Don't want two error messages - DONE! by matching known first word
   - Do we have to have a counter?

It's always:

```none
 "verb noun"
or
 "verb noun to noun"
```

 - so check for noun unknown, must do it. - DONE ExampleThorin19

Different outputs for verb and noun:

 - Do for verb: "I don't know how to do \"%s\"...\n"
 - Do for noun: "I don't know what a \"%s\" is...\n", i.e. "take john"
   - DONE! ExampleThorin18/19

Generate yacc and lex from JSON?

 - This seems easier, use Awk or Perl.


How to check for "give gandalf [the] key"?

 - TOKGIVE CHAR_NAME TOKITEM - DONE! ExampleThorin20
 - TOKGIVE CHAR_NAME TOKTHE TOKITEM - DONE! ExampleThorin21
 - Added "the" - ExampleThorin21

Give gandalf 10 ExampleThorin22

Makefile - DONE!

## TODO

 - Split the infinitive, pick 10 up, pick key up.
 - Stab Thorin in the eye
 - Put knife in Thorin's eye
 - Testscript?

Also:

 - Give Gandalf 10 coins 
 - Give Gandalf 10 gold coins


