#include <stdio.h>
#include <iostream>
#include <stdlib.h>
using namespace std;



int main()
{
int a2 = 0;
int a3 = 0;
int a4 = 12;
int a5 = 0;
while(a2 < a4){
while(a3 <= a2){
if(a2 * a3 == a4){
a5 = 1;
break;
}
else{
}
a3 = a3 + 1;
}
a2 = a2 + 1;
a3 = 0;
}
cout << a5;
}
