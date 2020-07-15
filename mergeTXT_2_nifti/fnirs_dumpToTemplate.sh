#!/bin/bash
output=$1
sampling_rate=$2
files=`ls tmp*.1D`
for f in $files
do
    3dUndump -dimen 2 2 8                  \
             -datum float                   \
             -ijk                           \
             -prefix tmp_${f%.1D}.nii       \
             $f
done
3dTcat -TR 0.005 -prefix ${output%.txt}.nii tmp_*.nii
rm tmp*.1D
rm tmp_*.nii

