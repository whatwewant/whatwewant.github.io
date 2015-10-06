/****************************************************
  > File Name    : SelectSort.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月07日 星期三 06时02分48秒
 ****************************************************/

#include <iostream>
#include "display.h"
using namespace std;

/**
 * array : 数组
 * len : 数组长度
 *
 */
void SelectSort(int array[], int len) {
    // 当前的值最小的数组下标
    int min_id;
    // 长度len的数组，排序len-1次交换就行了
    // 每次只有最小的排到相对最前面
    // i 刚好存放每次相对最小的数, 也就是要交换的数
    for (int i=0; i<len-1; ++i) {
        // 默认假设最后一个(len-1)数是最小的数
        min_id = len - 1;
        // 每次从a[i...len-1]找出相对最小值的下标只需要len-i+1步
        // 这个循环就是和冒泡排序的唯一区别
        /* 
         * 冒泡排序     选择排序
         * * * * * * * * * * * *
         * 每次都交换   只有找到最小值的时候交换
         * */
        for (int j=len-2; j>=i; j--) {
            // 比较出较小值
            if (array[min_id] > array[j]) {
                min_id = j;
            }
        }
        cout << "Min[" << i+1 << "]: " << array[min_id] << endl;
        // 每次和a[i]交换，a[i]此时就是相对最小值，本轮结束
        Swap(array[i], array[min_id]);
    }
}

void test(void) {
    int a[] = {1, 3, 2, 7, 6, 5, 12, 9, 13, 11, 8};
    int len = sizeof(a) / sizeof(int);

    display(a, len);
    SelectSort(a, len);
    display(a, len);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
