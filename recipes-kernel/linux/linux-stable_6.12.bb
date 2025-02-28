require linux-stable.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

COMPATIBLE_MACHINE = "wandboard"

KERNEL_DEVICETREE ?= " \
    nxp/imx/imx6dl-wandboard-revb1.dtb \
    nxp/imx/imx6q-wandboard-revb1.dtb \
"

LINUX_VERSION = "6.12"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "6.12.17"
SRCREV = "41b222412985dc8410b88fb7a0fda87e6640d4df"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
    file://0001-Remove-reference-to-local-filesystem-in-generated-co.patch \
"
