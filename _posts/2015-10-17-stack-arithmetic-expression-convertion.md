---
layout: post
title: "表达式转换 - 中缀表达式->后缀表达式"
keywords: [""]
description: ""
category: algorithm
tags: [algorithm, 数据结构, stack]
---
{% include JB/setup %}

### 一、原理

### 二、步骤
* Step 1: 从左向右开始扫描中缀表达式
* Step 2: 如果是数字或字母，直接输出 或者 存取在其他地方
* Step 3: 遇到运算符时, 3 IF
    * 若为'('或栈空, 入栈;
    * 若为')', 出栈直到'('为止;
    * 若为其他, 比较运算符优先级, 
        * 如果栈非空并且tmpC<=栈顶元素，栈顶元素出栈；
        * 比较下一个栈顶元素, 直到栈空或左括号;
        * 最后将tmpC入栈.

### 三、实现

```c
nfixExpression2Postfix(string s) {
    // 用于临时存放操作符的栈
    stack<char> operatorStack;
    
    // Step 1: 从左向右开始扫描中缀表达式
    for (int i=0; i<s.length(); ++i) {
        char tmpChar = s[i];
        // Step 2: 如果是数字或字母，直接输出 或者 存取在其他地方
        if (isAlphaOrNumber(tmpChar)) {
            cout << tmpChar;
            continue;
        }

        // Step 3: 遇到运算符时, 3 IF
        //  若为'('或栈空, 入栈;
        //  若为')', 出栈直到'('为止;
        //  若为其他, 比较运算符优先级, 
        //    [  如果tmpC优先级>栈顶符号优先级，入栈;
        //      否则，从栈顶开始，依次弹出与tmpC比较, 
        //    直到tmp优先级>栈顶元素优先级或者栈空或者遇到一个左括号为止.
        //    优先级: */ > +- > ()]
        //    --> 思想转换: 如果栈非空并且tmpC<=栈顶元素，栈顶元素出栈；
        //                比较下一个栈顶元素, 直到栈空或左括号;
        //                最后将tmpC入栈.
        //    
        // IF 1  
        if (operatorStack.empty() || '(' == tmpChar) {
            operatorStack.push(tmpChar);
            continue;
        }
        // IF 2
        if (')' == tmpChar) {
            while (operatorStack.top() != '(') {
                cout << operatorStack.top();
                operatorStack.pop();
            }
            operatorStack.pop();
            continue;
        } 
        // IF 3
        /*
        if (highPriority(tmpChar, operatorStack.top())) {
            operatorStack.push(tmpChar);
        } else {
            while(! operatorStack.empty() && \
                    ! highPriority(tmpChar, operatorStack.top())) {
                cout << operatorStack.top();
                operatorStack.pop();
            }
            operatorStack.push(tmpChar);
        }*/
        while (! operatorStack.empty() && \
        // highPriority(a, b)
        //  如果a优先级高于b, true; 否则, false
                !highPriority(tmpChar, operatorStack.top())) {
            cout << operatorStack.top();
            operatorStack.pop();
        }
        operatorStack.push(tmpChar);
    }
    
    // Step 4: 当扫描的中缀表达式结束时，栈中的所有运算符依次输出加入后缀表达式
    while (! operatorStack.empty()) {
        cout << operatorStack.top();
        operatorStack.pop();
    }

    cout << endl;
}
```

### 四、[例子]({{site.url}/work/algorithm/Stack-1-Arithmetic-Expression-Conversion.cpp})
