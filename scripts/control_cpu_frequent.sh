#!/bin/bash
# File Name: control_cpu_frequent.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2014年11月01日 星期六 22时06分16秒

export PATH=.:$PATH

# if [ "$UID" != "0" ]; then
#    echo "Need root"
#    exit -1
# fi

DefaultCPUFrequence_Min=800M
DefaultCPUFrequence_Max=1500M

which cpufreq-set >> /dev/null
if [ "$?" != "0" ]; then
    sudo apt-get install -y cpufrequtils
fi

# 

# Real Action
cpuNumber0=0
cpuNumber1=1
cpuNumber2=2
cpuNumber3=3

sudo cpufreq-set -c $cpuNumber0 -d $DefaultCPUFrequence_Min
sudo cpufreq-set -c $cpuNumber0 -u $DefaultCPUFrequence_Max
sudo cpufreq-set -c $cpuNumber1 -d $DefaultCPUFrequence_Min
sudo cpufreq-set -c $cpuNumber1 -u $DefaultCPUFrequence_Max
sudo cpufreq-set -c $cpuNumber2 -d $DefaultCPUFrequence_Min
sudo cpufreq-set -c $cpuNumber2 -u $DefaultCPUFrequence_Max
sudo cpufreq-set -c $cpuNumber3 -d $DefaultCPUFrequence_Min
sudo cpufreq-set -c $cpuNumber3 -u $DefaultCPUFrequence_Max

if [ "$?" == "0" ]; then
    echo "Success CPU Frequence: $DefaultCPUFrequence_Min - $DefaultCPUFrequence_Max"
    echo "More Infomation run command: cpufreq-info"
else
    echo "Failed to Control CPU Frequence."
fi

exit 1
