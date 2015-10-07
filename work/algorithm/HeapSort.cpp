/****************************************************
  > File Name    : HeapSort.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月07日 星期三 13时11分25秒
 ****************************************************/

#include <iostream>
#include "display.h"
using namespace std;

/* 最小堆的插入操作的上调整
 * array: 存放堆的数组，简称堆
 * child_id: 新加入的子结点，也就是有效数组的最后一个节点
 * parent_id: 子结点child_id的父结点
 * */
void MinHeapFixup(int array[], int child_id) {
    // 计算子结点child_id的父结点
    int parent_id = (child_id - 1) / 2;

    // 如果子结点为父结点，即这个堆只有一个节点，不用插入了
    // 如果子结点的父结点小于0, 说明该子节点child_id已经是父结点，和上一条重复了
    // 所以实际上只要一个条件: parent_id >= 0
    while (child_id != 0 && parent_id >= 0) {
        // 原来的堆本来是完整的，所以如果插入的子结点的值
        //   如果比它的父结点大于或等于, 说明现在的堆仍然是完整的.
        if (array[parent_id] <= array[child_id])
            break;
        //   如果比它的父结点小，则发生调整，交换即可构成堆.
        Swap(array[parent_id], array[child_id]);
        // 只有发生调整时才要逐级调整
        // 现在从要调整的"新子结点"为原来的父结点
        child_id = parent_id;
        // 然后查找"新子结点"的父结点
        parent_id = (child_id - 1)/2;
    }
}

/*
 * @description 堆的插入操作
 *
 * @param array 存放数组的堆，简称堆
 * @param len   原数组的有效长度
 * @insertChild 插入子结点的值
 * @return 
 * */
void MinHeapAddNumber(int array[], int len, int insertChild) {
    // 插入子结点到数组'末尾'
    array[len] = insertChild;
    // 重新自底向上调整堆
    MinHeapFixup(array, len);
}

/**
 * @desc 堆删除操作后的从节点parentId开始自顶向下调整
 * 
 * @param array 堆数组
 * @param len 删除根节点后的堆数组的长度, 此时原来的最后一个子结点已经是现在的根节点，不能算堆，所以要重新调整.
 * @param parent_id 根节点, 从parent_id节点开始向下调整
 */
void MinHeapFixdown(int array[], int len, int parentId) {
    // 理论上的左右两个子结点，不一定存在，还得和数组长度len作比较.
    int leftChildId = 2 * parentId + 1;
    // int rightChildId = 2 * parentId + 2;
    int rightChildId = leftChildId + 1;
    // 等待和父结点比较的节点的ID
    int exchangeId;

    // 最后一个节点ID: len-1 (数组长度为len, 数组下标从0开始)
    //   如果leftChildId<len, 也即leftChildId<=len-1,
    // 则说明左子结点存在, 此时右子结点还不确定
    while (leftChildId < len) {
        // 默认要要与父结点交换的结点是左子结点
        exchangeId = leftChildId;
        // 右子结点=leftChildId+1, 如果存在
        // 并且小于leftChildId的值，说明右子结点更小，可能要和根节点换.
        if (rightChildId < len && array[rightChildId] < array[leftChildId])
            exchangeId  = rightChildId;
        // 确定父结点是否要和子结点交换构成堆
        // (最小堆)如果较小的子结点比父结点大，说明已经是堆了
        if (array[exchangeId] > array[parentId])
            break;
        // 父结点和较小的节点交换
        Swap(array[parentId], array[exchangeId]);
        // 更新需要调整的"新根节点"和它的左右子结点
        parentId = exchangeId;
        leftChildId = 2 * parentId + 1;
        rightChildId = leftChildId + 1;
    }
}

/* 
 * @desc 堆删除操作后的自顶向下调整 - 去掉没用的中间变量
 *   是 MinHeapFixdown 的简化
 * */
void MinHeapFixdown__(int array[], int len, int parentId) {
    // 要和父结点交换的子结点ID: childId, 默认是左结点
    int childId = 2 * parentId + 1;
    while (childId < len) {
        // 是否存在右节点，并且右节点是否小于左结点
        // 如果满足，更新需要和父结点交换的ID: childId
        if (childId+1 < len && array[childId+1] < array[childId])
            childId++;
        // 确定父结点是否要和子结点交换构成堆
        // (最小堆)如果较小的子结点比父结点大，说明已经是堆了
        if (array[childId] > array[parentId])
            break;
        // cout << array[parentId] << " " << array[childId] << endl;
        Swap(array[parentId], array[childId]);
        parentId = childId;
        childId = 2 * parentId + 1;
    }
}

void MinHeapDeleteNumber(int array[], int len) {
    Swap(array[0], array[len-1]);
    MinHeapFixdown__(array, len-1, 0);
}

/*
 * 堆化数组:
 *  @desc 将一个非堆数组调整成堆
 * 
 *  @param array: 非标准堆数组
 *  @param len: 数组长度
 *  @return
 * */
void MakeMinHeap(int array[], int len) {
    // 默认的，我们必须从最后一个有子结点的节点开始向上调整
    // 而最后一个带有子结点的节点ID = len / 2 - 1;
    for (int i=len/2-1; i>=0; i--)
        MinHeapFixdown__(array, len, i);
}

void MinHeapSort(int array[], int len) {
    // 在排序前必须进行堆化数组, 构成堆以后再继续从最后一个节点开始修正
    MakeMinHeap(array, len);
    cout << "MinHeap: ";
    display(array, len);
    // 每次将堆的根节点(最小)放在数组相对最后面, 构成递减序列
    // 而将根节点放在相对最后面用的是:
    //     根节点和相对最后一个元素然交换, 就相当于堆的删除操作(后重新构成堆)，但并非真的删除.
    cout << "每次堆化后根节点: " << array[0] << endl;
    for (int i=len-1; i>=1; i--) {
        // cout << array[i] << " " << array[0] << endl;
        Swap(array[i], array[0]);
        MinHeapFixdown__(array, i, 0);
        cout << "每次堆化后根节点: " << array[0] << endl;
    }
}

void test() {
    int a[] = {9, 12, 17, 30, 50, 20, 60, 65, 4, 19};
    int len = sizeof(a) / sizeof(int);
    cout << "Source: ";
    display(a, len);
    // MakeMinHeap(a, len);
    MinHeapSort(a, len);
    cout << "After MinHeapSort: ";
    display(a, len);
}

int main (int argc, char* argv[]) {
    test();
    return 0;
}
