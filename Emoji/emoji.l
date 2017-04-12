LOWER   [a-z]
CHAR   [a-zA-Z_0-9]
ANGRY >=\\|>=\[|>=\(|>=\/
CONFUSED :\\|:\/|=\\|=\/

%{
#include <stdio.h>
#include "y.tab.h"
#include <stdlib.h>
char * getStringForEmoji(const char *emoji);
%}

%%

":(" { return(OPEN_PAR); }
":)" { return(CLOSE_PAR); }
":}" { return(CLOSE_CURL); }
":{" { return(OPEN_CURL); }
";)" { return(SEMI_COLON); }
"=_=" { return(VOID); }
{CONFUSED} { yylval.string = getStringForEmoji(strdup(yytext)); return(VAR); }
{ANGRY} { yylval.string = getStringForEmoji(strdup(yytext)); return(FUNC); }
[ \t\r\n] ; /* Used to remove additional whitespace which gets dumped into output */

%%
char * getStringForEmoji(const char *emoji){
	if(strcmp(emoji, ":/") == 0) //Confused emojis (translate to variable names)
	{
		return("a");
	}
	else if (strcmp(emoji, ":\\") == 0)
	{
		return("b");
	}
	else if (strcmp(emoji, "=/") == 0)
	{
		return("c");
	}
	else if (strcmp(emoji, "=\\") == 0)
	{
		return("d");
	}
	else if (strcmp(emoji, ">=(") == 0) //Angry emojis (translate into function names)
	{
		return("main");
	}
	else if (strcmp(emoji, ">=\\") == 0)
	{
		return("funcA");
	}
	else if (strcmp(emoji, ">=/") == 0)
	{
		return("funcB");
	}
	else if (strcmp(emoji, ">=[") == 0)
	{
		return("funcC");
	}
}

int yywrap(void)        /* called at end of input */
{
    return 1;           /* terminate now */
}
