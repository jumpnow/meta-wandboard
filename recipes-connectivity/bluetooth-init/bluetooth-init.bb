DESCRIPTION = "Startup script to bring up bluetoothd and rfcomm"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "bluez4"

inherit update-rc.d

INITSCRIPT_NAME = "bluetooth"
INITSCRIPT_PARAMS = "start 97 5 . stop 2 0 6 1 ."

SRC_URI = " \
            file://init \
            file://rfcomm.conf-example \
            file://default \
          "

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0744 init ${D}${sysconfdir}/init.d/bluetooth

    install -d ${D}${sysconfdir}/bluetooth/
    install -m 0644 rfcomm.conf-example ${D}${sysconfdir}/bluetooth/rfcomm.conf-example

    install -d ${D}${sysconfdir}/default/
    install -m 0644 default ${D}${sysconfdir}/default/bluetooth
}


FILES_${PN} = "${sysconfdir}"

