#include <stdio.h>
float stack[10000000]={-1};
float heap[10000000] = {-1};
float P = 5000;
 float H = 0;
float t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28 = -1;

int main()
{
t2 = 0;
t3 = 50000;
t4 = 50000;
heap[(int)t2] = t3;
t3 = t3 + 1;
heap[(int)t4] = t3;
t5 = 4;
heap[(int)t3] = t5;
t1 = t3;
t1 = t1 + 1;
heap[(int)t1] = 104;
t1 = t1 + 1;
heap[(int)t1] = 111;
t1 = t1 + 1;
heap[(int)t1] = 108;
t1 = t1 + 1;
heap[(int)t1] = 97;


t6 = 0;
t7 = heap[(int)t6];
t8 = heap[(int)t7];
t7 = heap[(int)t8];
printf("%d",(int)t7);
printf("\n");


t9 = heap[0];

t10= heap[(int)t9];
t10 = t10 + 1;
t11= heap[(int)t10];
t12 = 0;
L1:
if(t12==t11) goto L2;
t13 = t12 + t10;
t12 = t12 + 1;
t14 = heap[(int)t13];
printf("%c",(char)t14);
goto L1;
L2:
printf("\n");


t16 = heap[0];
t16 = t16 + 1;
t17 = heap[(int)t16];
t18 = t16 + t17;
t18 = t18 + 1;
heap[(int)t18] = 32;
t18 = t18 + 1;
heap[(int)t18] = 98;
t18 = t18 + 1;
heap[(int)t18] = 98;
t17 = t17 + 3;
heap[(int)t16] = t17;


t19 = heap[0];

t20= heap[(int)t19];
t20 = t20 + 1;
t21= heap[(int)t20];
t22 = 0;
L3:
if(t22==t21) goto L4;
t23 = t22 + t20;
t22 = t22 + 1;
t24 = heap[(int)t23];
printf("%c",(char)t24);
goto L3;
L4:
printf("\n");


t26 = heap[0];
t26 = t26 + 2;
t27 = t26 + 0;
t28 = heap[(int)t27];

printf("%c",(char)t28);
printf("\n");


return 0;
}

