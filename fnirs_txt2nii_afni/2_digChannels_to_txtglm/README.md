Step 2: Format digital channels Appropriately.
Run glm_wrapperScript.sh to extract digital signals from merged
txt files into their separate files

From glm_wrapperScript.sh:

Usage: ./glm_wrapperScript.sh <data_dir> <filename_pattern>
Same arguments as fnirs_wrapperScript.sh
Args:
<data_dir>: Folder where all data to be processed (merged *.txt files) are located.
            The files may be located in subdirectories.
            <data_dir> should be the main data directory.
<filename_pattern>: A common file name pattern (such as *.txt) to match all
                    files to be processed in <data_dir>

Dependencies:
- glm_extract.R (main working script)
   - fnirs_rfunctions.R (functions to "fix" digital channels, and functions
   		           to grab start of block for each of the three paradigms)

Output:
For each input merged txt file, checks filename for which type of paradigm
the file is, and outputs eda, hrv, and glm(s) accordingly. Hence filenames
must contain text that uniquely identifies its paradigm.

from glm_extrat.R:

For baseline task, nothing will be done.
For stroop task, a single glm (*.glm1) will be generated as the sum of
congruent and incongruent digital channels combined.
For fear task, three glms will be produced.
	- glm1 = feel (assumed)
	- glm2 = suppress (assumed)
	- glm3 = feel or suppress (i.e. task) 
For vft task, two glms will be produced, which corresponds exactly to the
dig1 and dig2 channels in the paradigm.

How the digital channels are prepared are implemented in fnirs_rfunctions.R,
if any bugs/errors are found in how the glms are produced, code in
corresponding "fixglm_<paradigm>" function should be patched.

