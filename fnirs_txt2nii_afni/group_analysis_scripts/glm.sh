#!/bin/bash

files=`ls *merged.nii`

for i in $files; do
    3dDeconvolve -input $i -nfirst 0 -polort 3 \
                 -num_stimts 1 \
                 -stim_file 1 ${i%.nii}.glm1 -stim_label 1 feel \
                 -num_glt 1 \
                 -gltsym 'SYM: +feel' -glt_label 1 feel \
                 -tout -bout \
                 -fitts fit_$i \
                 -errts error_$i \
                 -bucket stat_$i
    rm error_*
    rm fit_*
    rm *REML_cmd *xmat.1D
done

