/****************************************************
  > File Name    : ShellSort.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月05日 星期一 11时05分13秒
  > Description  :
    希尔排序
 ****************************************************/

#include <iostream>
using namespace std;

void ShellSort(int array[], int len) {
    int gap, i, j;
    int temp;
    // 用gap分分组, 分组gap个组
    for (gap=len/2; gap>0; gap/=2) {
        // 每组进行直接插入排序, 每组相邻元素相差gap个元素
        // i从gap到len-1, 然后从后往前进行插入排序
        // 为什么不是i从0到gap-1呢，因为如果数组array是基数，这样就无法获取到最后一个元素，i从gap到len-1则可以，无论什么情况，数组最好一个元素是a[len-1]
        // 
        // 与普通直接插入排序(步长为1)的区别是，每组元素其实相差gap个单位(步长为gap)
        //  普通: a[1], a[2], a[3], [a4] a[5] a[6] a[7] a[8] a[9]
        //  希尔排序中(假设第一步步长为3):
        //      第一步(步长: 3):
        //          a[0] a[3] a[6]
        //          a[1] a[4] a[7]
        //          a[2] a[5] a[8]
        //          a[9] 
        //          (分组进行直接插入排序)
        //      第二步(步长: 3/2=1) (步长等于1(>0)最后一步, 相当于普通插入排序):
        //          a[0] a[1] a[2] a[3] a[4] a[5] a[6] a[7] a[8] a[9]
        for (i=gap; i<len; i++) {
            temp = array[i];
            for (j=i-gap; j>0 && temp<array[j]; j-=gap)
                array[j+gap] = array[j];
            array[j+gap] = temp;
        }
    }
}

int main (int argc, char* argv[]) {
    return 0;
}
