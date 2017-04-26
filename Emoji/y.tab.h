/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    OPEN_PAR = 258,
    CLOSE_PAR = 259,
    CLOSE_CURL = 260,
    OPEN_CURL = 261,
    QUOTE = 262,
    SEMI_COLON = 263,
    COMMA = 264,
    VOID = 265,
    INT = 266,
    CHAR = 267,
    CHAR_ARR = 268,
    ASSIGN = 269,
    MAIN = 270,
    RETURN = 271,
    PRINT = 272,
    WHILE = 273,
    ELSE = 274,
    IF = 275,
    CONTINUE = 276,
    BREAK = 277,
    MULT = 278,
    MINUS = 279,
    PLUS = 280,
    NOT_EQ = 281,
    GT_EQ = 282,
    LT_EQ = 283,
    LT = 284,
    GT = 285,
    EQ = 286,
    FUNCVAR = 287,
    VAR = 288,
    NUM = 289,
    CHARE = 290
  };
#endif
/* Tokens.  */
#define OPEN_PAR 258
#define CLOSE_PAR 259
#define CLOSE_CURL 260
#define OPEN_CURL 261
#define QUOTE 262
#define SEMI_COLON 263
#define COMMA 264
#define VOID 265
#define INT 266
#define CHAR 267
#define CHAR_ARR 268
#define ASSIGN 269
#define MAIN 270
#define RETURN 271
#define PRINT 272
#define WHILE 273
#define ELSE 274
#define IF 275
#define CONTINUE 276
#define BREAK 277
#define MULT 278
#define MINUS 279
#define PLUS 280
#define NOT_EQ 281
#define GT_EQ 282
#define LT_EQ 283
#define LT 284
#define GT 285
#define EQ 286
#define FUNCVAR 287
#define VAR 288
#define NUM 289
#define CHARE 290

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "emoji.y" /* yacc.c:1909  */

	char * string;
	int num;

#line 129 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
