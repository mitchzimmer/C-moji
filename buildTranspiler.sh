#!/bin/bash
set -e
yacc -d emoji.y
lex emoji.l

gcc lex.yy.c y.tab.c -o transpiler -lm

rm -f lex.yy.c
rm -f y.tab.c
rm -f y.tab.h
