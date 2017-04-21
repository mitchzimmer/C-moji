%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
	  #include <ctype.h>

    int yyerror(char *);
    int yylex(void);
    int yylineno;
    extern FILE * yyin;
    extern FILE *fopen(const char *filename, const char *mode);
    char * concat(const char *strings[], int length);
%}

%union {
	char * string;
	int num;
}

%token OPEN_PAR CLOSE_PAR CLOSE_CURL OPEN_CURL
%token QUOTE SEMI_COLON COMMA
%token VOID INT CHAR CHAR_ARR
%token ASSIGN MAIN RETURN
%token PRINT
%token WHILE ELSE IF
%token CONTINUE BREAK
%token MULT MINUS PLUS
%token NOT_EQ GT_EQ LT_EQ LT GT EQ

%token <string> FUNCVAR
%token <string> VAR
%token <string> NUM
%token <string> CHARE

//%type <string> block;
//%type <string> function;
//%type <string> type;
%type <string> global_var;
%type <string> variable;
%type <string> function;
%type <string> main;
%type <string> var_type;
%type <string> value;
%type <string> func_type;
%type <string> def_args;
%type <string> def_args_extra;
%type <string> line;
%start program

%%

/*
program : function {printf("#include <stdio.h>\n#include <stdlib.h>\n%s",$1);}
function : type FUNCVAR OPEN_PAR CLOSE_PAR block {
											const char * array[] = {$1, " ", $2,"()\n",$5};
											$$ = concat(array, 5);
										 }
block : OPEN_CURL VAR CLOSE_CURL {
									const char * array[] = {"{\n", $2, "\n}\n"};
									$$ = concat(array, 3);
								 }
type : VOID {$$ = "void";}
function main
*/
program:  global_var function main                     {
                                                            printf("#include <stdio.h>\n#include <stdlib.h>\n%s\n%s\n%s",$1, $2, $3);
                                                       }
          ;

global_var: variable ASSIGN value SEMI_COLON global_var      {
                                                            const char * array[] = {$1, " = ", $3, ";\n", $5};
                                                            $$ = concat(array, 5);
                                                       }
          |                                            { $$ = ""; }
          ;

variable: var_type VAR                                 {
                                                            const char * array[] = {$1, $2};
                                                            $$ = concat(array, 2);
                                                       }
          ;

var_type: INT                                          { $$ = "int "; }
          | CHAR                                       { $$ = "char "; }
          ;

value: NUM                                             { $$ = $1; }
          | CHARE                                      { $$ = $1; }
          ;

function: FUNCVAR func_type OPEN_PAR def_args
          //intentionally not or'ed
          CLOSE_PAR OPEN_CURL line CLOSE_CURL function      {
                                                            const char * array[] = {$2, $1, "(", $4, ")\n", "{\n", $7, "}\n", $9};
                                                            $$ = concat(array, 9);
                                                       }
          |                                            { $$ = ""; }
          ;

func_type: VOID                                        { $$ = "void ";}
          | CHAR_ARR                                   { $$ = "char * ";}
          | var_type                                   { $$ = $1; }
          ;

def_args: variable def_args_extra
                                                       {
                                                            const char * array[] = {$1, $2};
                                                            $$ = concat(array, 2);
                                                       }
          ;

def_args_extra: COMMA variable def_args_extra{
                                                            const char * array[] = {", ", $2, $3};
                                                            $$ = concat(array, 3);
                                                       }
          |                                            { $$ = ""; }
          ;

main: MAIN OPEN_CURL line CLOSE_CURL     {
                                                            const char * array[] = {"int main()\n", "{\n", $3, "}\n"};
                                                            $$ = concat(array, 4);
                                                       }
          ;

line: global_var                                      {$$ = $1;}
          |

          ;

/*block: VAR
          ;*/

          /*func_block: block return
                    ;*/

          /*return: RETURN rvalue SEMI_COLON
                    ;*/

          /*rvalue: VAR
                    ;*/

%%

char * concat(const char *strings[], int length)
{
	//Get the amount of space needed for the final string and malloc
	int spaceNeeded = 1;
	for(int i = 0; i < length; i++){
		spaceNeeded += strlen(strings[i]);
	}

	//Concatenate all strings together into result
	char* result =  malloc(spaceNeeded);
	strcpy(result, strings[0]);
	for(int i = 1; i < length; i++)
	{
		strcat(result, strings[i]);
	}

	return result;
}

int yyerror(char *s){
    fprintf(stderr , "%s line %i \n", s, yylineno);
    exit(0);
}

int main(int argc ,char *argv[]){
    yyin = fopen(argv[1], "r");

    yyparse();

    fclose(yyin);
    return 0;
}
