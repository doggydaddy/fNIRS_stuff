#!/bin/bash
# usage: ./<command name> glm_stats_2 stat_
files_path=$1
files_pattern=$2
files=`find $files_path -name "$files_pattern" | grep nii`
for i in $files
do
    ./glm2csv_all.R $i ${i%.nii}.csv
done
