#!/bin/bash

files=`ls *.merged.txt`
for i in $files
do
    echo "processing file: $i"
    ./loadDataToTemplate.R $i
done

