#!/bin/bash
#
#
#
#   Purpose:   Restore ZWS-files from Archive
#   Author:    Peter von Rohr <peter.vonrohr@qualitasag.ch>
#
#######################################################################

set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  # hence pipe fails if one command in pipe fails

# ================================ # ======================================= #
# prog paths                       # required for cronjob                    #
UT_ECHO=/bin/echo                  # PATH to echo                            #
UT_DATE=/bin/date                  # PATH to date                            #
# ================================ # ======================================= #

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT=$(basename ${BASH_SOURCE[0]})
TDATE=`date +"%Y%m%d%H%M%S"`


# functions
#==========
# produce a start message
start_msg () {
    echo "********************************************************************************"
    echo "Starting $SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
    echo ""
}

# produce an end message
end_msg () {
    echo ""
    echo "End of $SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
    echo "********************************************************************************"
}

### # functions related to logging
log_msg () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_RIGHTNOW=`$UT_DATE +"%Y%m%d%H%M%S"`
  $UT_ECHO "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}

# produce usage message
usage () {
    local l_MSG=$1
    >&2 echo "Usage Error: $l_MSG"
    >&2 echo "Usage: $SCRIPT -s <archive_source> -t <restore_target>"
    >&2 echo "  where -s <archive_source> -- specifies the file in the archive to be restored"
    >&2 echo "        -t <restore_target> -- specifies the target directory where the restored file should be placed"
    >&2 echo ""
    exit 1
}


# ======================================================================
# Main part of the script starts here ...
start_msg

# Parse and check command line arguments
#=======================================

# Use getopts for commandline argument parsing
# If an option should be followed by an argument, it should be followed by a ":".
# Notice there is no ":" after "h". The leading ":" suppresses error messages from
# getopts. This is required to get my unrecognized option code to work.
ARCHSOURCE=""
RESTORETRG=""
while getopts ":s:t:h" FLAG; do
    case $FLAG in
        h)
            usage "Help message for $SCRIPT"
        ;;
        s)
            if test -f $OPTARG; then
                ARCHSOURCE=$OPTARG
            else
                usage "$OPTARG isn't a regular file"
            fi
        ;;
        t)
            RESTORETRG=$OPTARG
        ;;
        :)
            usage "-$OPTARG requires an argument"
        ;;
        ?)
            usage "Invalid command line argument (-$OPTARG) found"
        ;;
    esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

# Check whether required arguments have been specified
if test "$ARCHSOURCE" == ""; then
    usage "-s <archive_source> not defined"
fi


# Continue to put your code here
# in case where the target directory already exists and is not empty, we create a new one
if [ ! -d "$RESTORETRG" ]
then
 log_msg $SCRIPT "Create new restore target $RESTORETRG"
 mkdir -p $RESTORETRG
fi

# get the basename of restore target
BNARSRC=`basename $ARCHSOURCE`
log_msg $SCRIPT "Basename arch src: $BNARSRC"
RESTOREPATH=$RESTORETRG/$BNARSRC
log_msg $SCRIPT "Restore path: $RESTOREPATH"

# check that restore does not overwrite existing files
if [ -e "$RESTOREPATH" ]
then
  log_msg $SCRIPT "$BNARSRC seams to exist in $RESTORETRG -- not overwriting"
else
  # copy restore source to target-dir
  log_msg $SCRIPT "Copy $ARCHSOURCE to $RESTORETRG"
  cp $ARCHSOURCE $RESTORETRG
fi

# in case of a gz file, use gunzip to extract, if extracted file does not exist
# get extension
RESTOREPATHEXTREV=`echo $RESTOREPATH | rev | cut -d '.' -f 1`
log_msg $SCRIPT "Restore path extension reversed: $RESTOREPATHEXTREV"

if [ "$RESTOREPATHEXTREV" == "zg" ]
then
  RESTOREPATHSTEM=`echo $RESTOREPATH  | sed -e "s/\.gz$//"`
  log_msg $SCRIPT "Restore path stem: $RESTOREPATHSTEM"
  # if extracted file does not exist, extract it
  if [ ! -e "$RESTOREPATHSTEM" ]
  then
    log_msg $SCRIPT "Extract: $RESTOREPATH"
    gunzip $RESTOREPATH
  fi
fi

# ======================================================================
# Script ends here
end_msg
