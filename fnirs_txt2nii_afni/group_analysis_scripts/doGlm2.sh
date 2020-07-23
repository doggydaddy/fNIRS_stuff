#!/bin/bash
files=`ls *CTRL.merged.nii`

for i in $files
do

    echo "ctrl file: $i"
    if [ -f ${i/CTRL/ESC} ]; then
        echo "<a> file detected as a drug file"
        againstfile=${i/CTRL/ESC}
    else
        echo "<a> file detected as a placebo file"
        againstfile=${i/CTRL/PLACEBO}
    fi
    echo "<a> file: $againstfile"

    echo "fixing glms for against file ..."
    nc=`3dinfo -ntimes $i`
    na=`3dinfo -ntimes $againstfile`

    echo "DEBUG: nc = $nc ; na = $na"
    echo "DEBUG: padding glms ..."
    touch prepend
    awk "BEGIN{for(c=0;c<$nc;c++) print "0"}" >> prepend
    cat prepend ${againstfile%.nii}.glm1 >> post_glm1
    cat prepend ${againstfile%.nii}.glm2 >> post_glm2
    touch postpend
    awk "BEGIN{for(c=0;c<$na;c++) print "0"}" >> postpend
    cat ${i%.nii}.glm1 postpend >> pre_glm1
    cat ${i%.nii}.glm2 postpend >> pre_glm2

    3dDeconvolve -input $i $againstfile -nfirst 0 -polort 3 \
                 -num_stimts 4 \
                 -stim_file 1 pre_glm1 -stim_label 1 pre_feel \
                 -stim_file 2 pre_glm2 -stim_label 2 pre_supp \
                 -stim_file 3 post_glm1 -stim_label 3 post_feel \
                 -stim_file 4 post_glm2 -stim_label 4 post_supp \
                 -num_glt 4 \
                 -gltsym 'SYM: +post_feel -post_supp' -glt_label 1 post_feel-supp \
                 -gltsym 'SYM: +pre_feel -pre_supp' -glt_label 2 pre_feel-supp \
                 -gltsym 'SYM: +post_supp -pre_supp' -glt_label 3 post-pre_supp \
                 -gltsym 'SYM: +post_feel -pre_feel' -glt_label 4 post-pre_feel \
                 -tout -bout \
                 -fitts fit_${i/_CTRL/} \
                 -errts error_${i/_CTRL/} \
                 -bucket stat_${i/_CTRL/}

    rm error_*
    rm fit_*
    rm *REML_cmd *xmat.1D
    rm prepend postpend pre_glm1 pre_glm2 post_glm1 post_glm2
done

