require linux-stable.inc

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

COMPATIBLE_MACHINE = "wandboard"

KERNEL_DEVICETREE ?= " \
    imx6q-wandboard.dtb \
    imx6q-wandboard-revb1.dtb \
    imx6q-wandboard-revd1.dtb \
    imx6qp-wandboard-revd1.dtb \
    imx6dl-wandboard.dtb \
    imx6dl-wandboard-revb1.dtb \
    imx6dl-wandboard-revd1.dtb \
"

LINUX_VERSION = "5.3"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "5.3.0"
SRCREV = "4d856f72c10ecb060868ed10ff1b1453943fc6c8"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
"
