setenv bootpart 0:1
setenv bootdir /boot
setenv mmcroot /dev/mmcblk2p1 ro
setenv mmcrootfstype ext4 rootwait
setenv bootargs console=${console} root=${mmcroot} rootfstype=${mmcrootfstype}
load mmc ${bootpart} ${fdt_addr} ${bootdir}/${fdtfile}
load mmc ${bootpart} ${loadaddr} ${bootdir}/zImage
bootz ${loadaddr} - ${fdt_addr}
