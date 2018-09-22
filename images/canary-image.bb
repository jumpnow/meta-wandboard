SUMMARY = "Network canary"
HOMEPAGE = "http://www.jumpnowtek.com"

IMAGE_LINGUAS = "en-us"

inherit image

CORE_OS = " \
    openssh openssh-keygen \
    packagegroup-core-boot \
    tzdata \
    u-boot-scr \
"

KERNEL_EXTRA_INSTALL = " \
    kernel-modules \
"

EXTRA_TOOLS_INSTALL = " \
    canary-firewall \
    iptables \
    logrotate \
    ntp \
    ntp-tickadj \
    procps \
    rsyslog \
"

IMAGE_INSTALL += " \
    ${CORE_OS} \
    ${EXTRA_TOOLS_INSTALL} \
    ${KERNEL_EXTRA_INSTALL} \
"

IMAGE_FILE_BLACKLIST += " \
    /etc/init.d/hwclock.sh \
 "

remove_blacklist_files() {
    for i in ${IMAGE_FILE_BLACKLIST}; do
        rm -rf ${IMAGE_ROOTFS}$i
    done
}

set_local_timezone() {
    ln -sf /usr/share/zoneinfo/EST5EDT ${IMAGE_ROOTFS}/etc/localtime
}

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

disable_volatile_log() {
    sed -i '/volatile\/log/d' ${IMAGE_ROOTFS}/etc/default/volatiles/00_core
    rm -rf ${IMAGE_ROOTFS}/var/log
    mkdir ${IMAGE_ROOTFS}/var/log
    chmod 0755 ${IMAGE_ROOTFS}/var/log
}

ROOTFS_POSTPROCESS_COMMAND += " \
    remove_blacklist_files ; \
    set_local_timezone ; \
    disable_bootlogd ; \
    disable_volatile_log ; \
 "

export IMAGE_BASENAME = "canary-image"
