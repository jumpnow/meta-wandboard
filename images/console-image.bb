SUMMARY = "A console development image"

require images/basic-dev-image.bb

IMAGE_INSTALL += " \
    u-boot-scr \
"

export IMAGE_BASENAME = "console-image"
