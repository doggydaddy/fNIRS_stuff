#!/usr/bin/Rscript
args <- commandArgs(TRUE);

require(stringr);
require(withr);

# reading input arguments:
# usage ./loadDatatoTemplate.R <input data filename> <mask filename> <output data filename>
# <input data filename> the input data should be in .txt format (this could change though, but not likely anytime soon)
# <mask filename> the 3dmaskdump results of the template prepared prior
# <output data filename> is the name of the output data file
#
idata <- args[1];

# load support functions 
source('fnirs_rfunctions.R');

# reading data
if ( grepl("no_HRV", idata) ) {
    data <- importData_noHRV( idata );
} else {
    data <- importData( idata );
}

ndata <- dim(data$oxy)[1];
# hard-coding the number of channels
nchannels <- 16;

# making of a fake dataset (NOT according to template)
# i: 0 = oxy, 1 = doxy
coord_i <- array(0, dim=32);
coord_i[1:16] <- 0;
coord_i[17:32] <- 1;
# j: 0 = channels 1-8, 2 = channels 9-16
coord_j <- array(0, dim=32);
coord_j[1:8] <- 0
coord_j[9:16] <- 1
coord_j[17:24] <- 0
coord_j[25:32] <- 1
# k: channels, indexing starts at 0
coord_k <- array(0, dim=32);
coord_k[1:16] <- seq(0,7);
coord_k[9:16] <- seq(0,7);
coord_k[17:24] <- seq(0,7);
coord_k[25:32] <- seq(0,7);

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
system(paste0("./fnirs_dumpToTemplate.sh ", idata, " >/dev/null 2>&1"));
