#!/bin/bash
file_dir=$1
files=`find $file_dir -name "*.nii" | grep stroop` 

for i in $files; do
    file_name=$i
    echo "processing file: " $file_name
    # copying files to current folder
    cp $file_name . 
    cp ${file_name%.nii}.glm1 . 

    # decompose file with path into its functional parts
    x=$file_name
    x_path=${x%/*} 
    x_base=${x##*/}
    x_fext=${x_base##*.}
    x_pref=${x_base%.*}

    3dDeconvolve -input ${x_pref}.nii -nfirst 0 -polort 4 \
                 -num_stimts 1 \
                 -stim_file 1 ${x_pref}.glm1 -stim_label 1 stroop \
                 -num_glt 1 \
                 -gltsym 'SYM: +stroop' -glt_label 1 stroop-rest \
                 -tout -bout \
                 -bucket stat_${x_pref}_stroop-rest.nii

    rm $x_base $x_pref.glm1
done
rm *.REML_cmd *.xmat.1D

