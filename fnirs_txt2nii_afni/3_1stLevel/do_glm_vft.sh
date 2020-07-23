#!/bin/bash
file_dir=$1
files=`find $file_dir -name "*.nii" | grep VFT` 

for i in $files; do
    file_name=$i
    echo "processing file: " $file_name
    # copying files to current folder
    cp $file_name . 
    cp ${file_name%.nii}.glm1 . 
    cp ${file_name%.nii}.glm2 . 

    # decompose file with path into its functional parts
    x=$file_name
    x_path=${x%/*} 
    x_base=${x##*/}
    x_fext=${x_base##*.}
    x_pref=${x_base%.*}

    3dDeconvolve -input ${x_pref}.nii -nfirst 0 -polort 4 \
                 -num_stimts 2 \
                 -stim_file 1 ${x_pref}.glm1 -stim_label 1 task \
                 -stim_file 2 ${x_pref}.glm2 -stim_label 2 base \
                 -num_glt 1 \
                 -gltsym 'SYM: +task -base' -glt_label 1 task-base \
                 -tout -bout \
                 -bucket stat_${x_pref}_task-base.nii

    rm $x_base $x_pref.glm1 $x_pref.glm2
done
rm *.REML_cmd *.xmat.1D

