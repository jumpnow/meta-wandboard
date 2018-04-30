FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2017.09:"

SRC_URI += "file://0001-Add-bootargs-setting.patch"

UBOOT_SUFFIX = "img"
SPL_BINARY = "SPL"
