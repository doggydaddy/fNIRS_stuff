#!/bin/bash
path_to_files=$1
files_pattern=$2
files=`find $path_to_files -name "$files_pattern" | grep -v HRV`

regex_nohrv="NO_HRV"

for i in $files; do
    echo "processing file: " $i
    cp $i . 
    # decompose file with path into its functional parts
    a=$i
    xpath=${a%/*} 
    xbase=${a##*/}
    xfext=${xbase##*.}
    xpref=${xbase%.*}

    if [[ $xbase =~ $regex_nohrv ]]; then
        echo "this dataset doesn't have hrv data, skipping"
    else
        ./hrveda_extract.R $xbase ${xpref}        
    fi
    rm $xbase
done