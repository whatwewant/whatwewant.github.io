/****************************************************
  > File Name    : Stack-3-Replace-Recursion.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月17日 星期六 02时20分23秒
  > Description  :
    栈应用 之 用栈实现递归函数，即非递归
    重要性: 树非递归实现的基础
 ****************************************************/

#include <iostream>
#define MAXSIZE 1024
using namespace std;

/*
 题目:
    利用一个栈实现以下递归函数的非递归计算:
                1                       n=0
        Pn(x) = 2x                      n=1
                2xPn-1(x)-2(n-1)Pn-2(x) n>1
*/

// 递归栈
// StackOverwriteRecursion
double P(int n, double x) {
    struct stack {
        int no;         // 保存n
        double val;     // 保存Pn(x)值
    } st[MAXSIZE];

    int top=-1, i; // top为栈st的下标值变量
    double fv1=1, fv2=2*x; // n=0, n=1时的初值
    // Step 1: 入栈
    //  我们知道n+1的之就相当于最大递归的层数, 由于n=0, 和n=1已知, 则最大只需n-1层, 也就是递归栈最大为n-1
    //  所以，这里入栈，相当于预留
    for (i=n; i>=2; i--) {
        st[++top].no = i;
    }

    // 出栈
    //  从底层往顶层，反向得出解
    while (top >= 0) {
        st[top].val = 2*x*fv2 - 2*(st[top].no-1)*fv1;
        fv1 = fv2;
        fv2 = st[top].val;
        top --;
    }
}

int main (int argc, char* argv[]) {
    return 0;
}
