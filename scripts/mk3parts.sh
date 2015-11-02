#!/bin/bash
#
# Format an SD card for the Wandboard O/S
#
# This script creates a third partition with all space after 2GB
#

function ver() {
	printf "%03d%03d%03d" $(echo "$1" | tr '.' ' ')
}

if [ -n "$1" ]; then
	DRIVE=/dev/$1
else
	echo -e "\nUsage: sudo $0 <device>\n"
	echo -e "Example: sudo $0 sdb\n"
	exit 1
fi

if [ "$DRIVE" = "/dev/sda" ] ; then
	echo "Sorry, not going to format $DRIVE"
	exit 1
fi


echo -e "\nWorking on $DRIVE\n"

#make sure that the SD card isn't mounted before we start
if [ -b ${DRIVE}1 ]; then
	umount ${DRIVE}1
	umount ${DRIVE}2
	umount ${DRIVE}3
elif [ -b ${DRIVE}p1 ]; then
	umount ${DRIVE}p1
	umount ${DRIVE}p2
	umount ${DRIVE}p3
else
	umount ${DRIVE}
fi


SIZE=`fdisk -l $DRIVE | grep "Disk $DRIVE" | cut -d' ' -f5`

echo DISK SIZE – $SIZE bytes

if [ "$SIZE" -lt 4000000000 ]; then
	echo "Require an SD card of at least 4GB"
	exit 1
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
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

# Create three partitions
# Sectors are 512 bytes
# 0-8191: 4MB Not formatted, u-boot
# 8192-24575: 8MB, DOS partition, kernel
# 24576-4194303: ~2GB, Linux partition, rootfs
# 4194304-end: 2GB+, Linux partition, empty

echo -e "\n=== Creating 3 partitions ===\n"
{
echo 8192,16384,0x0C,*
echo 24576,4169728,0x83,-
echo 4194304,+,0x0C,-
} | $SFDISK_CMD $DRIVE


sleep 1

echo -e "\n=== Done! ===\n"

