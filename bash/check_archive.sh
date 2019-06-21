#!/bin/bash
#
#
#
#   Purpose:   Check Archive of a previous routine evaluation
#   Author:    Peter von Rohr <peter.vonrohr@qualitasag.ch>
#
#######################################################################

set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  # hence pipe fails if one command in pipe fails

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT=$(basename ${BASH_SOURCE[0]})



# Parse and check command line arguments
#=======================================
usage () {
    local l_MSG=$1
    >&2 echo "Usage Error: $l_MSG"
    >&2 echo "Usage: $SCRIPT -d <archive_directory>"
    >&2 echo "  where -d <archive_directory> specifies the archive directory"
    >&2 echo ""
    exit 1
}

# Use getopts for commandline argument parsing
# If an option should be followed by an argument, it should be followed by a ":".
# Notice there is no ":" after "h". The leading ":" suppresses error messages from
# getopts. This is required to get my unrecognized option code to work.
archive_dir=""
while getopts ":d:h" FLAG; do
    case $FLAG in
        h)
            usage "Help message for $SCRIPT"
        ;;
        d)
            if test -d $OPTARG; then
              archive_dir=$OPTARG
            else
              usage "Cannot find archive directory $OPTARG"
            fi
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
if test "archive_dir" == ""; then
    usage "-d <archive_directory> not defined"
fi



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



# ======================================================================
# Main part of the script starts here ...
start_msg



# Check evaluation directory
#===========================
dir4check=$(echo $SCRIPT_DIR | rev | cut -d/ -f1 | rev)
if test "$dir4check" != "prog"; then
    >&2 echo "Error: This shell-script is not in a directory called prog"
    exit 1
fi

EVAL_DIR=$(dirname $SCRIPT_DIR)
cd $EVAL_DIR



# Continue to put your code here



# ======================================================================
# Script ends here
end_msg
