#!/bin/bash

MACHINE=wandboard

if [ "x${1}" = "x" ]; then
    echo -e "\nUsage: ${0} <block device>\n"
    exit 0
fi

if [ -b ${1} ]; then
    DEV=${1}
elif [ -b "/dev/${1}" ]; then
    DEV=/dev/${1}
else
    echo "Block device not found: /dev/${1}"
    exit 1
fi

echo -e "MACHINE: $MACHINE\n"

if [ -z "$OETMP" ]; then
    echo -e "\nWorking from local directory"
    SRC=.
else
    echo -e "\nOETMP: $OETMP"

    if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
        echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
        exit 1
    fi

    SRC=${OETMP}/deploy/images/${MACHINE}
fi 

if [ ! -d /media/card ]; then
    echo "Temporary mount point [/media/card] not found"
    exit 1
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
