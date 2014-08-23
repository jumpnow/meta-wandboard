#!/bin/bash
#

MACHINE=wandboard-quad

if [ "x${1}" = "x" ]; then
	echo -e "\nUsage: ${0} <block device>\n"
	exit 0
fi

DEV=/dev/${1}

if [ ! -b $DEV ]; then
	echo -e "\nBlock device not found: ${DEV}\n"
	exit 0
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

if [ ! -f ${SRC}/u-boot-${MACHINE}.imx ]; then
	echo -e "File not found: ${SRC}/u-boot-${MACHINE}.imx\n"
	exit 1
fi

if [ ! -f ${SRC}/zImage-${MACHINE}.bin ]; then
	echo -e "File not found: ${SRC}/zImage-${MACHINE}.bin\n"
	exit 1
fi

if [ ! -f ${SRC}/zImage-imx6q-wandboard.dtb ]; then
	echo -e "File not found: ${SRC}/zImage-imx6q-wandboard.dtb\n"
	exit 1
fi


echo "Using dd to copy u-boot to unpartitioned space"
sudo dd if=${SRC}/u-boot-${MACHINE}.imx of=${DEV} conv=notrunc seek=2 skip=0 bs=512

echo -e "\nFormatting FAT partition on ${DEV}1 \n"
sudo mkfs.vfat ${DEV}1 -n BOOT

echo "Mounting ${DEV}1"
sudo mount ${DEV}1 /media/card

echo "Copying zImage"
sudo cp ${SRC}/zImage-${MACHINE}.bin /media/card/zImage

echo "Copying dtb"
sudo cp ${SRC}/zImage-imx6q-wandboard.dtb /media/card/imx6q-wandboard.dtb

echo "Unmounting ${DEV}1"
sudo umount ${DEV}1

echo "Done"

