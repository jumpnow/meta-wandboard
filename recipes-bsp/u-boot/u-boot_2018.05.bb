HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

require recipes-bsp/u-boot/u-boot.inc

COMPATIBLE_MACHINE = "wandboard"

UBOOT_LOCALVERSION = "-jumpnow"

PV = "2018.05"

# FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-${PV}:"

SRCREV = "ec5c4a8fd64a178a4d159917cda0aa176e5a9be5"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
"

S = "${WORKDIR}/git"

UBOOT_SUFFIX = "img"
SPL_BINARY = "SPL"
