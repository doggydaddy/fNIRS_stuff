Extra step: extract hrv and eda physio data from merged txt files into their
separate txt files

Should be done before running 1st level glm scripts (if the scripts themselves
need them as covariates). Assumes "hrv" data is raw heart-rate from pulsemeter.

Usage: Run ./hrveda_wrapperScript <datadir> <file_pattern>
Args: <datadir> is the folder with the merged txt files
      <file_pattern> should match all files to be processed (example: *.txt)
Dependencies:
	- hrveda_extract.R (work script)
		- R-base (R)
		- signal (R-package)
		- quantmod (R-package)
		- fnirs_rfunctions.R (support functions)

Details:
Will automatically try to download requires missing r-packages.

Calculate HRV from pulse data:
Use twice difference squared method for robust peak detection, then finds peaks
with filtering functions and sanity checks before calculating the rr-intervals.

Preparing EDA data:
Lowpass butterworth filter with cut-off freq=0.03

Quirks: 
Currently have logic to ignore the files with names including "NO_HRV",
as it indicates those files do not have hrv data.

Output: Generates .hrv and .eda txt files for each processed merged txt file 

