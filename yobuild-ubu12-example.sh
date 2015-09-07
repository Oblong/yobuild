#!/bin/sh
# Script to build .deb packages for yobuild on ubuntu 12.04
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
OpenNI2
libfreenect
doxygen
yasm
snappy
orc
libvpx
mupdf
GraphicsMagick
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

rm -rf pkgdir
mkdir pkgdir
cd pkgdir
for pkg in $pkgs
do
    ls -d */debian | sed 's,/debian,,' > oldnames
    yb_makedebian $pkg
    ls -d */debian | sed 's,/debian,,' > newnames
    pkgname=`cat oldnames newnames | sort | uniq -c | awk '$1 == 1 {print $2}'`
    echo $pkgname > $pkg.name
done

sudo apt-get remove -y "$YB_PKGNAME_PREFIX"'-*' || true

for pkg in $pkgs
do
    pkgd=`cat $pkg.name`
    cd $pkgd
    mk-build-deps
    # Debian package names are always lower-cased
    YB_PKG=`echo $pkg | tr A-Z a-z`
    sudo dpkg -i $YB_PKGNAME_PREFIX-$YB_PKG-build-deps*.deb || true   # expect dependency problem, fixed in next line
    sudo apt-get install -f -y
    debuild -b -us -uc
    cd ..

    # Don't do autoremove *after* installing the built package, as sometimes on ubu10.04 it removes it!
    sudo dpkg -r $YB_PKGNAME_PREFIX-$YB_PKG-build-deps
    sudo apt-get autoremove -y || true
    # Work around https://bugs.launchpad.net/ubuntu/+source/java-common/+bug/1285791
    sudo dpkg --purge openjdk-6-jdk || true

    # Now install it, since it might be a build dep of a package later in the list
    eval sudo dpkg -i $YB_PKGNAME_PREFIX-$YB_PKG*.deb || true   # expect dependency problem, fixed in next line
    sudo apt-get install -f -y
done
