LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb"

COMPATIBLE_MACHINE = "wandboard-quad"

PROVIDES += "u-boot"

PR = "r1"

# These have no affect, though they are what I want 
# Had to use forcevariable in local.conf instead 
UBOOT_SUFFIX = "img"
UBOOT_MAKE_TARGET = "all"
SPL_BINARY = "SPL"

require ${COREBASE}/meta/recipes-bsp/u-boot/u-boot.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}/git"

PV = "2013.10"

SRCREV = "7440dc4a478ee7fc5ec75c0efda620feef94230f"
SRC_URI = "git://github.com/scottellis/u-boot-2013.10-wand.git"

