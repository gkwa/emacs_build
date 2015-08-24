yum -y install autoconf automake gcc ncurses-devel git stow

mkdir -p /usr/local/src
mkdir -p /usr/local/stow
cd /usr/local/src

git clone -b emacs-24 https://github.com/emacs-mirror/emacs.git
cd emacs
./autogen.sh
./configure --without-makeinfo --prefix=/usr/local/stow/emacs-24
make install

cd /usr/local/stow
stow emacs
