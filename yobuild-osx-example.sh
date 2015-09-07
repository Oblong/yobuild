#!/bin/sh
# Script to build all of yobuild's recipes on Mac OS X
set -e
set -x

export YB_WIDTH=${YB_WIDTH:-universal}

# Rely on some host tools
# FIXME: move these into recipes/*/systems.mac somehow
if ! wget --version && ! brew install wget && ! sudo port install wget curl-ca-bundle
then
    echo "Could not find or install wget"
    exit 1
fi
# Work around http://trac.macports.org/ticket/33370, i.e. "ERROR: The certificate of github.com is not trusted."
# when retrieving sources stored at github
if ! grep curl ~/.wgetrc > /dev/null 2>&1 && test -f /opt/local/share/curl/curl-ca-bundle.crt
then
    echo MODIFYING WGET GLOBAL CONFIG FOR THIS USER
    echo CA_CERTIFICATE=/opt/local/share/curl/curl-ca-bundle.crt >> ~/.wgetrc
fi

if ! fakeroot -v && ! brew install fakeroot && ! sudo port install fakeroot
then
    echo "Please install homebrew, or if you're a port user, follow"
    echo "http://guide.macports.org/chunked/development.local-repositories.html"
    echo "to use the local fakeroot portfile from"
    echo "http://trac.macports.org/ticket/33689"
    echo "then do"
    echo "sudo port install libtool fakeroot"
    exit 1
fi

if ! intltool-extract --version > /dev/null 2>&1 && ! brew install intltool && ! sudo port install intltool
then
    bs_abort "Cannot find or install intltool (needed to build glib-networking)"
fi

# Known good build order
# FIXME: add dependency solver
# WARNING: name may need to match directory name created by unpacking downloaded source,
# including upper/lower case, or upload may fail.  FIXME: clarify this
pkgs="
file
gmsl
m4
gawk
flex
bison
pkgconf
autoconf
automake
libtool
libsigsegv
libxml2
yaml
yasm
xz
libicu53
boost
snappy
faac
freetype
fontconfig
gettext
libffi
glib
gmp
nettle
gnutls
glib-networking
libsoup
jpeg
libevent
libogg
orc
libpng
libvorbis
libtheora
tiff
yasm
libvpx
jasper
ImageMagick
GraphicsMagick
FreeImage
libusb
libdc1394
srtp
gstreamer
gst-plugins-base
gst-plugins-good
gst-plugins-bad
gst-libav
gst-rtsp-server
assimp
liblbfgs
eigen
OpenNI2
libfreenect
opencv
x264
gst-plugins-ugly
"

for pkg in $pkgs
do
    yb_buildone $pkg
    yb_install $pkg
done
