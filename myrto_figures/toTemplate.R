#!/usr/bin/Rscript
args<-commandArgs(TRUE);

require(utils);
require(tools)
options(digits=5)

inputFile <- args[1];
filename <- file_path_sans_ext(inputFile);

d <- read.csv(inputFile);
t <- read.table("fNIRS_template.txt");
out <- t;
N <- 16;
pb <- txtProgressBar(min=0, max=N, style=3);
for (i in 1:N) {
    d_channel <- d[i, 1];
    t_rows <- which(t[ ,4] == d_channel);
    # sanity checking
    if ( length(t_rows) != 2 ) {
        print("something has gone horribly wrong! t_rows != 2");
        exit(1);
    }
    out[t_rows[1], 4] <- d[i, 2];
    out[t_rows[2], 4] <- d[i, 2];
    setTxtProgressBar(pb, i);
}
close(pb);

write.table(out, file="tmp.oxy.nii", 
            quote=FALSE, col.names=FALSE, row.names=FALSE);

system(paste0("3dUndump -datum float -mask fNIRS_template_mask.nii -master fNIRS_template.nii -ijk -prefix ", filename, ".oxy.nii tmp.oxy.nii"));
system("rm tmp*");

