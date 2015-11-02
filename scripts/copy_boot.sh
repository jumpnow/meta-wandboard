#!/bin/bash
#

MACHINE=wandboard

DTBLIST="imx6q-${MACHINE} imx6q-${MACHINE}-revb1 imx6dl-${MACHINE} imx6dl-${MACHINE}-revb1"

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

if [ ! -f ${SRC}/zImage-${MACHINE}.bin ]; then
	echo "File not found: ${SRC}/zImage-${MACHINE}.bin"
	exit 1
fi

for dtb in ${DTBLIST}; do
	if [ ! -f ${SRC}/zImage-${dtb}.dtb ]; then
		echo "DTB file not found: ${SRC}/zImage-${dtb}.dtb"
		exit 1
	fi
done
    
echo "Using dd to copy SPL to unpartitioned space"
sudo dd if=${SRC}/SPL-${MACHINE} of=${DEV} conv=notrunc seek=2 skip=0 bs=512

echo "Using dd to copy u-boot to unpartitioned space"
sudo dd if=${SRC}/u-boot-${MACHINE}.img of=${DEV} conv=notrunc seek=69 skip=0 bs=1K

echo -e "\nFormatting FAT partition on ${DEV}1 \n"
sudo mkfs.vfat ${DEV}1 -n BOOT

echo "Mounting ${DEV}1"
sudo mount ${DEV}1 /media/card

echo "Copying zImage"
sudo cp ${SRC}/zImage-${MACHINE}.bin /media/card/zImage

for dtb in ${DTBLIST}; do
	echo "Copying ${dtb}.dtb"
	sudo cp ${SRC}/zImage-${dtb}.dtb /media/card/${dtb}.dtb
done

echo "Unmounting ${DEV}1"
sudo umount ${DEV}1

echo "Done"

