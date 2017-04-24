SNAKE ~~+8\}
CATERPILLAR \(:@+D
BINARYDOTS [:.]+
SLEEPY \(-\.-\)[Zz]+

%{
#include <stdio.h>
#include "y.tab.h"
#include <stdlib.h>
#include <math.h>

char * getNumForEmoji(const char *emoji);
char * getCharForEmoji(const char *emoji);
char * getVarNameForEmoji(const char *emoji);
char * getFuncNameForEmoji(const char *emoji);

char * toArray(int num);
int countChar(const char * string, char c);
extern char * concat(const char *strings[], int length);
%}

%%
":(" { return(OPEN_PAR); }
"8)" { return(QUOTE); }
":,)" { return(COMMA); }
":)" { return(CLOSE_PAR); }
":}" { return(CLOSE_CURL); }
":{" { return(OPEN_CURL); }
";)" { return(SEMI_COLON); }
":-)" { return(VOID); }
"@:-)" { return(INT); }
"@@:-)" { return(CHAR); }
"@@@:-)" { return(CHAR_ARR); }
"~8}" { return(MAIN); }
"}:)" { return(RETURN); }
"(>'.')>" { return(PRINT); }
"<('.'<)" { return(ASSIGN); }
"C(_)" { return(WHILE); }
"o.O" { return(ELSE); }
"O.o" { return(IF); }
"(c)" { return(CONTINUE); }
":*(" { return(MULT); }
":-(" { return(MINUS); }
":+(" { return(PLUS); }
"!=:]" { return(NOT_EQ); }
">=:]" { return(GT_EQ); }
"<=:]" { return(LT_EQ); }
"<:]" { return(LT); }
">:]" { return(GT); }
"==:]" { return(EQ); }
"</3" { return(BREAK); }
{BINARYDOTS} {yylval.string = getNumForEmoji(strdup(yytext)); return(NUM); }
{SLEEPY} { yylval.string = getCharForEmoji(strdup(yytext)); return(CHARE); }
{CATERPILLAR} { yylval.string = getVarNameForEmoji(strdup(yytext)); return(VAR); }
{SNAKE} { yylval.string = getFuncNameForEmoji(strdup(yytext)); return(FUNCVAR); }
[ \t\r\n] ; /* Used to remove additional whitespace which gets dumped into output */

%%
//Count the number of occurences of char c in char * str
int countChar(const char * str, char c){
	int count = 0;
	for(int i = 0; str[i]; i++)
	{
		count += (str[i] == c);
	}
	return count;
}

//Convert number to character array
char * toArray(int num)
{
	if(num == 0) {
		return "0";	
	}
	//Get length of number
	int n = log10(num) + 1;

	//Create a string to load the number into
	char * str = malloc(n*sizeof(char));

	//Print number to new string
	sprintf(str, "%d", num);

	return str;
}

//Convert the sleeping emoji into a character based on binary value of Z's
//Z is a binary 1
//z is a binary 0
char * getCharForEmoji(const char *emoji){
	int length = strlen(emoji);
	int value = 0;

	//start at index 5 to accomodate sleeping emoji
	for(int i = 5; i< length; i++)
	{
		if(emoji[i] == 'Z')
		{
			value += 1 << (length -1 -i);
		}
	}
	char i = value;
	char *ptr = malloc(2*sizeof(char));
	ptr[0] = i;
	ptr[1] = '\0';
	return ptr;
}

//Convert the binary dot emoji into a decimal number
//: converts to 1 in binary
//. converts to 0 in binary
char * getNumForEmoji(const char *emoji)
{
	int length = strlen(emoji);
	int value = 0;

	for(int i = 0; i<length; i++)
	{
		if(emoji[i] == ':')
		{
			value += 1 << (length - 1 - i);
		}
	}
	return toArray(value);
}

//Convert the caterpillar emoji into a variable name
//Variable name is of the format a<number of @ symbols>
char * getVarNameForEmoji(const char *emoji){
	int count = countChar(emoji, '@');
	const char * array[] = {"a", toArray(count)};
	return concat(array,2);
}

char * getFuncNameForEmoji(const char *emoji){
	int count = countChar(emoji, '~');
	if(count == 1){
		return("main");
	}
	else{
		const char * array[] = {"aa", toArray(count)};
		return concat(array,2);
	}
}


int yywrap(void)        /* called at end of input */
{
    return 1;           /* terminate now */
}
