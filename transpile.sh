#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'No input file supplied'
    exit 0
fi

REGEX="^[A-Za-z0-9]+\.oji$"
if ! [[ $1 =~ $REGEX ]] ; then
     echo 'Please input a .oji file'
     exit 0
fi

if [ ! -f "$1" ]
then
    echo "File $1 does not exists"
    exit 0
fi

out=`echo "$1" | sed 's/oji/cpp/g'`
set -e
yacc -d emoji.y
lex emoji.l

gcc lex.yy.c y.tab.c -o output -lm

./output $1 > $out

rm -f lex.yy.c
rm -f y.tab.c
rm -f y.tab.h
rm -f output
