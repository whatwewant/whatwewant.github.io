/****************************************************
  > File Name    : SortedListInsertElement.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月05日 星期一 01时16分07秒
  > Description  :
        有序列表插入一个元素
 ****************************************************/

#include <iostream>
using namespace std;

void display(int a[], int n) {
    for (int i=0; i<n; ++i)
        cout << a[i] << ' ';
    cout << endl;
}

/*
 * 交换元素
 * */
void Swap(int &a, int &b) {
    int t = a;
    a = b;
    b = t;
}

/*
 * 这里: a[0...n-2]为有序元素, a[n-1]为无序的
 * Why:
 *    将value插入到a[0...m-1], 
 *    如果n-2=m-1的话, 就是value插入到a[0...n-2],
 *    很明显，
 *      最终的元素个数: n个(a[0...n-1]), 
 *          (n = n-1(a[0-n-1]的元素) + 1(待插入的元素)) 
 *    其实也就是就是其实是将a[n-1]插入到有序列表a[0...n-2]中, 
 *
 *  现在将一个元素value插入到a[0..m-1] (n = m + 1)
 *   等价于
 *  将a[n-1]插入到a[0...n-2]中
 *
 * 求解步骤:(默认: 从小到大)
 *  Step 1: 令j = n-1 -> 0 (n个元素) (如果j=n->0, 说明有n+1个元素)
 *  step 2:
 *      如果 a[j] > a[j-1], 说明a[0...j]已经是有序的 (a[0...j-1]是有序的), 跳出;
 *      如果 a[j] < a[j-1], 也就是a[j]比a[j-1]小, 说明a[j]应该排在a[j-1]前面, 那么交换a[j]和a[j-1];
 *
 * */
void SortedListInsertElement(int a[], int n) {
    // 总共n个元素：0 -> n-1, a[n-1]是最后一个元素
    for (int j=n-1; j>0; j--) {
        if (a[j] < a[j-1])
            swap(a[j], a[j-1]);
    }
}

void test(void) {
    int a[10] = {1, 2, 3, 4, 6, 7};
    int value = 5;
    a[6] = value;

    cout << "Before: ";
    display(a, 7);
    SortedListInsertElement(a, 7);
    cout << "After: ";
    display(a, 7);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
