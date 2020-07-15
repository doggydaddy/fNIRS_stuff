#!/bin/bash
files=`ls *.glm*`
for f in $files; do 
    mv "$f" "`echo $f | sed s/SUB_/SUBJ_/`";
done
