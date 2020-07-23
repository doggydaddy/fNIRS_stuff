#!/bin/bash
file_dir=$1
file_pattern=$2
files_pre=`find $file_dir -name "$file_pattern" | grep -v post` 
files_post=`find $file_dir -name "$file_pattern" | grep -v pre`

for i in $files_pre; do
    pre_file_name=$i
    post_file_name=${i%pre.nii}post.nii
    echo "processing file: " $pre_file_name
    echo "corresponding post file: " $post_file_name
    # copying files to current folder
    cp $pre_file_name . 
    cp $post_file_name .
    cp ${pre_file_name%.nii}.glm1 . 
    cp ${pre_file_name%.nii}.glm2 . 
    cp ${post_file_name%.nii}.glm1 . 
    cp ${post_file_name%.nii}.glm2 . 

    # decompose file with path into its functional parts
    a=$pre_file_name
    pre_path=${a%/*} 
    pre_base=${a##*/}
    pre_fext=${pre_base##*.}
    pre_pref=${pre_base%.*}
    a=$post_file_name
    post_path=${a%/*} 
    post_base=${a##*/}
    post_fext=${post_base##*.}
    post_pref=${post_base%.*}

    # concatenate the glms together    
    ./concat_glms.R ${pre_pref%pre}

    # concatenate the *.nii file
    3dTcat -prefix ${pre_pref%_pre}.nii $pre_base $post_base

    3dDeconvolve -input ${pre_pref%_pre}.nii -nfirst 0 -polort 3 \
                 -num_stimts 4 \
                 -stim_file 1 pad${pre_pref}.glm1 -stim_label 1 pre_con \
                 -stim_file 2 pad${pre_pref}.glm2 -stim_label 2 pre_inc \
                 -stim_file 3 pad${post_pref}.glm1 -stim_label 3 post_con \
                 -stim_file 4 pad${post_pref}.glm2 -stim_label 4 post_inc \
                 -num_glt 1 \
                 -gltsym 'SYM: +0.5*pre_con + 0.5*pre_inc - 0.5*post_con - 0.5*post_inc' -glt_label 1 pre-post \
                 -tout -bout \
                 -bucket stat_${pre_pref%pre}preMpost.nii

    rm $pre_base $pre_pref.glm1 $pre_pref.glm2 $post_base $post_pref.glm1 $post_pref.glm2 pad*.glm* ${pre_pref%_pre}.nii
done
rm *.REML_cmd *.xmat.1D

