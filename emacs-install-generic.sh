#!/bin/sh

if yum --verison >/dev/null 2>&1
then
	yum install -y make automake gcc gcc-c++ kernel-devel curl ncurses-devel
elif apt-get --version >/dev/null 2>&1
	apt-get -y -qq update
	apt-get -y -qq install build-essential libncurses-dev curl
elif brew --version >/dev/null 2>&1
	brew install libjpeg libgif/libungif libtiff
fi

vermajor=24
verminor=5
ver=$vermajor.$verminor

mkdir -p /usr/local/src
cd /usr/local/src
curl -O http://ftp.gnu.org/gnu/emacs/emacs-$ver.tar.xz
tar xf emacs-$ver.tar.xz
cd emacs-$ver
mkdir -p /usr/local/stow
./autogen.sh
./configure --without-makeinfo --prefix=/usr/local/stow/emacs-$ver
make install

cd /usr/local/stow
stow --ignore=dir emacs-$ver
