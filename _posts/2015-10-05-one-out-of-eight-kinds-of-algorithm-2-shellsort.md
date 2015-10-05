---
layout: post
title: "八种排序算法之2 希尔排序(Shell Sort)"
keywords: [""]
description: ""
category: "algorithm"
tags: [shellsort, sort, algorithm]
---
{% include JB/setup %}

### 一、基本思想
* 希尔排序是插入排序的一种改进算法, 是非稳定排序.

```bash
    先将整个代拍元素序列分割成若干个子序列(由相隔某个"增量"的元素组成的)分别进行直接插入排序, 
    然后一次缩减增量再进行排序，
    待整个序列中的元素基本有序(增量足够小)时, 再对全体元素进行一次直接插入排序;
    (因为直接插入排序在元素基本有序的情况下(接近最好情况), 效率是很高的，因此希尔排序在时间效率上，比直接插入排序要好很多.)
```

### 二、基础
* [直接插入排序]({{site.url}}/2015/10/04/One-out-of-eight-kinds-of-algorithm-1-insertsort.html)

### 三、解题方法

```c
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
            // 最后一个无序变量
            temp = array[i];
            // 插入到前面i/gap个元素的有序列表中, 变成i/gap+1个元素的有序列表
            // 如果 gap = 1, 则是最后一步，也就是整个数组直接插入排序
            for (j=i-gap; j>0 && temp<array[j]; j-=gap)
                array[j+gap] = array[j];
            array[j+gap] = temp;
        }
    }
}
```

### 四、总结

```
    希尔排序其实就是分gap次(2^gap<=len), 每次new_gap(=gap, gap/=2)个分组的直接插入排序,最终new_gap=1时，就是最直接的直接插入排序.
```

### 参考
* [白话经典算法系列之三 希尔排序的实现](http://blog.csdn.net/morewindows/article/details/6668714)
* [维基百科-希尔排序](https://zh.wikipedia.org/wiki/希尔排序)
