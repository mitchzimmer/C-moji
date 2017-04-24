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

%type <string> extern_var_declaration
%type <string> var_declaration;
%type <string> variable;
%type <string> function;
%type <string> main;
%type <string> var_type;
%type <string> value;
%type <string> func_type;
%type <string> def_args;
%type <string> def_args_extra;
%type <string> line;
%type <string> lines;
%type <string> expr;
%type <string> bool_expr;
%type <string> bvalue;
%type <string> math_expr;
%type <string> mvalue;

%left NOT_EQ GT LT GT_EQ LT_EQ EQ MULT MINUS PLUS
%start program

%%
program:  extern_var_declaration function main         {
                                                            printf("#include <stdio.h>\n#include <iostream>\n#include <stdlib.h>\nusing namespace std;\n\n%s\n%s\n%s",$1,$2,$3);
                                                       }
          ;


//==============================================================================
//==============================================================================
// Global variable declaration
extern_var_declaration: variable ASSIGN value SEMI_COLON extern_var_declaration {
                                                            const char * array[] = {$1, " = ", $3, ";\n", $5};
                                                            $$ = concat(array, 5);
                                                       }
          |                                            { $$ = ""; }
          ;

var_declaration: variable ASSIGN mvalue SEMI_COLON      {
                                                            const char * array[] = {$1, " = ", $3, ";\n"};
                                                            $$ = concat(array, 4);
                                                       }
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
          | CHARE                                      {
                                                            const char * array[] = {"'", $1, "'"};
                                                            $$ = concat(array, 3);
                                                       }
          ;

///==============================================================================
//==============================================================================
// Function declaration
function: FUNCVAR func_type OPEN_PAR def_args
          //intentionally not or'ed
          CLOSE_PAR lines function                     {
                                                            const char * array[] = {$2, $1, "(", $4, ")\n", $6, "\n", $7};
                                                            $$ = concat(array, 8);
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

def_args_extra: COMMA variable def_args_extra          {
                                                            const char * array[] = {", ", $2, $3};
                                                            $$ = concat(array, 3);
                                                       }
          |                                            { $$ = ""; }
          ;

//==============================================================================
//==============================================================================
// Main function
main: MAIN lines     {
                                                            const char * array[] = {"int main()\n", $2};
                                                            $$ = concat(array, 2);
                                                       }
          ;

//==============================================================================
//==============================================================================
// Blocks
lines: OPEN_CURL line CLOSE_CURL                        {
                                                            const char * array[] = {"{\n", $2, "}\n"};
                                                            $$ = concat(array, 3);
                                                       }
          ;

line: var_declaration line                             {
                                                            const char * array[] = {$1, $2};
                                                            $$ = concat(array, 2);
                                                       }
          | VAR ASSIGN mvalue SEMI_COLON line          {
                                                            const char * array[] = {$1, " = ", $3, ";\n", $5};
                                                            $$ = concat(array, 5);
                                                       }
          | PRINT expr SEMI_COLON line                 {
                                                            const char * array[] = {"cout << ", $2, ";\n", $4};
                                                            $$ = concat(array, 4);
                                                       }
          | IF bool_expr lines ELSE lines line         {
                                                            const char * array[] = {"if(", $2, ")", $3, "else", $5, $6};
                                                            $$ = concat(array, 7);
                                                       }
          | WHILE bool_expr lines line                 {
                                                            const char * array[] = {"while(", $2, ")", $3, $4};
                                                            $$ = concat(array, 5);
                                                       }
          | BREAK                                      {$$ = "break;\n";}
          | CONTINUE                                   {$$ = "continue;\n";}
          | RETURN expr                                {
                                                            const char * array[] = {"return ", $2, ";\n"};
                                                            $$ = concat(array, 3);
                                                       }
          | RETURN                                     {$$ = "return;\n";}
          |                                            {$$ = "";}
          ;

//==============================================================================
//==============================================================================
// Any expression
expr: mvalue                                           {$$ = $1;}
          | bool_expr                                  {$$ = $1;}
          ;

bool_expr: mvalue LT mvalue                            {
                                                            const char * array[] = {$1, " < ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | mvalue GT mvalue                           {
                                                            const char * array[] = {$1, " > ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | mvalue LT_EQ mvalue                        {
                                                            const char * array[] = {$1, " <= ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | mvalue GT_EQ mvalue                        {
                                                            const char * array[] = {$1, " >= ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | bvalue NOT_EQ bvalue                       {
                                                            const char * array[] = {$1, " != ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | bvalue EQ bvalue                           {
                                                            const char * array[] = {$1, " == ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          ;

bvalue: mvalue                                          {$$ = $1;}
          | bool_expr                                  {$$ = $1;}
          | OPEN_PAR bool_expr CLOSE_PAR               {
                                                            const char * array[] = {"(", $2, ")"};
                                                            $$ = concat(array, 3);
                                                       }
          ;

math_expr: mvalue PLUS mvalue                          {
                                                            const char * array[] = {$1, " + ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | mvalue MINUS mvalue                        {
                                                            const char * array[] = {$1, " - ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          | mvalue MULT mvalue                         {
                                                            const char * array[] = {$1, " * ", $3};
                                                            $$ = concat(array, 3);
                                                       }
          ;

mvalue: value                                          {$$ = $1;}
          | math_expr                                  {$$ = $1;}
          | VAR                                        {$$ = $1;}
          | OPEN_PAR math_expr CLOSE_PAR               {
                                                            const char * array[] = {"(", $2, ")"};
                                                            $$ = concat(array, 3);
                                                       }
          ;

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
