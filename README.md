# Using `yacc` and `lex` for a text adventure
## Or... "How I learned to love parsers"



## Introduction

I found no real info on how to create a text parser, specifically for a text-based adventure game, using `lex` and `yacc`, out there. I found this surprising as many posts to many threads on the subject of text parsing for 'interactive fiction' make mention of using `yacc` and `lex` as the way to go.

After following the excellent [How to program a text adventure in C](https://helderman.github.io/htpataic/htpataic01.html), in Chapter [13. The parser](https://helderman.github.io/htpataic/htpataic13.html), the author also mentions `yacc` as the way to go.

So, I thought I'd give it a go.

After looking at a number of "guides", I settled on [Lex and YACC primer/HOWTO](https://berthub.eu/lex-yacc/cvs/lexyacc.pdf), by Bert Hubert. This really is an excellent guide, with perfect examples. I have included a copy of it in `xtras/PDF/`.

---

Note: Whatever you do, do ***not*** follow the IBM guide on `yacc`, [Write text parsers with yacc and lex](https://developer.ibm.com/tutorials/au-lexyacc/). The author is clearly a dyslexic drunkard. Many of the symbols and punctuation marks are missing, and/or incorrect, and whilst not impossible, it makes it rather difficult to follow.

For example, the `-` and the `*` are the incorrect character code. 

That whole page really is a joke. Quite unbelievable

---

The [Lex and YACC primer/HOWTO](https://berthub.eu/lex-yacc/cvs/lexyacc.pdf) ([HTML format](https://tldp.org/HOWTO/Lex-YACC-HOWTO.html)) provides a heating controller example. It is from that same example that I developed these grammar rules.

The objective was to re-create (at least, to some extent) the scene from the game "The Hobbit" that I used to play on a Speccy, years and years ago:

[![The goblin dungeon][1]][1]


## What this isn't

### A tutorial

This never started out as, and isn't meant to be, a tutorial. I just keep on improving the `yacc`/`lex` files and making "save points", along the way, of the working code. It then dawned on me that the code increments were similar to [How to program a text adventure in C](https://helderman.github.io/htpataic/htpataic01.html), and so I thought that I would post these increments to a repo, so that they might serve as a useful example to someone.

I will leave it to you, dear Reader, to check the `diff` between the various versions in order to see what changed. See? I told you it wasn't a tutorial. Lazy...

### A game

There is no gameplay:

 - You can kill Thorin as many times as you want. 
 - You can take as many gold coins as you wish. 
 -  You can continually pick up the key, and yet it will still be there on the floor, and not in your possession. 

There are no limits... therefore no game.

## Possible issues

N.B. I may not have got some things correct, or I might be doing some other things in an "unapproved" manner - however, the code *appears* to work. If you see any blunders or bad practices, then please raise an issue.

## The code increments

1. Accept "give key to thorin" 
2. Accept "give 10 gold pieces to thorin" 
3. Accept "give 10 gold pieces to Thorin" 
4. Accept "give 10 gold pieces to Thorin and then give key to Gandalf" 
5. Accept "stab Thorin"
6. Use left recursion to save memory
   - `commands command TOKAND TOKTHEN`
7. Added "get "or "take" (`get|take`)
8. Recognise newline, i.e. `TOKEND`
   - Fixes "stab Thorin" and "stab Thorin to death"
9. Added "help"
10. Added "look" and "kill"
11. Crash on syntax error, i.e. unknown word
    - does not work correctly
12. Added "quit"
13. Added "knife"
    - unknown removed
14. Added "to death" and "pick up"
    - with a space between
15. Restart automatically on unknown
    - Hack, re-call `yyparse()` in `yyerror()`
16. Recognise unknown verb
17. Restart automatically on unknown
    - `while(1){yyparse()};`
18. Recognise "take unknown_noun"
    - `extern YYSTYPE yylval;` added to `lex.l`
19. Recognise "give unknown_noun"
20. Added "give Gandalf key"
    - `TOKGIVE CHAR_NAME TOKITEM`
21. Added "give Gandalf the key" 
    - `TOKGIVE CHAR_NAME TOKTHE TOKITEM`
22. Added "give Gandalf 10"
    - `TOKGIVE CHAR_NAME NUMBER`
23. Added "gold coins" for "take"
24. Added "gold coins" for "give"
25. Added auto-test in Makefile. 
    - Also, fixed "to death" for "stab"
26. Added "pick <item> up"
    - Split infinitive



## The commands

There are only three:

```none
flex examplethorin.l    
yacc -d examplethorin.y
gcc -o examplethorin y.tab.c
```

However, I have also provided a `make` file, so you can just type `make`. 

Then run the executable, with `./examplethorin`.

N.B. Typing `make clean` will tidy up the directory and remove any generated files, including the binary.

## Getting started

Once the executable has launched, type `help`:

```none
% ./examplethorin 
help
	Verbs:
		get | take
		give
		stab
		look
		kill
	Nouns:
		key
		gold
		knife
	Numbers:
		0 - 9
	Actors:
		Thorin
	Proper names:
		Word beginning with a capital letter
		i.e. Gandalf, Gimli
	Misc (prepositions, conjunctions, coordinates, articles):
		to
		and
		then
		the
	Meta Commands:
		help
		quit

```

Here is a screenshot of some interactions:

[![Screenshot of interaction][2]][2]

### Known issues

Some of the features are rather rough. For example:

 - "give Gandalf 10"
   - 10 what? You currently don't, or can't, specify gold pieces, silver pieces or what-have-you.
   - As of v.23/v.24, you can now enter "give Gandalf 10 gold coins"
 - 'pick gold up"
   - You can not split the infinitive, yet.
   - As of v.26, you can now enter "pick 10 gold coins up", "pick key up"
 - "give key to Gandlaf"
   - Proper names, other than Thorin's, are not checked against any list of valid names, nor valid spelling. 
   - Gandalf isn't even here, even if you spell the name correctly.
 - Lack of prepositions
   - You can't stab Thorin *in* the eye, nor put the key *under* the knife, yet.
 - Inconsistant, or apparent duplicate, syntax error messages

However, this is just to get you started. You can polish it off, in your own styling, dear Reader.

## Gotchas

Using `yacc` and `lex` may seem daunting, but once it is set up, it really is rather intuitive and easy. However, it is the "setting up" that is a horrific nightmare, for the novice.

The following points I, personally, found to be "sticking points" that caused some confusion:

1. Put `#include "lex.yy.c"` at the bottom of the `yacc` grammar file, `examplethorin.y`, after the last pair of `%%`


## More notes

The very rough notes that I took whilst developing the grammar can be found here: [Yacc_Lex_Notes](xtras/MD/Yacc_Lex_Notes.md)

  [1]: xtras/images/spectrum-hobbit-goblin-dungeon.png "The goblin dungeon"
  [2]: xtras/images/examplethorin.png "Screenshot of interaction"
