#!/bin/sh
#Unpack or install an 'rpm' archive
#bug report to steven.chen@alcatel-lucent.com

E_NO_ARGS=65
TEMPFILE=$$.cpio   # Tempfile with "unique" name.
                   # $$ is process ID of script.

PROG_NAME=$(basename $0)
I_FLAG=FALSE
L_FLAG=FALSE

if [ -z "$1" ] 
then
  echo "Usage: `basename $0` -[i|t] -f filename [-l file_list]"
  echo "report bug to steven.chen@alcatel-lucent.com"
exit $E_NO_ARGS
fi

pattern=""
file_name=""

while getopts f:itl: option
do
        case "${option}"
        in
                f) file_name="${OPTARG}";;
                l) pattern="${OPTARG}";;
                i) I_FLAG=true;;
                t) L_FLAG=true;;
                \?) usage
                    exit 1;;
        esac
done

[ $L_FLAG = 'true' ] && [ $I_FLAG = 'true' ] && echo "can not use both option" && exit 1

hash rpm2cpio 2>&- || { echo >&2 "require rpm2cpio but it's not installed.";exit 1; }
hash cpio 2>&- || { echo >&2 "require cpio but it's not installed.";exit 1; }

rpm2cpio  < $file_name > $TEMPFILE    # Converts rpm archive into cpio archive.

echo $TEMPFILE  $L_FLA  $I_FLAG $pattern

if [ $L_FLAG = 'true' ]
then
echo "L $L_FLAG"
cpio  -F $TEMPFILE  -tv $pattern
fi 

if [ $I_FLAG = 'true' ]
then
echo "I $I_FLAG"
cpio  -F $TEMPFILE -ivd $pattern # Unpacks cpio archive.
fi

rm -f $TEMPFILE                          # Deletes cpio archive.

exit 0
