/****************************************************
  > File Name    : Stack-1-Arithmetic-Expression-Conversion.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月16日 星期五 23时40分32秒
  > Description  : 
    算术表达式转换之
        中缀表达式 -> 后缀表达式
 ****************************************************/

#include <iostream>
#include <stack>
#include <string>
using namespace std;

/**
 * @Desc    判断tmpC是不是字母或数字
 * @param   char
 * @return  是字母或数组, true; Or, false;
 */
bool isAlphaOrNumber(char tmpC) {
    if (tmpC>='0' && tmpC<='9' ||\
            tmpC>='a' && tmpC<='z' || \
            tmpC>='A' && tmpC<='Z')
        return true;
    return false;
}

char LEVEL[100];
/**
 * @Desc 判断符号a的优先级是否高于b
 * @param char 符号a
 * @param char 符号b
 * @return true/false
 */
bool highPriority(char a, char b) {
    LEVEL['+'] = LEVEL['-'] = 1;
    LEVEL['*'] = LEVEL['/'] = 2;
    LEVEL['('] = 0;
    // LEVEL[')'] = 0;
    return LEVEL[a] > LEVEL[b];
}

void InfixExpression2Postfix(string s) {
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

int main (int argc, char* argv[]) {
    string s = "a+b-a*((c+d)/e-f)+g";
    // string s = "a/b+(c*d-e*f)/g";
    // string s;
    // cin >> s;
    InfixExpression2Postfix(s);
    return 0;
}
