/****************************************************
  > File Name    : Stack-2-Bracket-Match.cpp
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2015年10月17日 星期六 01时14分31秒
  > Description  :
    栈运用 之 括号匹配
 ****************************************************/

#include <iostream>
#include <stack>
using namespace std;

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
                    BRACKETS_VALUE[s[i]] + BRACKETS_VALUE[storeLeft.top()] != 0)
                // 括号不匹配
                return false;
            storeLeft.pop();
        }
    }
    if (! storeLeft.empty())
        // 括号不匹配
        return false;
    // 括号匹配
    return true;
}

int main (int argc, char* argv[]) {
    // char s[] = "[([][])]";
    char s[] = "[([{()[]{}}])]";
    cout << BracketsMatch(s) << endl;
    return 0;
}
