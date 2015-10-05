/****************************************************
 * Display An Array
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
