cat >build1.sh<<'EOF'

stow --version
if test ! -z $?; then
   echo we relying on stow here, please 'brew install stow' first
fi

cd ~/play/emacs
echo "Building @`date`" | tee -a build.log
make clean 2>/dev/null
git reset --hard
git clean -dfx
git pull
make extraclean
STRINGS=nextstep/Cocoa/Emacs.base/Contents/Resources/English.lproj/InfoPlist.strings
git remote update
git rebase origin/master
DATE=`date -u +"%Y-%m-%d %H:%M:%S %Z"`
DAY=`date -u +"%Y-%m-%d"`
ORIG=`grep ^AC_INIT configure.in`
VNUM=`echo $ORIG | cut -d\  -f2-999 | sed s/\)$//`
REV=`git log --no-color --pretty=format:%H origin/master^..origin/master`
VERS="$VNUM Git $REV $DATE"
echo $VERS
ZIPF="Cocoa Emacs ${VNUM} Git $REV ${DAY}.zip"
sed "s/$VNUM,/$VERS,/" < $STRINGS > ${STRINGS}.tmp
mv ${STRINGS}.tmp $STRINGS
unset EMACSDATA; unset EMACSDOC; echo $EMACSDATA $EMACSDOC;
make configure
CFLAGS="-pipe -march=nocona" ./configure --prefix=/usr/local/stow/emacs --build i686-apple-darwin10.0.0 --with-ns
# http://www.emacswiki.org/emacs/BuildingEmacs#toc2
make bootstrap -j3 && make install prefix=/usr/local/stow/emacs
stow emacs
EOF

sh -x build1.sh
