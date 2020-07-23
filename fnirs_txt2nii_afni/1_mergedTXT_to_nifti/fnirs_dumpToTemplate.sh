#!/bin/bash

# Script to call afni commands 3dUndump to convert tmp asci files to nii Finally
# calls 3dTcat to concatenate the individual time-point niis to a single
# time-series nii dataset.

# Arguments:
# $1 output file name with .txt tension if convenient, but will not be used.
# output file will have *.nii extension

# Quirks:
# Hardcoded to grab ALL tmp*.1D files (generated from
# fnirs_loadDataToTemplate.R) and use them. So if manually aborted script
# series, any temporary files MUST be deleted prior to another run
#
# Hardcoded sampling-rate, or TR. So change this if the value you see below
# isn't correct!
#
# This script is the last in the series, so it will perform clean-up on all tmp
# files after sucessful runs.

output=$1
files=`ls tmp*.1D`
for f in $files
do
    3dUndump -dimen 2 2 8                  \
             -datum float                   \
             -ijk                           \
             -prefix tmp_${f%.1D}.nii       \
             $f
done
3dTcat -TR 0.125 -prefix ${output%.txt}.nii tmp_*.nii
rm tmp*.1D
rm tmp_*.nii

