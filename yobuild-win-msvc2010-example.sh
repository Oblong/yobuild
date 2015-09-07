#!/bin/sh
# Script to build all of yobuild's recipes on Windows 7 with Visual C++ 2010
set -e
set -x

export YB_WIDTH=32
export YB_COMPILERNAME=msvc2010

# Rely on some host tools
if ! wget --version
then
    echo "Please install wget"
    exit 1
fi

if ! 7z --help
then
    echo "Please install 7z"
    exit 1
fi

# Known good build order
# FIXME: add dependency solver
pkgs="
openssl
curl
yaml
libicu53
boost
"

for pkg in $pkgs
do
    yb_buildone $pkg
    yb_install $pkg
done
