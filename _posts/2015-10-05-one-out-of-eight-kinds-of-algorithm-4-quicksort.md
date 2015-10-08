---
layout: post
title: "八种排序算法之4 快速排序(Quick Sort)"
keywords: [""]
description: ""
category: "algorithm"
tags: [quicksort, sort, algorithm]
---
{% include JB/setup %}

### 一、基本思想
* (`挖坑填数` + `分治法(Divide and Conquer Method)`)
* 1、先从数列中取出一个数作为基准数
* 2、分区过程，将比这个数大或者等于的数全放到它右边，小它的数全部放到它的左边
* 3、再对左右区间重复第二步，知道各区间只有一个数.

#### 复杂度
* 时间复杂度
    * O(NlogN), 效率较高

### 二、基础: 分治法
* 分治法(Divide And Conquer Method)
* `待续: 独立一篇文章写写`
* 写好了: [分治法]({{site.url}}/2015/10/08/divide-and-conquer-method.md)

### 三、解题方法

#### (1)调整数组: 挖坑填数思想

```c
/* 挖坑填数部分: (其实只是一轮左小右大的排序, 调整数组, 确定基准数作为相对中间数)
     1. i=left, j=right; 将基准数middle(=a[i])挖出形成第一个坑a[i]
     2. 找小: j--由后往前找比它小的数，找到后挖出此数a[j]填到前一个坑a[i]中, 此时新坑是a[j];
     3. 找大: i++由前往后找比它大的数, 找到后挖出次数a[i]填到前一个坑a[j]中, 此时新坑是a[i];
     4. 再从夫执行2, 3步骤知道i==j, 然后将基准数填入a[i]中.
*/
/*
 * Array: 数组
 * left: 希望被排序的起始位置
 * right: 希望被排序的末尾位置
 * 因此: left和right可对数组部分调整
 * 当left=0 且 right=len-1时，则是对整个数组Array调整.
 *  该函数有两个作用:
 *      1.一轮下来，将数组分为左小右大两部分，自然基准数就是相对中间数了, 接下来只要分别对左右两半分别继续调整即可
 *      2.返回基准数最终存放的位置, 为的是区分左右两半部分
 * */
int AdjustArray(int array[], int left, int right) {
    int i=left, j=right;
    // 基数middle(=a[i]=a[left]确定, 第一个坑a[i]挖好
    int middle = array[i]; /* 选择左边第一个数作为基准数 */
    while (i < j) {
        // 从右到左找小, 要填到左边坑a[i]中
        // 注意条件: array[j]大于等于middle
        while (i<j && array[j] >= middle)
            j--;
        // 找到比基准数小的a[j]
        if (i < j) {
            array[i] = array[j]; // 此时坑a[i]已经填上a[j], a[j]为新坑
            i++; // 因为当前a[i]位置的值a[j], 是和基准数middle比较过的，所以只需要从i的下一位开始
        }

        // 从左往右找大, 要填到右边坑a[j]中
        while (i<j && array[i] < middle)
            i++;
        // 找到比基准数大的a[i]
        if (i < j) {
            array[j] = array[i]; // 此时坑a[j]已经填上a[j], a[i]为新坑
            j--; // 因为a[j]位置的值a[i], 已经和基准数比较，所以只需要从j的下一位开始
        }
    }

    array[i] = middle;
    return i;
}

/*
 * Array: 数组
 * left: 希望被排序的起始位置
 * right: 希望被排序的末尾位置
 * 因此: left和right可对数组部分排序
 * 当left=0 且 right=len-1时，则是对整个数组Array排序.
 * */
void QuickSort(int array[], int left, int right) {
    // 只有当数组范围大于1的时候才进行调整
    // 否则，单个元素本身就是有序，无需调整
    if (left < right) {
        // 一轮调整, i左边的都比a[i]小, i右边的都比a[i]大
        // i 为基准数一轮后存放的位置
        int i = AdjustArray(array, left, right);
        // 分治
        // 由于i左边, 即left->i-1, 都比a[i]小但是顺序不确定, 以同样的方法调整左小右大两部分,但缩小范围, 只左边
        QuickSort(array, left, i-1);
        // 由于i右边, 即i+1->right, 都比a[i]大但无序, 以用样方法调整成左小右大两部分,但范围只有右半部分
        QuickSort(array, i+1, right);
    }
}
```

#### (2)调整数组: 交换位置思想

```c
/*
    由于右边的坑总是填左边的坑，也就是相当于先找到右边的坑，然后找到左边的坑，接着相互交换位置，然后重复这一步即可
*/
int AdjustArrayEmiddlechange(int array[], int left, int right) {
    int i=left, j=right;
    // 基准数middle
    int middle = array[i];
    while (i < j) {
        // 从右往左，直到找到比基准数middle小的数
        while (i<j && array[j]>=middle) 
            j--;
        // 由于第一个i是基准数middle的位置, 已经确定
        // 所以在找出右边的坑j后立即交换
        // 然后再更新左边的坑i
        Swap(array[j], array[i]);

        // 新一个左边的坑i
        // 从左往右，知道找到比基准数middle大或者等于的数
        while (i<j && array[i]<middle) 
            i++;
    }
    array[i] = middle;
    return i;
}
```

#### (3)调整数组: 交换位置思想二

```c
/*
    由于基本原理:(middle为基准数, i左, j右)
        a[i] >= middle, 放在右边
        a[j] <  middle, 放在左边
    为什么这么分呢?
        因为往往基准数是选择左边的第一个元素, 
        正是因为此时基准数已经是左边的第一个元素，
        所以它只能往右放, 所以是a[i]等于middle时也放在右边
        (由此，如果你选择的基准数是右边第一个元素，那么a[j]等于middle时应该放在左边, 也即a[i]>middle, 放右边; a[j]<=middle放左边.)
    
    由基本原理, 即使选择左边第一个元素作为基准数，i=left, j=right, 不妨假设左边第一个元素并不知晓，只是从数组中选择了一个基准数, 然后从头开始，先找出左边的第一个坑i, 再找出右边的第一个坑j, 然后交换.
    (与上一个交换唯一不同的就是: `默认第一个i未知`)
*/
int AdjustArrayExchange2(int array[], int left, int right) {
    int i=left, j=right;
    int middle = array[i];
    while (i < j) {
        while (i<j && array[i]<middle) i++;
        while (i<j && array[j]>=middle) j--;
        Swap(array[i], array[j]);
    }
    array[i] = middle;
    return i;
}
```

#### (4)将两个函数合并成一个

```c
void QuickSort(int array[], int left, int right) {
    int i=left, j=right;
    int middle = array[i];
    if (i < j) {
        while (i < j) {
            while (i<j && array[i]<middle) i++;
            while (i<j && array[j]>=middle) j--;
            Swap(array[i], array[j]);
        }
        array[i] = middle;
        QuickSort(array, left, i-1);
        QuickSort(array, i+1, right);
    }
}
```

### 四、总结

```bash
    挖坑思想是是关键，从挖坑法想到交换法, 分治基础不可少, 快速搞定.
```

### 五、参考
* [白话经典算法系列之六 快速排序 快速搞定](http://blog.csdn.net/morewindows/article/details/6684558)
* [维基百科-快速排序(Quick Sort)](https://zh.wikipedia.org/wiki/快速排序)
