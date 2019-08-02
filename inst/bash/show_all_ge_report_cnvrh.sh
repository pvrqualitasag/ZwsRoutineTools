#!/bin/bash
###
###
###
###   Purpose:   Show all comparison plot reports for CNVRH
###   started:   2019-07-31 (pvr)
###
### ################################################################# ###

SCRIPT=$(basename ${BASH_SOURCE[0]})
TRAIT=cnvrh

### # functions related to logging
log_msg () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_RIGHTNOW=`date +"%Y%m%d%H%M%S"`
  echo "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}

### this works only on a local mac
OSNAME=`uname`
if [ "$OSNAME" != "Darwin" ]
then
  log_msg $SCRIPT "ERROR: Can only run on a mac"
  exit 1
fi

for breed in rh
do
  qlmanage -p /Volumes/data_zws/convert/work/${breed}/compare/ge_plot_report_${TRAIT}_compare_${breed}.pdf
  sleep 2
done
