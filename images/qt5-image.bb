SUMMARY = "A Qt5 development image"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require console-image.bb

QT_TOOLS = " \
    qtbase \
    qtbase-dev \
    qtbase-fonts \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qt5-env \
 "

QT_APPS = " \
    qcolorcheck \
    tspress \
 "

IMAGE_INSTALL += " \
    ${QT_APPS} \
    ${QT_TOOLS} \
 "

export IMAGE_BASENAME = "qt5-image"

