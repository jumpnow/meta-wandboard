require u-boot.inc

PV = "2017.11"

COMPATIBLE_MACHINE = "wandboard"

SRCREV = "c253573f3e269fd9a24ee6684d87dd91106018a5"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
"

SPL_BINARY = "SPL"
