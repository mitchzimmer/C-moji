echo PARSER STARTED

gcc lex.yy.c y.tab.c -o output -lm

./output $1 > outfile.c

echo PARSER FINISHED;


