require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "wandboard"

RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_DEVICETREE = " \
    imx6q-wandboard.dtb \
    imx6q-wandboard-revb1.dtb \
    imx6dl-wandboard.dtb \
    imx6dl-wandboard-revb1.dtb \
 "

LINUX_VERSION = "4.3"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.3:"

S = "${WORKDIR}/git"

PR = "r2"

# v4.3.3
SRCREV = "35483418917d63df90bae5b2d0b7b047d7ed8ec7"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.3.y \
    file://defconfig \
 "

