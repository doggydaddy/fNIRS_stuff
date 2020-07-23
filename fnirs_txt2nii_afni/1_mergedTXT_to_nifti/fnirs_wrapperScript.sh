#!/bin/bash

# Wrapper script, "main" exe file
# Usage: ./fnirs_wrapperScript.sh <data_dir> <filename_pattern>
# Args:
# <data_dir>: Folder where all data to be processed (merged *.txt files) are located.
#             The files may be located in subdirectories.
#             <data_dir> should be the main data directory.
# <filename_pattern>: A common file name pattern (such as *.txt) to match all
#                     files to be processed in <data_dir>

# Dependencies: Runs a single work-program, fnirs_loadDataToTemplate.R
# Requires:
# - fnirs_loadDataToTemplate.R
#   - R-base
#   - stringr (R package)
#   - withr (R package)
#   - fnirs_rfunctions.R (function definitions, uses importData/importData_noHRV)
#   - fnirs_dumpToTemplate.sh (call afni commands 3dUndump and 3dTcat)
#     - AFNI

# Main points of interest to those to wish to adapt this series of scripts to
# their own data:
# 
# Input data format of your merged .txt files:
# If you think you have a slightly different input data format,
# you need to change: the R function importData/importData_noHRV in
# fnirs_rfunctions.R to read your data properly.
#
# Data sampling rate:
# In order to proper further processing the sampling rate, or in this case "TR"
# (time between two consecutive time-points) of your data need be correct.
# This parameter is current hard-coded in fnirs_dumpToTemplate.sh

path_to_files=$1
files_pattern=$2

# This command is probably not robust and should be susceptible to change
# Purpose of the command is to list all files to be processed, '
# so one can do however they wish

files=`find $path_to_files -name "$files_pattern" | grep -v HRV`
# Currently this script is fitted for Erik's files due to the grepping for HRV
# tag, but this can be easily fixed for other naming conventions.

# Main loop
for i in $files; do
    echo "processing file: "
    echo $i

    cp $i . 
    # decompose file with path into its functional parts
    a=$i
    xpath=${a%/*} 
    xbase=${a##*/}
    xfext=${xbase##*.}
    xpref=${xbase%.*}

    ./fnirs_loadDataToTemplate.R $xbase
    rm $xbase
done
