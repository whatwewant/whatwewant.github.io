/****************************************************
  > File Name    : BubbleSort.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月05日 星期一 11时43分34秒
  > Description  :
        冒泡排序
 ****************************************************/

#include <iostream>
#include "display.h"
using namespace std;

// 轻泡上浮法
void BubbleSort(int array[], int len) {
    // 总共len个元素，每轮有一个元素到达相对顶部，那么至少冒泡len-1轮
    // i+1正好表示第几轮
    // i+1正好表示冒泡后顶部第i+1个元素a[i], 此时a[i]是相对最小的
    for (int i=0; i<len-1; ++i) {
        // 从当前最后一个元素开始冒泡, 轻泡上浮最上
        // 当前最后一个元素是a[i]=a[j]
        // 然后不断比较j(后)和j-1(前)
        //      如果满足a[j]<a[j-1], 说明后一个元素比前一个元素轻，应该将气泡上浮
        //      否则说明前一个(上面)的气泡更轻，不用移动
        //   然后j=j-1, 即上浮后的元素再跟它前一个元素比较，直到j=i+1, 也即到相对的第一个元素
        //   每一轮都会使一个相对最小的元素上浮到顶部(此时的最顶部是j-1=i)
        // 然后进入下一轮i
        for (int j=len-1; j>i; --j)
            if (array[j] < array[j-1])
                Swap(array[j], array[j-1]);

        cout << "第 " << i+1 << " 轮排序第" << i+1 << "个元素: " << array[i] << endl;
        display(array, len);
    }
}

// 重泡下沉法
void BubbleSortDown(int array[], int len) {
    // 总共len-1轮
    for (int i=0; i<len-1; ++i) {
        // 该步是和 轻泡上浮法 的关键区别
        // 每一轮有一个最重的泡到相对最底部
        // 每次都是从第一个元素j=0开始，直到j=len-1-i+1, 因为每一步步是j和j+1, 最后异步步j=len-i-1 + 1时, j+1=len-1-i是相对最后一个元素
        for (int j=0; j<len-i-1; ++j) {
            if (array[j] > array[j+1])
                Swap(array[j], array[j+1]);
        }
    }
}
 
void test(void) {
    int a[] = {4, 3, 2, 5, 1, 8};
    int size = sizeof(a) / sizeof(int);
    cout << "排序前: ";
    display(a, size);
    // BubbleSort(a, size);
    BubbleSortDown(a, size);
    cout << "排序后: ";
    display(a, size);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
