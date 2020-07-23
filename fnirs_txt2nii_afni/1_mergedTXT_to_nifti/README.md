Step 1: Convert merged .txt files to .nii
Call fnirs_wrapperScript.sh
From fnirs_wrapperScript.sh:

Wrapper script, "main" exe file
Usage: ./fnirs_wrapperScript.sh <data_dir> <filename_pattern>
Args:
<data_dir>: Folder where all data to be processed (merged *.txt files) are located.
            The files may be located in subdirectories.
            <data_dir> should be the main data directory.
<filename_pattern>: A common file name pattern (such as *.txt) to match all
                    files to be processed in <data_dir>

Dependencies:
List:
- AFNI
- R
- R packages stringr, withr

Details:
- fnirs_loadDataToTemplate.R
  - R-base (R)
  - stringr (R package)
  - withr (R package)
  - fnirs_rfunctions.R (function definitions, uses importData/importData_noHRV)
  - fnirs_dumpToTemplate.sh (call afni commands 3dUndump and 3dTcat)
    - AFNI

The scripts:
fnirs_wrapperScript.sh
fnirs_loadDataToTemplate.R
fnirs_rfunctions.R
fnirs_dumpToTemplate.sh 
Should ALL be in the same working directory when doing the conversion

Main points of interest to those to wish to adapt this series of scripts to
their own data:

Input data format of your merged .txt files:
If you think you have a slightly different input data format,
you need to change: the R function importData/importData_noHRV in
fnirs_rfunctions.R to read your data properly.

Data sampling rate:
In order to proper further processing the sampling rate, or in this case "TR"
(time between two consecutive time-points) of your data need be correct.
This parameter is current hard-coded in fnirs_dumpToTemplate.sh

Details: 
Grabbing file list is currently in fnirs_wrapperScript.sh, line 42.
While it should technically work as is, this is not sure given the naming
scheme of YOUR data, so change it to generate a list of files to convert.

Output .nii data format:
generates 4D (3D+t) nifti dataset, defined in fnirs_loadDatatoTamplate.R
t dimension is time-points
spatial dimensions are:
i:       0 = oxy; 1 = doxy
j and k determine channels:
j:       0 = channels 1-8; 1 = channels 9-16
k:       0-7 for channels (8*j)+(k+1)
