#!/bin/bash
files=`ls tt_*.nii` 
for i in $files
do
	./toTemplate.R $i 1 1.96
done
