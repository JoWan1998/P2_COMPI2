#include <stdio.h>
float stack[10000000]={-1};
float heap[10000000] = {-1};
float P = 0;
 float H = 0;
float t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,t31,t32,t33,t34,t35,t36 = -1;
int main()
{
t6 = 0;
t1 = 1989.5;
t2 = 0.5;
t3 = t1 + t2;
t4 = 8;
t5 = t3 + t4;
heap[(int)t6] = t5;
t9 = 1;

t11 = 50000;
t10 = 50000;
heap[(int)t9] = t11;
t11 = t11 + 1;
heap[(int)t10] = t11;
t12 = 16;
heap[(int)t11] = t12;
t8 = t11;
t8 = t8 + 1;
heap[(int)t8] = 49;
t8 = t8 + 1;
heap[(int)t8] = 57;
t8 = t8 + 1;
heap[(int)t8] = 57;
t8 = t8 + 1;
heap[(int)t8] = 56;
t8 = t8 + 1;
heap[(int)t8] = 58;
t8 = t8 + 1;
heap[(int)t8] = 32;
t8 = t8 + 1;
heap[(int)t8] = 104;
t8 = t8 + 1;
heap[(int)t8] = 111;
t8 = t8 + 1;
heap[(int)t8] = 108;
t8 = t8 + 1;
heap[(int)t8] = 97;
t8 = t8 + 1;
heap[(int)t8] = 32;
t8 = t8 + 1;
heap[(int)t8] = 109;
t8 = t8 + 1;
heap[(int)t8] = 117;
t8 = t8 + 1;
heap[(int)t8] = 110;
t8 = t8 + 1;
heap[(int)t8] = 100;
t8 = t8 + 1;
heap[(int)t8] = 111;
t21 = 2;
t14=0;
t15=stack[(int)t14];
t13 = 1997;
t16=t15>t13;
t17 = 1;
t18 = 0;
L1:
	 if(t16==1) goto L2;
	 goto L3;
L2:
	t19=t17;
	 goto L4;
L3:
	t19=t18;
	 goto L4;
L4:
if(t19 == 0) goto L5;
t20 = 0;
goto L6;
L5:
	t20 = 1;
	goto L6;
L6:

heap[(int)t21] = t20;
t22 = 5;
t23 = 3;
t24 = 1000000;
heap[(int)t23] = t24;
heap[(int)t24] = t24 + 1;
t24 = t24 + 1;
heap[(int)t24] = t22;
t25 = 1;
L7: 
	if( t25 == t22 ) goto L8;
	t24 = t24 + 1;
	t25 = t25 + 1;
	heap[(int)t24] = -1;
	goto L7;
L8: t26 = heap[0];
printf("%d",(int)t26);
printf("\n");
t27 = 1900;
heap[0] = t27;
t29 = heap[0];
printf("%d",(int)t29);
printf("\n");
t30 = heap[1];

t31= heap[(int)t30];
t31 = t31 + 1;
t32= heap[(int)t31];
t33 = 0;
L9:
if(t33==t32) goto L10;
t34 = t33 + t31;
t33 = t33 + 1;
t35 = heap[(int)t34];
printf("%c",(char)t35);
goto L9;
L10:
printf("\n");
t36 = heap[2];
if(t36==0) goto L11;
printf("true");
goto L12;
L11:
printf("false");
goto L12;
L12:
printf("\n");
return 0;
}