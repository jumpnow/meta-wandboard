require recipes-kernel/linux/linux-yocto.inc

COMPATIBLE_MACHINE = "wandboard"

RDEPENDS_kernel-base += "kernel-devicetree"

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

PV = "4.14.22"
SRCREV = "55b195735142c1a8ffccb21a4af0b1bd8bd4d1eb"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
"
