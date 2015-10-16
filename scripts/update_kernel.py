#!/usr/bin/env python
# coding=utf-8
# *************************************************
# File Name    : update_kernel.py
# Author       : Cole Smith
# Mail         : tobewhatwewant@gmail.com
# Github       : whatwewant
# Created Time : 2015年09月15日 星期二 09时22分15秒
# *************************************************

import sys, os
import platform
import subprocess
import traceback
try:
    from bs4 import BeautifulSoup
except :
    print("Lack Module: BeautifulSoup4")
    print("How to: pip intsall BeautifulSoup4")
    sys.exit(-1)

try:
    import requests
except :
    print("Lack Module: requests")
    print("How to: pip install requests")
    sys.exit(-1)

try:
    from downloadhelper import download
except :
    print("Lack Module: downloadhelper")
    print("How to: pip install downloadhelper")
    sys.exit(-1)

BASE_URL = 'http://kernel.ubuntu.com/~kernel-ppa/mainline/'
SRC_DIR = '/tmp'

def get_processor():
    processor = platform.processor()
    if processor in ['x86_64']:
        print("Processor: amd64")
        return 'amd64'
    print("Processor: i386")
    return 'i386'

def get_kernel_version():
    full_kernel_version = platform.release()
    if not full_kernel_version:
        print('Error: Cannot Get OS Kernel Version.')
        return None
    return full_kernel_version.split('-')[0]

def get_all_kernels():
    print("Get All Kernels ... From {0}".format(BASE_URL))
    try:
        source_html = requests.get(BASE_URL).content
    except :
        print("Failed ...")
        sys.exit(-1)
    print("Success !")

    dom = BeautifulSoup(source_html)
    trs = dom.find_all('tr')
    
    kernels = []

    for i in range(len(trs)) :
        if i in [0, 1]:
            continue
        aTag = trs[i].find('a')
        if not aTag:
            continue
        name = aTag.text.replace('/', '')
        kernels.append(name)

    return sorted(kernels, reverse=True)

def get_unstable_kernels():
    '''
        unstable: include rc*
    '''
    kernels = get_all_kernels()
    print("Get All Unstable Kernels include rc* ...")
    unstable = []
    for each in kernels:
        if not each.endswith('unstable'):
            continue
        unstable.append(each)
    return sorted(unstable, reverse=True)

def get_unstable_and_release_kernels():
    kernels = get_unstable_kernels()
    print("Get All Kernels, which are unstable bu going to release ...")
    unstable = []
    for each in kernels:
        if each.find('rc') != -1:
            continue
        unstable.append(each)
    return sorted(unstable, reverse=True)

def get_lastest_unstable_kernel():
    kernels = get_unstable_and_release_kernels()
    print("Get Lastest Unstable and to release Kernel ... ")
    if not kernels:
        print("Error: Cannot Get Unstable Kernels.Please Check Network.")
        sys.exit(-1)
    # print("Latest to release kernel: {0}".format(kernels[0]))
    latest_kernel_version = kernels[0].split('-')[0].replace('v', '')
    print("Latest to release kernel: {0}".format(kernels[0]))

    if latest_kernel_version in [get_kernel_version()]:
        print('Current Linux Kernel({0}) is Lastest!'\
                .format(latest_kernel_version))
        sys.exit(0)

    print("Current OS Kernel Version: {0}".format(get_kernel_version()))
    print("Find a new version. Going to update ...")
    return kernels[0]

def get_lastest_unstable_generic():
    name = get_lastest_unstable_kernel()
    print("Get generic files of the lastest unstable Kernel ...")
    base_url = os.path.join(BASE_URL, name)

    source_html = requests.get(base_url).content
    dom = BeautifulSoup(source_html)
    aTags = dom.find_all('a')
    generic_files = []
    for each in aTags:
        if each.text.find('all') != -1:
            generic_files.append(each.text)
            continue
        if not each.text or each.text.find('generic') == -1:
            continue
        generic_files.append(each.text)
    return (base_url, generic_files)

def get_lastest_unstable_kernel_by_system(kernel_type = 'amd64'):
    base_url, kernels = get_lastest_unstable_generic()
    print("Get kernels by processor : {0} ...".format(kernel_type))
    type_kernels = []
    for each in kernels:
        if each.find('all') != -1:
            type_kernels.append(each)
            continue
        if each.find(kernel_type) == -1:
            continue
        type_kernels.append(each)
    return (base_url, type_kernels)

def get_lastest_kernels_urls_by_system(kernel_type = 'amd64'):
    base_url, kernels = get_lastest_unstable_kernel_by_system(kernel_type)
    print("Get files url ...")
    urls = []
    for each in kernels:
        urls.append(os.path.join(base_url, each))
    return urls

def n_download(url, dist):
    return download(url, dist)

# def download_kernel(kernel_type = 'amd64', nd=n_download):
def download_kernel(nd=n_download):
    kernel_type = get_processor()
    base_url, type_kernels = \
            get_lastest_unstable_kernel_by_system(kernel_type)
    print('Downloading kernel files ...')
    print('Dir: {0}, Files: '.format(SRC_DIR))
    for each in type_kernels:
        print('    {0}'.format(each))
    files = []
    nd(os.path.join(base_url, type_kernels[0]), \
            os.path.join(SRC_DIR, type_kernels[0]))
    nd(os.path.join(base_url, type_kernels[1]), \
            os.path.join(SRC_DIR, type_kernels[1]))
    nd(os.path.join(base_url, type_kernels[2]), \
            os.path.join(SRC_DIR, type_kernels[2]))
    for f in type_kernels:
        files.append(os.path.join(SRC_DIR, f))
    return files
    
def shell(command):
    # status = subprocess.call(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    status = subprocess.call(command, shell=True)
    if status != 0:
        print("Error Code: {0}".format(status))
        return False
    return True

def install():
    kernel_files = download_kernel()
    print("Install Kernels ...")
    # os.chdir(SRC_DIR)
    # shell('sudo dpkg -i linux-*')
    for each in kernel_files:
        shell("sudo dpkg -i {0}".format(each))
    # update grub
    print("Update Grub ...")
    shell('sudo update-grub')

def main():
    # name = get_lastest_kernels_urls_by_system()
    # print(name)
    install()

if __name__ == '__main__':
    main()

