#!/bin/bash
files=`ls *.nii`
for f in $files; do 
    mv "$f" "`echo $f | sed s/__/_/`";
done
