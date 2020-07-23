#!/bin/bash

brik_nr=$1
output_filename=$2
# in this test for stroop: it is 17

pre=`ls stat_*post.nii`
post=`ls stat_*pre.nii`

for i in $pre; do
    3dcalc -a $i"[$brik_nr]" -expr 'a' -prefix t$i
done

for i in $post; do
    3dcalc -a $i"[$brik_nr]" -expr 'a' -prefix t$i
done

pre=`ls tstat_*pre.nii`
post=`ls tstat_*post.nii`

3dttest++ -setA $pre -setB $post -paired -prefix $output_filename

#cleanup
rm tstat_*

