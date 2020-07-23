#!/bin/bash

brik_nr=$1
output_filename=$2
# in this test for stroop: it is 17
folder1=$3 # fatigue group
folder2=$4 # no-fatigue group

fat=`find $folder1 -name "stat_*.nii"`
nofat=`find $folder2 -name "stat_*.nii"`

for i in $fat; do
    a=$i
    xpath=${a%/*} 
    xbase=${a##*/}
    xfext=${xbase##*.}
    xpref=${xbase%.*}
    3dcalc -a $i"[$brik_nr]" -expr 'a' -prefix tfat$xbase
done

for i in $nofat; do
    a=$i
    xpath=${a%/*} 
    xbase=${a##*/}
    xfext=${xbase##*.}
    xpref=${xbase%.*}
    3dcalc -a $i"[$brik_nr]" -expr 'a' -prefix tnof$xbase
done

fat=`ls tfat*.nii`
nof=`ls tnof*.nii`

3dttest++ -setA $fat -setB $nof -prefix $output_filename

#cleanup
rm tfat*.nii tnof*.nii

