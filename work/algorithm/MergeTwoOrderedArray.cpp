/****************************************************
  > File Name    : MergeTwoOrderedArray.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月09日 星期五 01时49分59秒
 ****************************************************/

#include <iostream>
#include "display.h"
using namespace std;

/**
 * @desc 合并两个有序数组a和b到数组c, 其中c的长度为a和b长度之和.
 * @param a[]   有序数组a;
 * @param n     有序数组a的长度;
 * @param b[]   有序数组b;
 * @param m     有序数组b的长度;
 * @param c     长度等于n+m的用于存放有序列表的数组
 * @return 
 */
void MergeTwoOrderedArray(int a[], int n, int b[], int m, int c[]) {
    int i, j, k;

    // i: 循环a
    // j: 循环b
    // k: 循环c
    i = j = k = 0;
    // 从小到大排序
    // 1.两个数组逐位比较，谁小去谁, 直到a和b中有一个有序数组为空;
    // 2.当一个数组为空时，另一个数组依然是有序的
    //  由于剩下的数组有序，则直接添加到c的末尾即可.
    while (i<n && j<m) {
        // 谁小谁NB
        if (a[i] < b[j]) {
            c[k++] = a[i++];
        } else {
            c[k++] = b[j++];
        }
    }

    // 这里两个while循环实际上只有一个进行
    // 不确定的情况下，只是为了正确性多写点代码，无他
    //  i是循环a剩下的，如果i==n, 说明a数组用完了，只有b数组的循环会进行;
    // 反之, j与b亦然.
    while (i<n)
        c[k++] = a[i++];
    while (j<m)
        c[k++] = b[j++];
}

void test() {
    int a[] = {1, 3, 5, 7, 9, 11};
    int an = sizeof(a) / sizeof(int);
    int b[] = {2, 4, 6, 8, 10};
    int bm = sizeof(b) / sizeof(int);
    int cLen = (sizeof(a) + sizeof(b)) / sizeof(int);
    int c[cLen];

    display(a, an);
    display(b, bm);
    MergeTwoOrderedArray(a, an, b, bm, c);
    display(c, cLen);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
