---
layout: post
title: "八种排序算法之5 选择排序(Select Sort)"
keywords: [""]
description: ""
category: "algorithm"
tags: [selectsort, sort, algorithm]
---
{% include JB/setup %}

### 一、基本思想
* 选择排序和冒泡排序是差不多的一种排序.
* 和冒泡选择不一样的的是, `选择排序只有在确定了最小(或最大)的数据之后，才会发生交换.`

### 二、基础
* [冒泡排序]({{site.url}}/2015/10/05/one-out-of-eight-kinds-of-algorithm-3-bubblesort.html)

### 三、解题方法

```c
/**
 * array : 数组
 * len : 数组长度
 */
void SelectSort(int array[], int len) {
    // 当前的值最小的数组下标
    int min_id;
    // 长度len的数组，排序len-1次交换就行了
    // 每次只有最小的排到相对最前面
    // i 刚好存放每次相对最小的数, 也就是要交换的数
    for (int i=0; i<len-1; ++i) {
        // 默认假设最后一个(len-1)数是最小的数
        min_id = len - 1;
        // 每次从a[i...len-1]找出相对最小值的下标只需要len-i+1步
        //
        // 这个循环就是和冒泡排序的唯一区别
        /* 
         * 冒泡排序     选择排序
         * * * * * * * * * * * *
         * 每次都交换   只有找到最小值的时候交换
         * */
        //
        for (int j=len-2; j>=i; j--) {
            // 比较出较小值
            if (array[min_id] > array[j]) {
                min_id = j;
            }
        }
        cout << "Min[" << i+1 << "]: " << array[min_id] << endl;
        // 每次和a[i]交换，a[i]此时就是相对最小值，本轮结束
        Swap(array[i], array[min_id]);
    }
}
```

### 四、总结

```bash
    与冒泡排序的唯一区别就是，只有在找到相对最小值的时候才发生交换.
```

### 五、参考
* [一步一步写算法（之选择排序）](http://blog.csdn.net/feixiaoxing/article/details/6874619)
* [维基百科-选择排序](https://zh.wikipedia.org/wiki/%E9%80%89%E6%8B%A9%E6%8E%92%E5%BA%8F)
