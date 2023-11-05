#!/bin/bash

mnt=/mnt

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
    # echo try to find it
    if [ -f ../../build/conf/local.conf ]; then
        OETMP=$(grep '^TMPDIR' ../../build/conf/local.conf | awk '{ print $3 }' | sed 's/"//g')

        if [ -z "$OETMP" ]; then
            OETMP=../../build/tmp
        fi
    fi
fi

echo "OETMP: $OETMP"

if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
    echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
    exit 1
fi

SRC=${OETMP}/deploy/images/${MACHINE}

echo "IMAGE: $IMAGE"

if [ "x${3}" = "x" ]; then
    TARGET_HOSTNAME=$MACHINE
else
    TARGET_HOSTNAME=${3}
fi

echo -e "HOSTNAME: $TARGET_HOSTNAME\n"

if [ ! -f "${SRC}/${IMAGE}-image-${MACHINE}.rootfs.tar.xz" ]; then
    echo -e "File not found: ${SRC}/${IMAGE}-image-${MACHINE}.rootfs.tar.xz\n"
    exit 1
fi

if [ -b ${1} ]; then
    dev=${1}
elif [ -b "/dev/${1}1" ]; then
    dev=/dev/${1}1
elif [ -b "/dev/${1}p1" ]; then
    dev=/dev/${1}p1
else
    echo "Block device not found: /dev/${1}1 or /dev/${1}p1"
    exit 1
fi

echo "Formatting $dev as ext4"
sudo mkfs.ext4 $dev

echo "Mounting $dev"
sudo mount "$dev" "$mnt"

echo "Extracting ${IMAGE}-image-${MACHINE}.rootfs.tar.xz to $mnt"
sudo tar -C "$mnt" -xJf ${SRC}/${IMAGE}-image-${MACHINE}.rootfs.tar.xz

echo "Generating a random-seed for urandom"
mkdir -p "${mnt}/var/lib/systemd"
sudo dd status=none if=/dev/urandom of="${mnt}/var/lib/systemd/random-seed" bs=512 count=1
sudo chmod 600 "${mnt}/var/lib/systemd/random-seed"

echo "Writing $TARGET_HOSTNAME to ${mnt}/etc/hostname"
export mnt
export TARGET_HOSTNAME
sudo -E bash -c 'echo ${TARGET_HOSTNAME} > ${mnt}/etc/hostname'


echo "Unmounting $dev"
sudo umount $dev

echo "Done"

