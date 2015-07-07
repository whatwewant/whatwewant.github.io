#!/bin/bash

set -e

OS_DEVICE=""
ROOT_PARTITION=""
BOOT_PARTITION=""

sudo fdisk -l | grep -i /dev/sd

echo ""
echo "**************************************************************"
echo "* Please Look carefully.                                     *"
echo "* Find out what's your Linux OS Device and Linux Partitions. *"
echo "* Necessary Partitions: OS Device and / Partition            *"
echo "*     Maybe you have /boot Partition, if you have, it must   *"
echo "**************************************************************"

read -p "OS Device(/dev/sd_): " OS_DEVICE
OS_DEVICE=$(echo ${OS_DEVICE} | sed "s/ //g")
while [ "${OS_DEVICE}" = "" ];
do
    echo "Please Becareful. Root Partition Cannot be null."
    read -p "OS Device(/dev/sd_): " OS_DEVICE
    OS_DEVICE=$(echo ${OS_DEVICE} | sed "s/ //g")
done

read -p "Root Partition(/dev/sd__): " ROOT_PARTITION
ROOT_PARTITION=$(echo ${ROOT_PARTITION} | sed "s/ //g")
while [ "${ROOT_PARTITION}" = "" ]; 
do
    echo "Please Becareful. Root Partition Cannot be null."
    read -p "Root Partition(/dev/sd__): " ROOT_PARTITION
    ROOT_PARTITION=$(echo ${ROOT_PARTITION} | sed "s/ //g")
done

read -p "Boot Partition(If you don't have it, remain blank.): " BOOT_PARTITION
# echo ${ROOT_PARTITION} | tr -s " "
BOOT_PARTITION=$(echo ${BOOT_PARTITION} | sed "s/ //g")

echo "Mount Root Partition to /mnt ..."
sudo mount /mnt ${ROOT_PARTITION}
ls /mnt | grep -i "root"
if [ "$?" != "" ];
    echo "Error ROOT PARTITION: ${ROOT_PARTITION}"
    exit -1
else
    echo "Mount Root Partition Successful"
fi

if [ "${BOOT_PARTITION}" != "" ]; then
    echo "Mount Boot Partition to /mnt/boot"
    sudo mount /mnt/boot ${BOOT_PARTITION}
    echo "Mount Boot Partition Successful"
fi

read -p "Install Grub on ${OS_DEVICE}? (y|N)" answer
answer=$(echo ${answer} | sed "s/ //g")
case ${answer:0:1} in
    y|Y)
        sudo grub-install --root-directory=/mnt ${OS_DEVICE}
        sudo mount --bind /proc /mnt/proc
        sudo mount --bind /dev /mnt/dev
        sudo mount --bind /sys /mnt/sys
        # Chroot and Update grub
        sudo chroot /mnt /usr/sbin/update-grub
        # Umount
        sudo umount --bind /sys /mnt/sys
        sudo umount --bind /dev /mnt/dev
        sudo umount --bind /proc /mnt/proc
        sudo umount /mnt/boot ${BOOT_PARTITION}
        sudo umount /mnt ${ROOT_PARTITION}
        echo "Umount Successfully..."
        echo "Congratulation! Fix Grub !"
        ;;
    *)
        echo "You say no."
        exit 0
        ;;
esac
