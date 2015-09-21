#!/bin/sh

if dnf --version >/dev/null 2>&1; then
    dnf install -y make automake gcc gcc-c++ kernel-devel curl ncurses-devel
elif yum --version >/dev/null 2>&1; then
    yum install -y make automake gcc gcc-c++ kernel-devel curl ncurses-devel
elif apt-get --version >/dev/null 2>&1; then
    apt-get -y -qq update
    apt-get -y -qq install build-essential libncurses-dev curl
elif brew --version >/dev/null 2>&1; then
    brew install libtiff libpng giflib libjpeg
else
    echo 'no package manager found'
fi

vermajor=24
verminor=5
ver=$vermajor.$verminor

mkdir -p /usr/local/src
cd /usr/local/src
[ ! -f emacs-$ver.tar.xz ] && curl -O http://ftp.gnu.org/gnu/emacs/emacs-$ver.tar.xz
tar xf emacs-$ver.tar.xz
cd emacs-$ver
mkdir -p /usr/local/stow
./autogen.sh
./configure --without-makeinfo --prefix=/usr/local/stow/emacs-$ver --with-jpeg=no
make install

cd /usr/local/stow
stow --ignore=dir emacs-$ver
