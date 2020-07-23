#!/bin/bash

files=`ls *merged.nii`

for i in $files; do
    3dDeconvolve -input $i -nfirst 0 -polort 3 \
                 -num_stimts 1 \
                 -stim_file 1 ${i%.nii}.glm2 -stim_label 1 supp \
                 -num_glt 1 \
                 -gltsym 'SYM: +supp' -glt_label 1 supp \
                 -tout -bout \
                 -fitts fit_$i \
                 -errts error_$i \
                 -bucket stat_$i
    rm error_*
    rm fit_*
    rm *REML_cmd *xmat.1D
done

