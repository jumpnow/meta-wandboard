LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb"

require ${COREBASE}/meta/recipes-bsp/u-boot/u-boot.inc

COMPATIBLE_MACHINE = "(mx6)"

PROVIDES += "u-boot"

PV = "2013.10"
PR = "r2"

UBOOT_SUFFIX = "img"
UBOOT_MAKE_TARGET = "all"
SPL_BINARY = "SPL"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRCREV = "7440dc4a478ee7fc5ec75c0efda620feef94230f"
SRC_URI = "git://github.com/scottellis/u-boot-2013.10-wand.git"

S = "${WORKDIR}/git"

