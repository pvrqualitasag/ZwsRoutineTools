#!/bin/bash
#
#
#
#   Purpose:   Run the preparation and the prediction for a given set of gs-jobs
#   Author:    Peter von Rohr <peter.vonrohr@qualitasag.ch>
#
#######################################################################

set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  # hence pipe fails if one command in pipe fails

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT=$(basename ${BASH_SOURCE[0]})
SERVER=`hostname`
PREDOUTFILEFOUND="FALSE"

# Function definitions local to this script
#==========================================
# produce a start message
start_msg () {
    echo "********************************************************************************"
    echo "Starting $SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
    echo "Server:  $SERVER"
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
  local l_RIGHTNOW=`date +"%Y%m%d%H%M%S"`
  echo "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}

# Usage message
usage () {
    local l_MSG=$1
    >&2 echo "Usage Error: $l_MSG"
    >&2 echo "Usage: $SCRIPT -j <job_definition>"
    >&2 echo "       where   -j <job_definition> -- job definition either via file or via directory"
    >&2 echo "  optional arguments are:"
    >&2 echo "               -t                  -- to specify an alternative target directory for job definition files"
    >&2 echo ""
    exit 1
}

# check that prediction prerequisites are met for a single job
check_prepprereq_perjob () {
  local l_run=$1
  local l_run_path=`tr '#' '/' <<< $l_run`
  local l_missing="FALSE"
  PREDOUTFILEFOUND="FALSE"
  if [ "$VERBOSE" == "TRUE" ]; then log_msg check_prepprereq_perjob "run path set to: $l_run_path";fi
  # check whether run_path exists, if not stop here
  if [ ! -d "$l_run_path" ]
  then
    log_msg check_prepprereq_perjob "ERROR: Cannot find run path: $l_run_path"
    exit 1
  fi
  # # check whether prediction output files already exist
  # for p in ${PREDOUTFILES[@]}
  # do
  #   if [ -s "$l_run_path/$p" ]
  #   then
  #     PREDOUTFILEFOUND="TRUE"
  #     if [ "$VERBOSE" == "TRUE" ]; then log_msg check_prepprereq_perjob "FOUND prediction output file $l_run_path/$p";fi
  #   fi
  # done
  # # stop if one of the prediction output files were found
  # if [ "$l_has_pred_outfile" == "TRUE" ]
  # then
  #   log_msg check_prepprereq_perjob "ERROR: Prediction outputfile found. Delete them first before re-running prediction"
  #   exit 1
  # fi
  
  # loop over required result files and check whether they are available
  for f in ${FINISHEDFILES[@]}
  do
    if [ ! -s "$l_run_path/$f" ]
    then
      l_missing="TRUE"
      if [ "$VERBOSE" == "TRUE" ]; then log_msg check_prepprereq_perjob "CANNOT FIND resultfile $l_run_path/$f";fi
    fi
  done
  if [ "$l_missing" == "TRUE" ]
  then
    log_msg check_prepprereq_perjob "ERROR: Pre-requisites for prediction not met. Run runBayesC.sh to generate the required files"
    exit 1
  fi
  # check last line of logfile
  local l_bayeslog=$l_run_path/BayesC.log
  if [ -s "$l_bayeslog" ]
  then
    if [ `tail -1 "$l_bayeslog" | grep 'Job finished' | wc -l` == "0" ]
    then
      log_msg check_prepprereq_perjob "ERROR: Job not finished according to $l_bayeslog"
      exit 1
    fi
  else
    log_msg final_check_run "ERROR: CANNOT find logfile: $l_bayeslog"
    exit 1
  fi
}

# check preparation prediction prerequisites for a set of jobs
check_prepprereq () {
  local l_jobdef=$1
  # in case where l_jobdef is a file, then loop over entries
  if [ -f "$l_jobdef" ]
  then
    log_msg check_prepprereq "Checking preppre-reqs in jobfile: $l_jobdef ..."
    cat $l_jobdef | while read run
    do
      log_msg check_prepprereq " * run: $run ..."
      check_prepprereq_perjob $run
    done
  else
    log_msg check_prepprereq " * run: $l_jobdef ..."
    check_prepprereq_perjob $l_jobdef
  fi
}

# check prediction pre-req for single job
check_predprereq_perjob () {
  local l_run=$1
  local l_run_path=`tr '#' '/' <<< $l_run`
  if [ -s "$l_run_path/predict.ip" ]
  then
    log_msg check_predprereq_perjob "ERROR: CANNOT FIND parameter file: l_run_path/predict.ip"
    exit 1
  fi  
}

# checking prerequisites for prediction
check_predprereq () {
  local l_jobdef=$1
  # in case where l_jobdef is a file, then loop over entries
  if [ -f "$l_jobdef" ]
  then
    log_msg check_predprereq "Checking prediction pre-reqs in jobfile: $l_jobdef ..."    
    cat $l_jobdef | while read run
    do
      log_msg check_predprereq " * run: $run ..."
      check_predprereq_perjob $run
    done
  else
    log_msg check_predprereq " * run: $l_jobdef ..."
    check_predprereq_perjob $l_jobdef
  fi
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
PREDOUTFILES=(predict.ghat1 predict.out1 predict.log)
FINISHEDFILES=(BayesC.mrkRes1 BayesC.cgrRes1 BayesC.ghatREL1)
JOBDEF=""
VERBOSE="FALSE"
TRGDIRJOBDEF="work/finished_prediction"
while getopts ":j:t:vh" FLAG; do
    case $FLAG in
        h)
            usage "Help message for $SCRIPT"
        ;;
        j) # specify the job definiton
            JOBDEF=$OPTARG
        ;;
        t) # specify a target directory
           TRGDIRJOBDEF=$OPTARG
        ;;
        v) # set verbose mode
           VERBOSE="TRUE"
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
if test "$JOBDEF" == ""; then
    usage "-j job_definition not defined"
fi


# Check evaluation directory
#===========================
dir4check=$(echo $SCRIPT_DIR | rev | cut -d/ -f1 | rev)
if test "$dir4check" != "prog"; then
    >&2 echo "Error: This shell-script is not in a directory called prog"
    exit 1
fi

EVAL_DIR=$(dirname $SCRIPT_DIR)
if [ "$VERBOSE" == "TRUE" ]; then log_msg $SCRIPT "Setting EVAL_DIR to $EVAL_DIR and cd to it ...";fi
cd $EVAL_DIR

# check prerequisites for preparation of prediction, if they are not met, we exit here
check_prepprereq $JOBDEF


# run the preparation script
log_msg $SCRIPT "Running prepare script for $JOBDEF ..."
./prog/prepPredict.sh $JOBDEF

# check the prerequisites for the prediction
check_predprereq $JOBDEF

# start prediction
log_msg $SCRIPT "Running prediction for $JOBDEF ..."
./prog/runPredict.sh $JOBDEF

# in case that jobdef is a file move it to a target directory
if [ -f "$JOBDEF" ]
then
  log_msg $SCRIPT "Moving $JOBDEF to $TRGDIRJOBDEF"
  mv $JOBDEF $TRGDIRJOBDEF
fi


# ======================================================================
# Script ends here
end_msg
