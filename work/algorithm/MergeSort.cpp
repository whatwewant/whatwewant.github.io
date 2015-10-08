/****************************************************
  > File Name    : MergeSort.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月09日 星期五 02时13分39秒
 ****************************************************/

#include <iostream>
#include "display.h"
using namespace std;

/**
 * @desc 合并一个前半部分有序，后半部分有序，但总体无序的数组.
 *      类似合并连个有序序列.
 * @param array     待排序数组
 * @param first     待排序起始位置
 * @param mid       待排序中间位置
 * @param last      待排序结束位置
 * @param tmp       存放array有序数据的临时数组
 * @return
 */
void MergeArray(int array[], int first, int mid, int last, int tmp[]) {
    int i=first, j=mid+1;
    int n=mid, m=last;
    int k = 0;
    while (i<=n && j<=m) {
        if (array[i] < array[j])
            tmp[k++] = array[i++];
        else
            tmp[k++] = array[j++];
    }

    while (i<=n)
        tmp[k++] = array[i++];
    while (j<=m)
        tmp[k++] = array[j++];

    for (i=0; i<k; i++)
        array[first + i] = tmp[i];
}

/**
 * @desc 归并排序的关键操作: 递归分解数组，然后合并
 * 
 * @param array     待排序数组
 * @param first     待排序起始位置
 * @param last      待排序结束位置
 * @param tmp       存放array有序数据的临时数组
 * @return 
 */
void divideAndMerge(int array[], int first, int last, int tmp[]) {
    if (first < last) {
        int mid = (first + last) / 2;
        // 一般只分左右两边递归
        divideAndMerge(array, first, mid, tmp); // 左边有序
        divideAndMerge(array, mid+1, last, tmp); // 右边有序
        // 将左右两个有序序列合并
        MergeArray(array, first, mid, last, tmp); // 再将两个有序数列合并
    }
}

/*
 * @desc 合并排序
 *
 * @param array     待归并排序的数组
 * @param len       数组长度
 */
bool MergeSort(int array[], int len) {
    int *p = new int[len];
    if (p == NULL)
        return false;
    divideAndMerge(array, 0, len-1, p);
    delete[] p;
    return true;
}

void test() {
    int a[] = {9,8,7,6,5,3,4,2,1,12,34,23,11};
    int ln = sizeof(a) / sizeof(int);
    display(a, ln);
    MergeSort(a, ln);
    display(a, ln);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
