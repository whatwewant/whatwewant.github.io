/****************************************************
  > File Name    : QuickSort.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月06日 星期二 02时14分54秒
 ****************************************************/

#include <iostream>
#include "display.h"
using namespace std;

/*
 * Array: 数组
 * left: 希望被排序的起始位置
 * right: 希望被排序的末尾位置
 * 因此: left和right可对数组部分调整
 * 当left=0 且 right=len-1时，则是对整个数组Array调整.
 *  该函数有两个作用:
 *      1.一轮下来，将数组分为左小右大两部分，自然基准数就是相对中间数了, 接下来只要分别对左右两半分别继续调整即可
 *      2.返回基准数最终存放的位置, 为的是区分左右两半部分
 * */
int AdjustArray(int array[], int left, int right) {
    int i=left, j=right;
    // 基数x(=a[i]=a[left])确定, 第一个坑a[i]挖好
    int x = array[i]; /* 选择左边第一个数作为基准数 */
    while (i < j) {
        // 从右到左找小, 要填到左边坑a[i]中
        // 注意条件: array[j]大于等于x
        while (i<j && array[j] >= x)
            j--;
        // 找到比基准数小的a[j]
        if (i < j) {
            array[i] = array[j]; // 此时坑a[i]已经填上a[j], a[j]为新坑
            i++;
        }

        // 从左往右找大, 要填到右边坑a[j]中
        while (i<j && array[i] < x)
            i++;
        // 找到比基准数大的a[i]
        if (i < j) {
            array[j] = array[i]; // 此时坑a[j]已经填上a[j], a[i]为新坑
            j--;
        }
    }

    array[i] = x;
    return i;
}

int AdjustArrayExchange(int array[], int left, int right) {
    int i=left, j=right;
    int x = array[i];
    while (i < j) {
        // 从右往左，直到找到比基准数x小的数
        while (i<j && array[j]>=x) 
            j--;
        // 由于第一个i是基准数x的位置, 已经确定
        // 所以在找出右边的坑j后立即交换
        // 然后再更新左边的坑i
        Swap(array[j], array[i]);

        // 从左往右，知道找到比基准数x大或者等于的数
        while (i<j && array[i]<x) 
            i++;
    }
    array[i] = x;
    display(array, 8);
    return i;
}

int AdjustArrayExchange2(int array[], int left, int right) {
    int i=left, j=right;
    int middle = array[i];
    while (i < j) {
        while (i<j && array[i]<middle) i++;
        while (i<j && array[j]>=middle) j--;
        Swap(array[i], array[j]);
    }
    array[i] = middle;
    return i;
}

void QuickSortCombind(int array[], int left, int right) {
    int i=left, j=right;
    int middle = array[i];
    if (i < j) {
        while (i < j) {
            while (i<j && array[i]<middle) i++;
            while (i<j && array[j]>=middle) j--;
            Swap(array[i], array[j]);
        }
        array[i] = middle;
        QuickSortCombind(array, left, i-1);
        QuickSortCombind(array, i+1, right);
    }
}

/*
 * Array: 数组
 * left: 希望被排序的起始位置
 * right: 希望被排序的末尾位置
 * 因此: left和right可对数组部分排序
 * 当left=0 且 right=len-1时，则是对整个数组Array排序.
 * */
void QuickSort(int array[], int left, int right) {
    // 只有当数组范围大于1的时候才进行调整
    // 否则，单个元素本身就是有序，无需调整
    if (left < right) {
        // 一轮调整, i左边的都比a[i]小, i右边的都比a[i]大
        // i 为基准数一轮后存放的位置
        // int i = AdjustArrayExchange2(array, left, right);
        int i = AdjustArrayExchange2(array, left, right);
        // 分治
        // 由于i左边, 即left->i-1, 都比a[i]小但是顺序不确定, 以同样的方法调整左小右大两部分,但缩小范围, 只左边
        QuickSort(array, left, i-1);
        // 由于i右边, 即i+1->right, 都比a[i]大但无序, 以用样方法调整成左小右大两部分,但范围只有右半部分
        QuickSort(array, i+1, right);
    }
}

void test(void) {
    int a[] = {4, 7, 3, 1, 2, 5, 9, 6};
    int len = sizeof(a) / sizeof(int);

    display(a, len);
    QuickSortCombind(a, 0, len-1);
    display(a, len);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
