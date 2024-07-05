require linux-stable.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

COMPATIBLE_MACHINE = "wandboard"

KERNEL_DEVICETREE ?= " \
    nxp/imx/imx6dl-wandboard-revb1.dtb \
    nxp/imx/imx6q-wandboard-revb1.dtb \
"

LINUX_VERSION = "6.9"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "6.9.8"
SRCREV = "2106717b5214895a29c038b37f15d78a3202aa2b"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
"
