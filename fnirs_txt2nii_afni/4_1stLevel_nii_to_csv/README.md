Step 4: Convert 1st level analysis format from .nii to .csv (for easy loading)

Usage: ./wrapper_glm2csv_all.sh <data_dir> 
Args: <data_dir> is the directory in which all 1st level analysis (and no
other) exist in.
Requires:
	- glm2csv_all.R (main working script)
		- R

Output: In <data_dir> produces a corresponding .csv file for any .nii files.

Details: Not strictly necessary, espeically if you wish to perform further
group analysis using software packages intended for fMRI, but useful if you
wish to use external statistical software instead.


