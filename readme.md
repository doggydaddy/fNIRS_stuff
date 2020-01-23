Simple matlab script to convert Hb data from Biopacs (with minimal preprocessing) 
To valid format for spm12 fnirs processing

By: Yanlu Wang @ Karolinska University Hospital
Date: 2020-01

Quick guide:
1. Run txt_to_spm_fnirs_mat.m in matlab environment.
2. Pick intput txt file from gui
3. Enter age of subject
4. Enter name of output file

Output file is *.mat with Y and P structs according to example input file from
spm12 fnirs.

Error during parse of input file is caused by "end flag" of the text file. To
fix this, go into the txt file and remove the last line with only the single
end flag 

Some fields in the Y and P structs will be mising because input txt data is
assumed to be already converted to Hb and not light intensity.

P -> fname -> raw -> type = 'Light Intensity' is therefore wrong?
Y -> od is empty.

Malso any fields in the header (P) struct is randomly filled partly due to the
fact that I don't know what they do, or even when I do, they are used for
conversion LI -> Hb and hence I assume will not be used again throughout the
rest of the processing pipline. They are as follows:

P -> wav 1x2 int : I don't know what this does, currently zeros
P -> fs int : I don't know what this does, currently zero
P -> base 1x2 int : value range perhaps, but not for Hb... fixed to [1, 100] atm. 
P -> d : No clue.... currently zero too.
P -> acoef 2x2 float : Conversion coefficients. Currently randomly generated 2x2 
P -> dpf 1x2 float: Possibly also conversion coef. Not sure. Also randomly generated.

The hope is that none of these parameters are actually used for further
processing in spm fnirs. If they are, then we are in trouble.


