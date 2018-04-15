SUMMARY = "A mender testing image"
HOMEPAGE = "http://www.jumpnowtek.com"

IMAGE_FEATURES += "package-management"
IMAGE_LINGUAS = "en-us"

inherit core-image

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    term-prompt \
    tzdata \
"

KERNEL_EXTRA_INSTALL = " \
    kernel-modules \
"

WIFI_SUPPORT = " \
    bcm4329-nvram-config \
    bcm4330-nvram-config \
    crda \
    iw \
    rfkill \
    wireless-tools \
    wpa-supplicant \
"

DEV_EXTRAS = " \
    ntp \
    ntp-tickadj \
"

EXTRA_TOOLS_INSTALL = " \
    bzip2 \
    ethtool \
    findutils \
    i2c-tools \
    iperf3 \
    iproute2 \
    less \
    netcat \
    procps \
    sysfsutils \
    tcpdump \
    unzip \
    util-linux \
    wget \
    zip \
"

QT_RUNTIME = " \
    qtbase \
    qtbase-plugins \
    qt5-env \
"

SYNTRO = " \
    syntrocore \
    syntrolcam \
    syntrolcam-init \
"

MENDER_EXTRA += " \
    mender-sysvinit \
    state-scripts \
    u-boot-fw-utils \
"

IMAGE_INSTALL += " \
    ${CORE_OS} \
    ${DEV_EXTRAS} \
    ${EXTRA_TOOLS_INSTALL} \
    ${KERNEL_EXTRA_INSTALL} \
    ${MENDER_EXTRA} \
    ${QT_RUNTIME} \
    ${SYNTRO} \
    ${WIFI_SUPPORT} \
"

set_local_timezone() {
    ln -sf /usr/share/zoneinfo/EST5EDT ${IMAGE_ROOTFS}/etc/localtime
}

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

ROOTFS_POSTPROCESS_COMMAND += " \
    set_local_timezone ; \
    disable_bootlogd ; \
 "

export IMAGE_BASENAME = "mender-syntro-image"

