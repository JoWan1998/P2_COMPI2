#include <stdio.h>
float stack[10000000]={-1};
float heap[10000000] = {-1};
float P = 0;
 float H = 0;
float t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,t31,t32,t33,t34,t35,t36,t37,t38,t39,t40,t41,t42,t43,t44,t45,t46,t47,t48,t49,t50,t51,t52,t53,t54,t55,t56,t57,t58,t59,t60,t61,t62,t63,t64,t65,t66,t67,t68,t69,t70,t71,t72,t73,t74,t75,t76,t77,t78,t79 = -1;
int main()
{
t6 = 0;
t1 = 1989.5;
t2 = 0.5;
t3 = t1 + t2;
t4 = 8;
t5 = t3 + t4;
heap[(int)t6] = t5;


t7 = 5;
t8 = 1;
t9 = 1000000;
heap[(int)t8] = t9;
heap[(int)t9] = t9 + 1;
t9 = t9 + 1;
heap[(int)t9] = t7;
t10 = 1;
L1: 
	if( t10 == t7 ) goto L2;
	t9 = t9 + 1;
	t10 = t10 + 1;
	heap[(int)t9] = -1;
	goto L1;
L2: 

t66 = heap[1];
t67 = heap[(int)t66];
t69 = 3;
heap[(int)t67] = t69;
t56 = t67;
t56 = t56 + 1;
t58 = 1035000;
t57 = 1035000;
t59 = 1;
heap[(int)t58] = t59;
t19 = t58;
t19 = t19 + 1;
t21 = 1005000;
t20 = 1005000;
t22 = 1;
heap[(int)t21] = t22;
t14 = t21;
t14 = t14 + 1;
t11 = 0;
heap[(int)t14] = t11;
t14 = t14 + 1;
t12 = 1;
heap[(int)t14] = t12;
t14 = t14 + 1;
t13 = 2;
heap[(int)t14] = t13;

heap[(int)t19] = t20;
t19 = t19 + 1;
t24 = 1010000;
t23 = 1010000;
t25 = 1;
heap[(int)t24] = t25;
t18 = t24;
t18 = t18 + 1;
t15 = 3;
heap[(int)t18] = t15;
t18 = t18 + 1;
t16 = 4;
heap[(int)t18] = t16;
t18 = t18 + 1;
t17 = 5;
heap[(int)t18] = t17;

heap[(int)t19] = t23;

heap[(int)t56] = t57;
t56 = t56 + 1;
t61 = 1040000;
t60 = 1040000;
t62 = 1;
heap[(int)t61] = t62;
t34 = t61;
t34 = t34 + 1;
t36 = 1015000;
t35 = 1015000;
t37 = 1;
heap[(int)t36] = t37;
t29 = t36;
t29 = t29 + 1;
t26 = 6;
heap[(int)t29] = t26;
t29 = t29 + 1;
t27 = 7;
heap[(int)t29] = t27;
t29 = t29 + 1;
t28 = 8;
heap[(int)t29] = t28;

heap[(int)t34] = t35;
t34 = t34 + 1;
t39 = 1020000;
t38 = 1020000;
t40 = 1;
heap[(int)t39] = t40;
t33 = t39;
t33 = t33 + 1;
t30 = 9;
heap[(int)t33] = t30;
t33 = t33 + 1;
t31 = 10;
heap[(int)t33] = t31;
t33 = t33 + 1;
t32 = 11;
heap[(int)t33] = t32;

heap[(int)t34] = t38;

heap[(int)t56] = t60;
t56 = t56 + 1;
t64 = 1045000;
t63 = 1045000;
t65 = 1;
heap[(int)t64] = t65;
t49 = t64;
t49 = t49 + 1;
t51 = 1025000;
t50 = 1025000;
t52 = 1;
heap[(int)t51] = t52;
t44 = t51;
t44 = t44 + 1;
t41 = 12;
heap[(int)t44] = t41;
t44 = t44 + 1;
t42 = 13;
heap[(int)t44] = t42;
t44 = t44 + 1;
t43 = 14;
heap[(int)t44] = t43;

heap[(int)t49] = t50;
t49 = t49 + 1;
t54 = 1030000;
t53 = 1030000;
t55 = 1;
heap[(int)t54] = t55;
t48 = t54;
t48 = t48 + 1;
t45 = 15;
heap[(int)t48] = t45;
t48 = t48 + 1;
t46 = 16;
heap[(int)t48] = t46;
t48 = t48 + 1;
t47 = 17;
heap[(int)t48] = t47;

heap[(int)t49] = t53;

heap[(int)t56] = t63;



t78 = 2;
t70 = 0;
t74 = heap[1];
t75 = heap[(int)t74] + 1;
t73 = t70 + t75;
t76 = t75 + t70;
t77 = heap[(int) t76];

heap[(int)t78] = t77;


t79 = heap[2];
printf("%d",(int)t79);
printf("\n");

return 0;
}