---
layout: post
title: "栈应用 - 括号匹配"
keywords: [""]
description: ""
category: "algorithm"
tags: [algorithm, 数据结构, stack]
---
{% include JB/setup %}

### 一、原理
* 很简单，遇到左括号用栈存起来，遇到右括号就从栈取出一个比较即可.
* 特殊情况:
    * 在栈空的情况下遇到右括号肯定不匹配;
    * 在括号扫描结束的情况下，栈不为空，肯定不匹配.

### 二、步骤
* Step 1: 从左到右扫描括号字符串
* Step 2: 左括号入栈
* Step 3: 判断右括号与栈顶元素是否匹配
    * 如果存储左括号的栈空或不匹配，返回false
    * 如果匹配出栈，扫描下一个字符
* Step 4: 扫描结束后，如果栈不为空，则肯定不匹配

### 三、实现

```c
int BRACKETS_VALUE[256];

void init() {
    BRACKETS_VALUE['('] = -1; BRACKETS_VALUE[')'] = 1;
    BRACKETS_VALUE['['] = -2; BRACKETS_VALUE[']'] = 2;
    BRACKETS_VALUE['{'] = -3; BRACKETS_VALUE['}'] = 3;
}

/**
 * @Desc 括号匹配
 * @param   s 输入的括号字符串
 * @return  true 括号匹配
 *          false 括号不匹配
 */
bool BracketsMatch(char *s) {
    // 初始化BRACKETS_VALUE, 方便比较左右括号
    // 左括号为负值，右括号为正值
    // 每组括号，左右和为0
    // 用处: 只要查看左右括号和是否为0即可判断是否匹配
    init();
    // 存储左括号的栈
    stack<char> storeLeft;
    // Step 1: 从左到右扫描括号字符串
    for(int i=0; s[i]!='\0'; ++i) {
        // Step 2: 左括号入栈
        if (BRACKETS_VALUE[s[i]] < 0)
            storeLeft.push(s[i]);
        // Step 3: 右括号与栈顶元素是否匹配
        //   如果存储左括号的栈空或不匹配，返回false
        //   如果匹配出栈，扫描下一个字符
        else {
            if (storeLeft.empty() || \
                    BRACKETS_VALUE[s[i]]+BRACKETS_VALUE[storeLeft.top()]!=0)
                // 括号不匹配
                return false;
            storeLeft.pop();
        }
    }
    // Step 4: 栈是否为空 ? 匹配 : 不匹配;
    if (! storeLeft.empty())
        // 括号不匹配
        return false;
    return true;
}
```

### 四、实例
* [地址]({{site.url}}/work/algorithm/Stack-2-Bracket-Match.cpp)
