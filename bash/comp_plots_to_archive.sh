#!/bin/bash


# ======================================== # ======================================= #
# global constants                         #                                         #
# ---------------------------------------- # --------------------------------------- #
# prog paths                               #                                         #
ECHO=/bin/echo                             # PATH to echo                            #
DATE=/bin/date                             # PATH to date                            #
BASENAME=/usr/bin/basename                 # PATH to basename function               #
DIRNAME=/usr/bin/dirname                   # PATH to dirname function                #
# ---------------------------------------- # --------------------------------------- #
# directories                              #                                         #
INSTALLDIR=`$DIRNAME ${BASH_SOURCE[0]}`    # installation dir of bashtools on host   #
# ---------------------------------------- # --------------------------------------- #
# files                                    #                                         #
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`       # Set Script Name variable                #
# ======================================== # ======================================= #



### # ====================================================================== #
### # functions
usage () {
  local l_MSG=$1
  $ECHO "Usage Error: $l_MSG"
  $ECHO "Usage: $SCRIPT -a <archive_dir> -t <restore_target> -w <work_dir> -r <restore_script>"
  $ECHO "  where -a <archive_dir>     -- directory where plots are archived"
  $ECHO "        -t <restore_target>  -- directory where archived files should be restored to"
  $ECHO "        -w <work_dir>        -- working directory from ge where current plots are"
  $ECHO ""
  exit 1
}

### # produce a start message
start_msg () {
  $ECHO "Starting $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
}

### # produce an end message
end_msg () {
  $ECHO "End of $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
}

### # functions related to logging
log_msg () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_RIGHTNOW=`$DATE +"%Y%m%d%H%M%S"`
  $ECHO "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}


### # script starts here
start_msg

### # ====================================================================== #
### # Use getopts for commandline argument parsing ###
### # If an option should be followed by an argument, it should be followed by a ":".
### # Notice there is no ":" after "h". The leading ":" suppresses error messages from
### # getopts. This is required to get my unrecognized option code to work.
RESTORE=/Users/pvr/Data/Projects/Github/pvrqualitasag/zwsroutinetools/bash/restore_from_archive.sh
# RESTORETRG=1904/compareBull
RESTORETRG=""
# ARCHDIR=/Volumes/data_archiv/zws/1904/health/mar/work/bv/zws/compareBull/
ARCHDIR=""
# WORKDIR=/Volumes/data_zws/health/mar/work/bv/zws/compareBull
WORKDIR=""

while getopts ":a:t:w:h" FLAG; do
  case $FLAG in
    h)
      usage "Help message for $SCRIPT"
      ;;
    a)
      ARCHDIR=$OPTARG
      ;;
    t)
      RESTORETRG=$OPTARG
      ;;
    w)
      WORKDIR=$OPTARG
      ;;
    :)
      usage "-$OPTARG requires an argument"
      ;;
    ?)
      usage "Invalid command line argument -$OPTARG found"
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

# Check whether required arguments have been defined
if test "$ARCHDIR" == ""; then
  usage "-a <archive_dir> not defined"
fi

if test "$RESTORETRG" == ""; then
  usage "-t <restore_target> not defined"
fi

if test "$WORKDIR" == ""; then
  usage "-w <work_dir> not defined"
fi

if test "$RESTORE" == ""; then
  usage "-r <restore_script> not defined"
fi


### # change to work dir and start the comparision of the plots
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


### # script ends here
end_msg
