require linux-stable.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

COMPATIBLE_MACHINE = "wandboard"

KERNEL_DEVICETREE ?= " \
    imx6dl-wandboard-revb1.dtb \
    imx6q-wandboard-revb1.dtb \
"

LINUX_VERSION = "6.1"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "6.1.15"
SRCREV = "42616e0f09fb4e9a6c59892a227f7bdefbd2d6d3"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
"
