#!/bin/bash

MACHINE=wandboard

if [ "x${1}" = "x" ]; then
    echo "Usage: ${0} <block device> [ <image-type> [<hostname>] ]"
    exit 0
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep '^/' | grep ${1}
    exit 1
fi

if [ "x${2}" = "x" ]; then
    IMAGE=console
else
    IMAGE=${2}
fi

if [ -z "$OETMP" ]; then
    echo -e "Working from local directory"
    SRC=.
else
    echo "OETMP: $OETMP"

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

echo "IMAGE: $IMAGE"

if [ "x${3}" = "x" ]; then
    TARGET_HOSTNAME=$MACHINE
else
    TARGET_HOSTNAME=${3}
fi

echo -e "HOSTNAME: $TARGET_HOSTNAME\n"

if [ ! -f "${SRC}/${IMAGE}-image-${MACHINE}.tar.xz" ]; then
    echo -e "File not found: ${SRC}/${IMAGE}-image-${MACHINE}.tar.xz\n"
    exit 1
fi

if [ -b ${1} ]; then
    DEV=${1}
elif [ -b "/dev/${1}1" ]; then
    DEV=/dev/${1}1
elif [ -b "/dev/${1}p1" ]; then
    DEV=/dev/${1}p1
else
    echo "Block device not found: /dev/${1}1 or /dev/${1}p1"
    exit 1
fi

echo "Formatting $DEV as ext4"
sudo mkfs.ext4 $DEV

echo "Mounting $DEV"
sudo mount $DEV /media/card

echo "Extracting ${IMAGE}-image-${MACHINE}.tar.xz to /media/card"
sudo tar -C /media/card -xJf ${SRC}/${IMAGE}-image-${MACHINE}.tar.xz

echo "Generating a random-seed for urandom"
mkdir -p /media/card/var/lib/urandom
sudo dd if=/dev/urandom of=/media/card/var/lib/urandom/random-seed bs=512 count=1
sudo chmod 600 /media/card/var/lib/urandom/random-seed

echo "Writing hostname to /etc/hostname"
export TARGET_HOSTNAME
sudo -E bash -c 'echo ${TARGET_HOSTNAME} > /media/card/etc/hostname'        

if [ -f ./interfaces ]; then
    echo "Writing ./interfaces to /media/card/etc/network/"
    sudo cp ./interfaces /media/card/etc/network/interfaces
fi

if [ -f ./wpa_supplicant.conf ]; then
    echo "Writing ./wpa_supplicant.conf to /media/card/etc/"
    sudo cp ./wpa_supplicant.conf /media/card/etc/wpa_supplicant.conf
fi

echo "Unmounting $DEV"
sudo umount $DEV

if [ -b "/dev/${1}3" ]; then
    DEV=/dev/${1}3
    echo "Formatting flags partition as FAT: ${DEV}"
    sudo mkfs.vfat ${DEV}
fi

if [ -b "/dev/${1}4" ]; then
    DEV=/dev/${1}4
    echo "Formatting opt partition as ext4: ${DEV}"
    sudo mkfs.ext4 -q -F ${DEV}
fi

echo "Done"

