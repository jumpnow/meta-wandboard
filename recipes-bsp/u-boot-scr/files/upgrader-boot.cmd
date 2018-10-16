setenv bootpart 0:1
setenv flagpart 0:3
setenv bootdir /boot
setenv mmcroot /dev/mmcblk2p1 ro
setenv mmcrootfstype ext4 rootwait
if test -e mmc ${flagpart} two; then
    if test -e mmc ${flagpart} two_ok; then
        setenv bootpart 0:2
        setenv mmcroot /dev/mmcblk2p2 ro
    elif test ! -e mmc ${flagpart} two_tried; then
        fatwrite mmc ${flagpart} ${loadaddr} two_tried 4;
        setenv bootpart 0:2
        setenv mmcroot /dev/mmcblk2p2 ro
    fi;
elif test -e mmc ${flagpart} one; then
    if test ! -e mmc ${flagpart} one_ok; then
        if test -e mmc ${flagpart} one_tried; then
            setenv bootpart 0:2
            setenv mmcroot /dev/mmcblk2p2 ro
        else
            fatwrite mmc ${flagpart} ${loadaddr} one_tried 4;
        fi;
    fi;
fi;
run findfdt
setenv bootargs console=${console} root=${mmcroot} rootfstype=${mmcrootfstype}
load mmc ${bootpart} ${fdt_addr} ${bootdir}/${fdtfile}
load mmc ${bootpart} ${loadaddr} ${bootdir}/zImage
bootz ${loadaddr} - ${fdt_addr}
