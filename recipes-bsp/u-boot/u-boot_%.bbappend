FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-Add-FAT-write-support.patch"

UBOOT_LOCALVERSION = "-jumpnow"

UBOOT_SUFFIX = "img"
SPL_BINARY = "SPL"
