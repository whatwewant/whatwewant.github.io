---
layout: post
title: "八种排序算法之折半插入排序(Binary Insert Sort) 1-2"
keywords: [""]
description: ""
category: "algorithm"
tags: [binaryinsertsort, sort, algorithm]
---
{% include JB/setup %}

### 一、基本思想
* 在[直接插入排序]({{site.url}}/2015/10/04/One-out-of-eight-kinds-of-algorithm-1-insertsort.html)的基础上，与其通过从后往前一一比较(或比较交换交换), 折半插入排序则利用`折半查找(BinarySearch)`的(low, high)确定带插入的数字的位置hight+1，是比middle小(左半部分)还是大(右半部分)

### 二、基础: 折半查找法+直接插入排序

```c
// 折半查找(BinarySearch)
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
```

### 三、解题方法

```c
void BinaryInsertSort(int a[], int n) {
    for (int i=1; i<n; ++i) {
        int guard = a[i];
        int low = 0, high = h-1, middle;

        // 已知哨兵应该插入的位置是high+1, 
        //  利用折半查找确定high这个位置
        while (low <= high) {
            middle = (low + high) / 2;
            if (guard < a[middle])
                high = middle - 1;
            else
                low  = middle + 1;
        }

        // 找到存放哨兵guard值(其实是a[i]的值)的位置: high + 1
        // 那么将a[high+1...i-1]后移一位 -> a[high+2...i]
        // 再将guard插入a[high+1]
        // 因为guard是a[i], 所以不会存在溢出或覆盖问题
        for (int j=i-1; j>high; j--)
            a[j+1] = a[j];

        // 插入guard
        a[high + 1] = guard;
    }
}
```

### 四、总结

```bash
折半插入排序，相比于直接插入排序的优势就在于
    通过`折半查找(BinarySearch)`快速找到插入点high+1, 
    比直接插入排序从后往前一一对比(或交换)快得多
```
