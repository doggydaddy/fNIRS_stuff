#!/usr/bin/Rscript
args <- commandArgs(TRUE);

input_filename = args[1];
brik_nr <- strtoi(args[2]);
output_filename <- args[3];

system( paste0("3dmaskdump -o tmp.dump ", input_filename, "''[", brik_nr, "]''") );

d <- read.table('tmp.dump');
N <- dim(d)[1];
if ( N != 32 ) {
    print('N is not 32! something is wrong!');
    exit(1);
}
output_a <- array(0, dim=c(N, 3));
output_a[, 3] <- d[, 4];

for ( i in 1:N ) {
    if ( d[i,1] == 0 ) {
        output_a[i,1] <- "oxy";
    } else {
        output_a[i,1] <- "doxy";
    }
    channel <- 8*d[i,2] + (d[i,3]+1);
    output_a[i,2] <- channel;
}

write.csv(output_a, file=output_filename, row.names=FALSE);
system( "rm tmp.dump" );
