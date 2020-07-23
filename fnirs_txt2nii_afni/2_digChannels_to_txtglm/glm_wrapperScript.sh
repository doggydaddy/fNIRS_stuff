#!/bin/bash

# wrapper script (main) to extract eda, hrv, and digital signals from merged
# txt files into their separate files
# Usage: ./glm_wrapperScript.sh <data_dir> <filename_pattern>
# Same arguments as fnirs_wrapperScript.sh
# Args:
# <data_dir>: Folder where all data to be processed (merged *.txt files) are located.
#             The files may be located in subdirectories.
#             <data_dir> should be the main data directory.
# <filename_pattern>: A common file name pattern (such as *.txt) to match all
#                     files to be processed in <data_dir>

# Dependencies:
# - glm_extract.R (main working script)
#    - fnirs_rfunctions.R (functions to "fix" digital channels, and functions
#    		           to grab start of block for each of the three paradigms)

# Output:
# For each input merged txt file, checks filename for which type of paradigm
# the file is, and outputs eda, hrv, and glm(s) accordingly. Hence filenames
# must contain text that uniquely identifies its paradigm.

path_to_files=$1
files_pattern=$2

files=`find $path_to_files -name "$files_pattern" | grep -v HRV`

# Unique paradigm tags present somewhere in the filename
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

