SUMMARY = "A console development image with some C/C++ dev tools"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

IMAGE_FEATURES += "package-management"
IMAGE_LINGUAS = "en-us"

inherit image

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    packagegroup-core-boot \
    term-prompt \
    tzdata \
    u-boot-scr \
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
    wpa-supplicant \
"

DEV_SDK_INSTALL = " \
    binutils \
    binutils-symlinks \
    coreutils \
    cpp \
    cpp-symlinks \
    diffutils \
    elfutils \
    file \
    gcc \
    gcc-symlinks \
    gdb \
    g++ \
    g++-symlinks \
    gettext \
    git \
    ldd \
    libstdc++ \
    libstdc++-dev \
    libtool \
    ltrace \
    make \
    nasm \
    perl-modules \
    pkgconfig \
    python-modules \
    python3-modules \
    strace \
"

DEV_EXTRAS = " \
    ntp \
    ntp-tickadj \
    serialecho \
"

EXTRA_TOOLS_INSTALL = " \
    bzip2 \
    curl \
    dosfstools \
    e2fsprogs-mke2fs \
    ethtool \
    fbset \
    findutils \
    i2c-tools \
    iperf3 \
    iproute2 \
    iptables \
    less \
    netcat \
    parted \
    procps \
    root-upgrader \
    sysfsutils \
    tcpdump \
    util-linux \
    util-linux-blkid \
    unzip \
    wget \
    zip \
"

IMAGE_INSTALL += " \
    ${CORE_OS} \
    ${DEV_SDK_INSTALL} \
    ${DEV_EXTRAS} \
    ${EXTRA_TOOLS_INSTALL} \
    ${KERNEL_EXTRA_INSTALL} \
    ${WIFI_SUPPORT} \
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

create_opt_dir() {
    mkdir -p ${IMAGE_ROOTFS}/opt
}

ROOTFS_POSTPROCESS_COMMAND += " \
    remove_blacklist_files ; \
    set_local_timezone ; \
    disable_bootlogd ; \
    create_opt_dir ; \
"

export IMAGE_BASENAME = "console-image"
