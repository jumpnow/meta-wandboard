SUMMARY = "A development image with nginx webserver"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require console-image.bb

PR = "0"

IMAGE_INSTALL += " \
    nginx \
 "

export IMAGE_BASENAME = "web-image"

