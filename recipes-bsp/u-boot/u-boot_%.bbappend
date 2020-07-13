FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "\
    git://git.denx.de/u-boot.git \
    file://0001-Add-FAT-write-support.patch \
"

# v2020.07
PV="2020.07"
SRCREV="2f5fbb5b39f7b67044dda5c35e4a4b31685a3109"

UBOOT_LOCALVERSION = "-jumpnow"

UBOOT_SUFFIX = "img"
SPL_BINARY = "SPL"
