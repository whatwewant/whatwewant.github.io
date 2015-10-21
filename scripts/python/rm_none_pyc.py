#!/usr/bin/env python
# coding=utf-8
# *************************************************
# File Name    : rm_none_pyc.py
# Author       : Cole Smith
# Mail         : tobewhatwewant@gmail.com
# Github       : whatwewant
# Created Time : 2015年10月21日 星期三 15时11分46秒
# *************************************************

import os
from os import listdir
from os import remove

ignorefad = [
    'rm_none_pyc.py',
]


count = 0
def rm(base_name):
    if base_name.find('.') != -1 and not base_name.startswith('.'):
        print('Error: Base Name Error: %s' % base_name)
        return 
    py = base_name + '.py'
    pyc = base_name + '.pyc'
    pyo = base_name + '.pyo'
    if os.path.exists(py) and os.path.exists(pyc):
        global count
        count += 1
        print('Remove [%s]: %s' % (count, py))
        remove(py)

def recursion(path='.'):
    fad = os.listdir(path)
    # print(fad)
    for fd in fad:
        # ignore files or dirs
        if fd in ignorefad:
            continue
        child = os.path.join(path, fd)
        if os.path.isfile(child):
            rm(os.path.join(path, fd.split('.')[0]))
            # continue
        if os.path.isdir(child):
            recursion(child)

def main():
    print('start ...')
    recursion('.')
    if count == 0:
        print('No Files And Dirs.')
    print('done.')

if __name__ == '__main__':
    main()
