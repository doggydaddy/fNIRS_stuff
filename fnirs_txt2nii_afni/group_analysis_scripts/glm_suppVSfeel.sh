#!/bin/bash

files=`ls *merged.nii`

for i in $files; do
    3dDeconvolve -input $i -nfirst 0 -polort 3 \
                 -num_stimts 2 \
                 -stim_file 1 ${i%.nii}.glm1 -stim_label 1 feel \
                 -stim_file 2 ${i%.nii}.glm2 -stim_label 2 supp \
                 -num_glt 1 \
                 -gltsym 'SYM: +supp -feel' -glt_label 1 supp-feel \
                 -tout -bout \
                 -fitts fit_$i \
                 -errts error_$i \
                 -bucket stat_$i
    rm error_*
    rm fit_*
    rm *REML_cmd *xmat.1D
done

