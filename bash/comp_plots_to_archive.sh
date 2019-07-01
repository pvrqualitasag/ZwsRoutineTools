#!/bin/bash

RESTORE=/Users/pvr/Data/Projects/Github/pvrqualitasag/zwsroutinetools/bash/restore_from_archive.sh
RESTORETRG=1904/compareBull
ARCHDIR=/Volumes/data_archiv/zws/1904/health/mar/work/bv/zws/compareBull/
WORKDIR=/Volumes/data_zws/health/mar/work/bv/zws/compareBull

CURWD=`pwd`
cd $WORKDIR

# loop over comparefiles
ls -1 *.png *.pdf | \
while read f
do
  farch=$f.gz
  ARCHPATH=$ARCHDIR/$farch
  if [ -f "$ARCHPATH" ]
  then
    echo "Restore $farch"
    $RESTORE -s $ARCHPATH -t $RESTORETRG
    open $RESTORETRG/$f
  else
    echo "Cannot find "$farch in $ARCHDIR""
  fi
  sleep 2
  echo "Show $f"
  qlmanage -p $f
  sleep 2
done

cd $CURWD
