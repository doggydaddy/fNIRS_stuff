#!/bin/bash

path_to_files=$1
files_pattern=$2
files=`find $path_to_files -name "$files_pattern" | grep -v HRV`
for i in $files; do
    echo "processing file: "
    echo $i

    cp $i . 
    # decompose file with path into its functional parts
    a=$i
    xpath=${a%/*} 
    xbase=${a##*/}
    xfext=${xbase##*.}
    xpref=${xbase%.*}

    ./fnirs_loadDataToTemplate.R $xbase
    rm $xbase
done