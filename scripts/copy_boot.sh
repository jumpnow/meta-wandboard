#!/bin/bash

MACHINE=wandboard

if [ "x${1}" = "x" ]; then
    echo "Usage: ${0} <block device>"
    exit 0
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep '^/' | grep ${1}
    exit 1
fi

if [ -b ${1} ]; then
    DEV=${1}
elif [ -b "/dev/${1}" ]; then
    DEV=/dev/${1}
else
    echo "Block device not found: /dev/${1}"
    exit 1
fi

grep -q [1-9] <(echo $DEV)

if [ $? -eq 0 ]; then
   echo "Block device should not have a partition: $DEV"
   exit 1
fi

echo "MACHINE: $MACHINE"

if [ -z "$OETMP" ]; then
    echo "Working from local directory"
    SRC=.
else
    echo "OETMP: $OETMP"

    if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
        echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
        exit 1
    fi

    SRC=${OETMP}/deploy/images/${MACHINE}
fi 

if [ ! -f ${SRC}/SPL-${MACHINE} ]; then
    echo "File not found: ${SRC}/SPL-${MACHINE}"
    exit 1
fi

if [ ! -f ${SRC}/u-boot-${MACHINE}.img ]; then
    echo "File not found: ${SRC}/u-boot-${MACHINE}.img"
    exit 1
fi

echo "Using dd to copy SPL to unpartitioned space"
sudo dd if=${SRC}/SPL-${MACHINE} of=${DEV} conv=notrunc seek=2 skip=0 bs=512

echo "Using dd to copy u-boot to unpartitioned space"
sudo dd if=${SRC}/u-boot-${MACHINE}.img of=${DEV} conv=notrunc seek=69 skip=0 bs=1K

echo "Done"
