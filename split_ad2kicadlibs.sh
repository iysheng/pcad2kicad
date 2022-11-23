#!/bin/sh
#

CSPLIT_FILE_PREFIX=kicadred
KICAD_DESTDIR=kicad_genrated_files

function convert()
{
KICAD_FILE=`grep "# " $1 | awk '{print $2}'`

grep "EESchema-LIBRARY" -r $1 && echo "This file is right, just rename is enough" && cp $1 $KICAD_DESTDIR/$KICAD_FILE.lib && return
echo $1 "--->" $KICAD_FILE

sed -f - $1 > $KICAD_DESTDIR/$KICAD_FILE.lib << append
1,1s/^/&EESchema-LIBRARY Version 2.4\n#encoding utf-8\n/g
append
rm $1
}

if [ $# -lt 1 ];then
	echo "Please input Kicad files"
	exit
fi
echo $1
if [ ! -d $KICAD_DESTDIR ];then
	mkdir $KICAD_DESTDIR
fi
csplit -f $CSPLIT_FILE_PREFIX -n 3 -s $1 /ENDDEF/+1 {*}

SRCS=`fd $CSPLIT_FILE_PREFIX .`
echo $SRCS > /tmp/abc

for src in $SRCS
do
    convert $src
	echo $src"done"
done
