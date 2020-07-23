#!/bin/bash

esc=`ls stat*ESC.merged.nii`
pla=`ls stat*PLACEBO.merged.nii`

for i in $esc; do
    3dcalc -a $i'[11]' -expr 'a' -prefix t$i
done

for i in $pla; do
    3dcalc -a $i'[11]' -expr 'a' -prefix t$i
done

esc=`ls tstat*ESC.merged.nii`
pla=`ls tstat*PLACEBO.merged.nii`

3dttest++ -unpooled -toz -BminusA -setA $pla -setB $esc -prefix ttest_DISGUST_ESCvsPLA.nii

#cleanup
rm tstat_*

