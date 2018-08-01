#copyright 1997, 1998 Patrick Volkerding, Moorhead, Minnesota USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

if [ "$TMPDIR" = "" ]; then
  TMPDIR=/tmp
fi
if [ "$1" = "" ]; then
  echo "$0:  Converts RPM format to standard GNU tar + GNU zip format."
  echo "            (view converted packages with \"less\", install and remove"
  echo "            with \"installpkg\", \"removepkg\", \"pkgtool\", or manually"
  echo "            with \"tar\")"
  echo
  echo "Usage:      $0 <file.rpm>"
  if [ "`basename $0`" = "rpm2tgz" ]; then
    echo "            (Outputs \"file.tgz\")"
  else
    echo "            (Outputs \"file.tar.gz\")"
  fi
  exit 1;
fi
for i in $* ; do
  if [ ! "$1" = "$*" ]; then
    echo "Processing file: $i"
  fi
  rm -rf $TMPDIR/rpm2targz$$ # clear the way, just in case of mischief
  mkdir $TMPDIR/rpm2targz$$
  ofn=`basename $i .rpm`.cpio
  dd ibs=`rpmoffset < $i` skip=1 if=$i 2> /dev/null | gzip -dc > $TMPDIR/rpm2targz$$/$ofn
  ( cd $TMPDIR/rpm2targz$$
    cpio --extract --preserve-modification-time --make-directories < $ofn 1> /dev/null 2> /dev/null
    rm -f $ofn
    find . -type d -perm 700 -exec chmod 755 {} \;
    tar cf - . ) > `basename $i .rpm`.tar
    gzip -9 `basename $i .rpm`.tar
    if [ "`basename $0`" = "rpm2tgz" ]; then
      mv `basename $i .rpm`.tar.gz `basename $i .rpm`.tgz
    fi
  ( cd $TMPDIR ; rm -rf rpm2targz$$ )
done


