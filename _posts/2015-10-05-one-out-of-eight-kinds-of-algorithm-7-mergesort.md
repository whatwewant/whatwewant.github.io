---
layout: post
title: "八种排序算法之7 归并排序(Merge Sort)"
keywords: [""]
description: ""
category: "algorithm"
tags: [mergesort, sort, algorithm]
---
{% include JB/setup %}

### 一、基本思想
* 归并排序依赖于递归合并操作, 即将一个数组递归分成两个子数组并分别进行排序,，然后将这两个有序数组排序.

### 二、基础: `合并两个有序列表`
* 合并有序数列的效率
    * `O(n)`
* 步骤:
    * 1.申请空间，使其大小为两个已经排序序列之和，然后将待排序数组复制到该数组中.
    * 2.设定两个指针，最初位置分别为两个已经排序序列的起始位置
    * 3.比较复制数组中两个指针所指向的元素，选择相对小的元素放入到原始待排序数组中，并移动指针到下一位置
    * 4.重复步骤3直到某一指针达到序列尾.
    * 5.将另一序列剩下的所有元素直接复制到原始数组末尾

```c
/**
 * @desc 合并两个有序数组a和b到数组c, 其中c的长度为a和b长度之和.
 * @param a[]   有序数组a;
 * @param n     有序数组a的长度;
 * @param b[]   有序数组b;
 * @param m     有序数组b的长度;
 * @param c     长度等于n+m的用于存放有序列表的数组
 * @return 
 */
void MergeTwoOrderedArray(int a[], int n, int b[], int m, int c[]) {
    int i, j, k;

    // i: 循环a
    // j: 循环b
    // k: 循环c
    i = j = k = 0;
    // 从小到大排序
    // 1.两个数组逐位比较，谁小去谁, 取了以后iushanchu数列中的这个数,
    //  直到a和b中有一个有序数组为空;
    // 2.当一个数组为空时，另一个数组依然是有序的
    //  由于剩下的数组有序，则直接添加到c的末尾即可.
    while (i<n && j<m) {
        // 谁小谁NB
        if (a[i] < b[j]) {
            c[k++] = a[i++];
        } else {
            c[k++] = b[j++];
        }
    }

    // 这里两个while循环实际上只有一个进行
    // 不确定的情况下，只是为了正确性多写点代码，无他
    //  i是循环a剩下的，如果i==n, 说明a数组用完了，只有b数组的循环会进行;
    // 反之, j与b亦然.
    while (i<n)
        c[k++] = a[i++];
    while (j<m)
        c[k++] = b[j++];
}
```

### 三、解题方法

```c
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
```

### 四、总结

```
掌握分治法、两个有序序列的合并 => 归并排序.
```

### 五、参考
* [白话经典算法系列之五 归并排序的实现](http://blog.csdn.net/morewindows/article/details/6678165/)
* [浅谈算法和数据结构: 三 合并排序](http://www.cnblogs.com/yangecnu/p/Introduce-Merge-Sort.html)
