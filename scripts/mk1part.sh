#!/bin/bash
#
# Create 1 partition for a Wandboard O/S
#

function ver() {
        printf "%03d%03d%03d" $(echo "$1" | tr '.' ' ')
}

if [ -n "$1" ]; then
	DEV=/dev/$1
else
	echo -e "\nUsage: sudo $0 <device>\n"
	echo -e "Example: sudo $0 sdb\n"
	exit 1
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep ${1}
    exit 1
fi

echo -e "\nWorking on $DEV\n"

#make sure that the SD card isn't mounted before we start
if [ -b ${DEV}1 ]; then
	umount ${DEV}1
	umount ${DEV}2
elif [ -b ${DEV}p1 ]; then
	umount ${DEV}p1
	umount ${DEV}p2
else
	umount ${DEV}
fi

# new versions of sfdisk don't use rotating disk params
sfdisk_ver=`sfdisk --version | awk '{ print $4 }'`

if [ $(ver $sfdisk_ver) -lt $(ver 2.26.2) ]; then
	CYLINDERS=`echo $SIZE/255/63/512 | bc`
	echo CYLINDERS – $CYLINDERS
	SFDISK_CMD="sfdisk --force -D -uS -H255 -S63 -C ${CYLINDERS}"
else
	SFDISK_CMD="sfdisk"
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DEV bs=1024 count=1024

# Create 1 partition
# Sectors are 512 bytes
# 0-8191: 4MB Not formatted, u-boot
# 8192-end: Linux partition, rootfs

echo -e "\n=== Creating 1 partition ===\n"
{
echo 8192,,,*
} | $SFDISK_CMD $DEV


sleep 1

echo -e "\n=== Done! ===\n"

