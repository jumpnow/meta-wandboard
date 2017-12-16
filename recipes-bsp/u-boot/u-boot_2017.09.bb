require u-boot.inc

PV = "2017.09"

COMPATIBLE_MACHINE = "wandboard"

UBOOT_LOCALVERSION = "-jumpnow"

SRCREV = "c98ac3487e413c71e5d36322ef3324b21c6f60f9"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
"

SPL_BINARY = "SPL"
