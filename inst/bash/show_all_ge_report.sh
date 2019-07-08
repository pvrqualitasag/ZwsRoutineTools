#!/bin/bash

for breed in bv rh
do
  for sex in Bull Cow
  do
    qlmanage -p /Volumes/data_zws/fbk/work/${breed}/YearMinus0/compare${sex}/ge_plot_report_fbk_compare${sex}_${breed}.pdf
    sleep 2
  done
done
