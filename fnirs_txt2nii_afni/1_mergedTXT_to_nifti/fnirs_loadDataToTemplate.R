#!/usr/bin/Rscript

# Main working script for fnirs_wrapperScript.sh
# loads merged .txt file (fNIRS) into a .nii file
# 
# Usage: ./loadDatatoTemplate.R <input_filename>
# Args: 
# <input_filename> the input data; merged .txt file
# Example: ./loadDatatoTemplate.R data_directory/subjectA/run1.txt

# Details:
# The R script/program reads the merged .txt data, 
# sorts it according to a fake template
# and writes temporary asci (text) files, 
# one file per time-point to disk.
# Finally the script calls fnirs_dumpToTemplate.sh, 
# containing AFNI program commands to "undump" the tmp asci files to .niis 
# and finally concatenates all the .nii files into time-series 
# (see fnirs_dumpToTemplate.sh for more details).

args <- commandArgs(TRUE);

# loading required packages
require(stringr);
require(withr);

idata <- args[1];

# load support functions 
source('fnirs_rfunctions.R');

# reading data, using support function importData/importData_noHRV
if ( grepl("no_HRV", idata) ) {
    data <- importData_noHRV( idata );
} else {
    data <- importData( idata );
}

ndata <- dim(data$oxy)[1];
# hard-coding the number of channels
nchannels <- 16;

# making of a fake dataset
# according to theoretical template (i.e. not from a file)

# i: 0 = oxy;
#    1 = doxy
coord_i <- array(0, dim=32);
coord_i[1:16] <- 0;
coord_i[17:32] <- 1;
# j: 0 = channels 1-8;
#    1 = channels 9-16
coord_j <- array(0, dim=32);
coord_j[1:8] <- 0
coord_j[9:16] <- 1
coord_j[17:24] <- 0
coord_j[25:32] <- 1
# k: Channel (8*j)+(k+1), 
#    Indexing starts at 0
#    Example: .nii coordinate (i,j,k)=(1,1,2) 
#             is doxy channel [(8*j)+(k+1)]=11
coord_k <- array(0, dim=32);
coord_k[1:16] <- seq(0,7);
coord_k[9:16] <- seq(0,7);
coord_k[17:24] <- seq(0,7);
coord_k[25:32] <- seq(0,7);

# match data with template coordinates and convert data to tmp asci txt files
N <- nchar(ndata);
for ( i in 1:ndata ) {
    values <- c(as.numeric(data$oxy[i, ]), as.numeric(data$doxy[i, ]));
    outp <- cbind(coord_i, coord_j, coord_k, values);

    # saving output to asci format
    with_options(
                 c(scipen = 999),
                 num <- str_pad(i, N, pad="0")
                );
    write.table(outp, file=paste0("tmp",num,".1D"), 
                quote=FALSE, row.names=FALSE, col.names=FALSE);
}
# call fnirs_dumpToTemplate.sh
system(paste0("./fnirs_dumpToTemplate.sh ", idata, " >/dev/null 2>&1"));
