#!/bin/bash

for breed in bv rh
do
  qlmanage -p /Volumes/data_zws/fbk/work/${breed}/compare/ge_plot_report_fbk_compare_${breed}.pdf
  sleep 2
done
