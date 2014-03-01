FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PRINC := "${@int(PRINC) + 1}"

SRC_URI += "file://avahi-daemon-conf.patch"

