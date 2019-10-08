#!/bin/bash
###
###
###
###   Purpose:   Show all comparison plot reports for VRDGGOZW
###   started:   2019-07-31 (pvr)
###
### ################################################################# ###

SCRIPT=$(basename ${BASH_SOURCE[0]})
TRAIT=mar

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

for breed in bv ob rh sf si
do
  for zwt in VRZW DGZW GOZW
  do
    qlmanage -p /Volumes/data_projekte/projekte/calcVRDGGOZW/result/${breed}basis/comp${zwt}/ge_plot_report_vrdggozw_prov_compare_${breed}_${zwt}.pdf
    sleep 2
  done
done
