cat >build1.sh<<'EOF'

set -e

stow --version
if test ! -z $?; then
   echo we relying on stow here, please 'brew install stow' first
fi

# brew install stow #http://www.inductiveload.com/posts/basic-use-of-gnu-stowxstow/
cd ~/play/emacs
echo "Building @`date`" | tee -a build.log
make clean 2>/dev/null
git reset --hard
git clean -dfx
# git pull
make extraclean
# git remote update
# git rebase origin/master

if test -z "$(brew list | grep giflib)"; then
	brew install giflib
fi

if test -z "$(brew list | grep libpng)"; then
	brew install libpng
fi

sha1=$(git rev-parse --short=5 head)
VNUM=$(grep AC_INIT configure.ac | grep -oE '[[:digit:]\.]+')
VNUM=$VNUM.$sha1 #looks like 24.3.50.ec1f92




echo $VNUM

if test -z "$VNUM"; then
	echo couldn\'t parse VNUM
	echo exiting...
	exit 1
fi;

DATE=`date -u +"%Y-%m-%d %H:%M:%S %Z"`
DAY=`date -u +"%Y-%m-%d"`
REV=`git log --no-color --pretty=format:%H origin/master^..origin/master`
VERS="$VNUM Git $REV $DATE"
echo $VERS
ZIPF="Cocoa Emacs ${VNUM} Git $REV ${DAY}.zip"
unset EMACSDATA; unset EMACSDOC; echo $EMACSDATA $EMACSDOC;
make configure

edir=emacs-$VNUM
CFLAGS="-pipe -march=nocona" ./configure --prefix=/usr/local/stow/$edir --build i686-apple-darwin10.0.0 --with-x

# http://www.emacswiki.org/emacs/BuildingEmacs#toc2
time make bootstrap -j3 && time make install prefix=/usr/local/stow/$edir
cd /usr/local/stow
stow $edir

# http://osxdaily.com/2012/08/03/send-an-alert-to-notification-center-from-the-command-line-in-os-x/
test ! -z "$(type terminal-notifier)" && \
terminal-notifier -message "build.sh finished"

EOF



sh -x build1.sh
