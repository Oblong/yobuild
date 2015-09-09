#!/bin/sh
# Script to build .rpm packages for yobuild on fedora 22
set -e
set -x

export YB_PKGNAME_PREFIX=${YB_PKGNAME_PREFIX:-yobuilt}

# Known good build order
# FIXME: add dependency solver
pkgs="
libtool
autoconf
automake
boost
cmake
doxygen
openni2
libfreenect
yasm
snappy
orc
libvpx
graphicsmagick
gmp
nettle
gnutls
glib
glib-networking
srtp
libusb
v4l-utils
gstreamer
gst-plugins-base
gst-plugins-good
gst-plugins-bad
gst-libav
gst-rtsp-server
x264
gst-plugins-ugly
"

sudo rpm -e `rpm -q -a | grep ${YB_PKGNAME_PREFIX}` || true
rm -rf pkgdir
mkdir pkgdir
cd pkgdir
for pkg in $pkgs
do
    yb_makefedora $pkg
    sudo rpm -i ${YB_PKGNAME_PREFIX}-$pkg*.rpm
done
