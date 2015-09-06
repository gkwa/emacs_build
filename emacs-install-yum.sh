#!/bin/sh

yum -y install autoconf automake gcc ncurses-devel git stow make

mkdir -p /usr/local/src
mkdir -p /usr/local/stow
cd /usr/local/src

git clone -b emacs-24 https://github.com/emacs-mirror/emacs.git /usr/local/src/emacs &&
cd /usr/local/src/emacs &&
./autogen.sh &&
./configure --without-makeinfo --with-xpm=no --with-jpeg=no --with-gif=no --with-tiff=no --prefix=/usr/local/stow/emacs-24 &&
make install &&
cd /usr/local/stow &&
stow -vv emacs-24

echo 'export PATH=/usr/local/bin:$PATH' >>~/.bashrc
