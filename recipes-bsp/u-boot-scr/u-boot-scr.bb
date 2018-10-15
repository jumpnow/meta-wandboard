SUMMARY = "U-boot boot script for wandboards"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
COMPATIBLE_MACHINE = "wandboard"

DEPENDS = "u-boot-mkimage-native"

SRC_URI = "file://boot.cmd \
           file://upgrader-boot.cmd \
          "

do_compile() {
    if [ -n "${SD_UPGRADER_BOOT}" ]; then
        mkimage -A arm -T script -C none -n "Boot script" -d "${WORKDIR}/upgrader-boot.cmd" boot.scr
    else
        mkimage -A arm -T script -C none -n "Boot script" -d "${WORKDIR}/boot.cmd" boot.scr
    fi
}

do_install() {
    install -d ${D}/boot
    install -m 0644 boot.scr ${D}/boot
}

FILES_${PN} = "/boot"
