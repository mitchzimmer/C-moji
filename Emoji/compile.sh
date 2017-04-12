#!/bin/bash

yacc -d emoji.y
lex emoji.l
gcc lex.yy.c y.tab.c -o output
echo PARSER STARTED :

./output input.emoji > outfile

rm -f lex.yy.c
rm -f y.tab.c
rm -f y.tab.h
rm -f output
