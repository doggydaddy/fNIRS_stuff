#!/usr/bin/Rscript
args<-commandArgs(TRUE);

inputFile <- args[1];
indc <- strtoi(args[2]);
options(digits=5)
thresh <- as.double(args[3]);
require(tools)
filename <- file_path_sans_ext(inputFile);

command <- paste0("3dcalc -a ", inputFile, "'[",indc,"]' -expr 'a*ispositive(abs(a)-", thresh, ")' -prefix tmpthreshed.nii");
system(command);
system("3dmaskdump -o tmp tmpthreshed.nii");


d <- read.table("tmp");
t <- read.table("fNIRS_template.txt");
out_oxy <- t;
out_doxy <- t;
N <- 32;
require(utils);
pb <- txtProgressBar(min=0, max=N, style=3);
for (i in 1:32) {
    d_channel <- (d[i,2]*8)+d[i,3]+1;
    t_rows <- which(t[ ,4] == d_channel);
    # sanity checking
    if ( length(t_rows) != 2 ) {
        print("something has gone horribly wrong! t_rows != 2");
        exit(1);
    }
    if ( d[i, 1] == 0 ) {
        out_oxy[t_rows[1], 4] <- d[i, 4];
        out_oxy[t_rows[2], 4] <- d[i, 4];
    } else {
        out_doxy[t_rows[1], 4] <- d[i, 4];
        out_doxy[t_rows[2], 4] <- d[i, 4];
    }
    setTxtProgressBar(pb, i);
}
close(pb);

write.table(out_oxy, file="tmp.oxy.nii", 
            quote=FALSE, col.names=FALSE, row.names=FALSE);
write.table(out_doxy, file="tmp.doxy.nii", 
            quote=FALSE, col.names=FALSE, row.names=FALSE);

system(paste0("3dUndump -datum float -mask fNIRS_template_mask.nii -master fNIRS_template.nii -ijk -prefix ", filename, ".oxy.nii tmp.oxy.nii"));
system(paste0("3dUndump -datum float -mask fNIRS_template_mask.nii -master fNIRS_template.nii -ijk -prefix ", filename, ".doxy.nii tmp.doxy.nii"));


system("rm tmp*");

