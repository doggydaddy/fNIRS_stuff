#!/bin/bash
path_to_files=$1
files_pattern=$2
files=`find $path_to_files -name "$files_pattern" | grep -v HRV`

regex_baseline="baseline"
regex_stroop="stroop"
regex_fear="fear"
regex_vft="VFT"

for i in $files
do
    echo "processing file: "
    echo $i
    cp $i . 
    # decompose file with path into its functional parts
    a=$i
    xpath=${a%/*} 
    xbase=${a##*/}
    xfext=${xbase##*.}
    xpref=${xbase%.*}
    
    flag=0
    if [[ $xbase =~ $regex_fear ]]; then
        echo "this is a emo fear file"
        flag=4
    elif [[ $xbase =~ $regex_stroop ]]; then
        echo "this is a stroop file"
        flag=2
    elif [[ $xbase =~ $regex_vft ]]; then
        echo "this is a VFT file"
        flag=3
    else
        echo "this is a baseline file"
        flag=1
    fi
    ./glm_extract.R $xbase $flag $xpref    
    rm $xbase
done

