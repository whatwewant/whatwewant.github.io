/****************************************************
  > File Name    : BinarySearch.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月05日 星期一 03时18分33秒
  > Description  :
        折半查找法
 ****************************************************/

#include <iostream>
using namespace std;

bool BinarySearch(int a[], int n, int value) {
    // 标记元素:
    //      low: "第一个"元素下标
    //      high: "最后一个"元素下标
    //      middle: low和high中间的元素下标(low + high)/2
    int low=0, high=n-1, middle;

    // 注意条件: low 小于等于 high
    //  Why:
    //      假设数组a共两个元素(0, 1), 那么low=0, high=1,
    //          如果BinarySearch查找0, middle=(low+high)/2=0, a[middle]==0, 找到;
    //          如果BinarySearch查找1, middle=(low+high)/2=0, a[middle] < 1, 这时low=middle + 1 = 1, 也即low==high, 新middle=1, a[middle]==1, 找到.
    while(low <= high) {
        middle = (low + high) / 2;
        if (value < a[middle]) {
            // 如果待查找的值value小于中间值，
            //  则说明value在low->middle-1之间, 也就是左半部分(假设low左, hight右);
            //      (middle-1, 是因为middle已经不等于value, 没有必要了)
            //  则更新high = middle - 1, 继续循环
            high = middle - 1;
        } else if (value > a[middle]) {
            // 如果待查找的值value大于中间值,
            //  则说明value在middle+1->high之间, 也就是右半部分
            //  更新low = middle + 1, 继续循环
            low = middle + 1;
        } else {
            // 待查找的值等于中间值a[middle], 找到
            cout << "序号: " << middle << endl;
            return true;
        }
    }
    // 查找完整个数组，并未找到待查找的值value
    return false;
}

void test() {
    int a[] = {1, 2, 4, 5, 6, 7, 8};
    int value;
    while (true) {
        cout << "Value: ";
        cin >> value;
        if (BinarySearch(a, sizeof(a)/sizeof(int), value)) {
            cout << "找到元素: " << value << endl;
        } else {
            cout << "未找到元素: " << value << endl;
        }
    }
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
