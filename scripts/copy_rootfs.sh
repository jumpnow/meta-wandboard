#!/bin/bash

MACHINE=wandboard

if [ "x${1}" = "x" ]; then
    echo "Usage: ${0} <block device> [ <image-type> [<hostname>] ]"
    exit 0
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

DEV=/dev/${1}1

if [ ! -b $DEV ]; then
    echo "Block device $DEV does not exist"
    exit 1
fi

echo "Formatting $DEV as ext4"
sudo mkfs.ext4 -L ROOT $DEV

echo "Mounting $DEV"
sudo mount $DEV /media/card

echo "Extracting ${IMAGE}-image-${MACHINE}.tar.xz to /media/card"
sudo tar -C /media/card -xJf ${SRC}/${IMAGE}-image-${MACHINE}.tar.xz

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

echo "Done"

