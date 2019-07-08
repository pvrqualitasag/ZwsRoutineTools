#!/bin/bash

for breed in bv rh
do
  qlmanage -p /Volumes/data_zws/nd/work/${breed}/compare/ge_plot_report_nd_compare_${breed}.pdf
  sleep 2
done
