require linux-stable.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

COMPATIBLE_MACHINE = "wandboard"

KERNEL_DEVICETREE ?= " \
    imx6q-wandboard.dtb \
    imx6q-wandboard-revb1.dtb \
    imx6dl-wandboard.dtb \
    imx6dl-wandboard-revb1.dtb \
 "

LINUX_VERSION = "4.14"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "4.14.114"
SRCREV = "fa5941f45d7ed070118b7c209b7f2c3a034293bd"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
"
