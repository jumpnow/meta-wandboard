#!/bin/sh

if [ $# -ne 1 ] ; then
    echo -e "\nUsage: $0 <image.png>\n"
    exit 1
fi

imageh=`basename $1 .png`-img.h

gdk-pixbuf-csource --macros $1 > $imageh.tmp

sed -e "s/MY_PIXBUF/POKY_IMG/g" -e "s/guint8/uint8/g" $imageh.tmp > psplash-poky-img.h && rm $imageh.tmp

mv psplash-poky-img.h ../recipes-core/psplash/psplash/

echo -e "\nRebuild psplash and your image, like this:\n"
echo -e "    bitbake -c cleansstate psplash"
echo -e "    bitbake psplash"
echo -e "    bitbake -c cleansstate pansenti-qte-image"
echo -e "    bitbake pansenti-qte-image\n"


