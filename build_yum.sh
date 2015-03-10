yum -y install autoconf automake gcc ncurses-devel git

mkdir -p /usr/local/src
cd /usr/local/src

git clone -b emacs-24 https://github.com/emacs-mirror/emacs.git
cd emacs
./autogen.sh
./configure --without-makeinfo
make install
