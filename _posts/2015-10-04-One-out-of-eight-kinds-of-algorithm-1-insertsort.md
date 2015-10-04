---
layout: post
title: "八种排序算法之直接插入排序(InsertSort) 1"
keywords: ["insertsort"]
description: ""
category: "algorithm"
tags: [insertsort, sort, algorithm]
---
{% include JB/setup %}

### 一、基本思想
* 每次将一个待排序的记录a[i]，插入到前面已经排好序的子序列a[0...i-1]中的适当位置, 知道全部记录插入完成为止(i==n为止).

#### 复杂度
* 时间复杂度:
    * O(n^2)
* 空间复杂度:
    * O(1)

### 二、基础: 有序列表插入单个元素

```
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
    // a[n-1]为乱序，a[0...n-2]为有序
    for (int j=n-1; j>0; j--) {
        if (a[j] < a[j-1])
            swap(a[j], a[j-1]);
    }
}
```

### 三、解题方法

#### (1)、循环法(默认从小到大排序)

* 设数组为a[0...n-1]
    * Step 1: 初始时, a[0]自成1个有序子序列, 无序区为a[i...n-1].令i=1
    * Step 2: (有序列表插入一个元素)将a[i]插入当前有序子序列a[0...i-1]中，形成a[0...i]的有序子序列;此时无序区为a[i+1...n-1], i=i+1, 执行第三步
    * Step 3: 循环重复第二步,知道i==n-1,排序完成

```c

/* 以下两个有序列表插入元素的方法 */

/**
  有序列表插入元素1:
    将a[i]插入已经排好序的序列a[0...i-1]中，形成有序的a[0...i]
        start = 0; // 默认第一个元素
        end = i - 1; // a[0...i-1]中的最后一个元素a[i-1]的下标
        wait = i; // 等待插入的元素
*/
void insertAndSort(int a[], int start, int end, int wait) {
    // 在 j 从 end -> start 中
    for (int j=end; j>=start; j--)
        // 如果 a[wait] 大于 a[j], 那么对于有序列表来说j前面的都比wait小，
        // j是比wait小的最后一位,
        // 也就是wait前(0...j)都比wait小，wait后(j+1...n-1)都比wait大, 
        // (从小到大排序)说明wait应该排在j后面以为,也就是j+1位,
        // 但是前提要先把j+1到end后移一位
        if (a[wait] > a[j])
            break;

    // 将j+1到end后移一位
    for (int k=end; k>j; k++)
        a[k+1] = a[k];

    // wait排在j后面一位
    a[j+1] = a[wait];
}


/*
  有序列表插入元素2:
    1.假设有序列表a原来有m-1个元素(0...m-2), 插入一个元素x以后，最终有m个元素(0...m-1); 
    2.那么不妨在插入之前，将x写成a[m-1]=x (总共m个元素, m-1是最后一个元素);
    3.这时也就是将a[m-1]插入到a[0...m-2]之间了.
    4.又因为a[0...m-2]已经是排好序的有序列表, 假设最后一个元素j=m-1, 也即a[0...j-1]是有序的, 那么只要
        * 如果a[j] > a[j-1], 说明a[0...j]这m个元素已经是有序的了,跳出
        * 如果a[j] < a[j-1], 说明后一个元素比前一个元素小，只要交换即可; 然后j=j-1, 重复重复该步骤(4)
*/
void InsertAndSort(int a[], int i) {
    // 总共i个元素, a[i-1]是最后一个元素
    for (int j=i-1; j>0; j--) {
        if (a[j] < a[j-1])
            swap(a[j], a[j-1]);
    }
}

/* 直接插入排序 */
void InsertSort(int a[], int n) {
    int i, j, k;
    // Step 1, Step 3
    for (i=1; i<n; ++i) {
        // Step 2: 有序列表插入元素

        // 有序列表插入元素1: 比较笨，找到中间并后移
        //  insertAndSort(a, 0, i-1, i);

        // 有序列表插入元素2: 比较灵活, 将a[0..i]个元素从后往前交换
        insertAndSort(a, i+1);
    }
}
```

#### (2)、递归法

```
/**
    数组a, 有n个元素, a[0...n-1]
*/
void InsertSort(int a[], int n) {
    if (n == 1)
        return ;
    // 递归分治
    InsertSort(a, n-1);
    // 主要插入有序列表动作
    SortedListInsertElement(a, n);
}
```

### 四、总结
* 掌握有序列表插入一个元素是基础，但很重要，初学仔细体会.
