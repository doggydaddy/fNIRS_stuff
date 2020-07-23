#!/usr/bin/Rscript
args <- commandArgs(TRUE);

input_filename = args[1];
output_filename <- args[2];

system( paste0("3dmaskdump -o tmp.dump ", input_filename) );

d <- read.table('tmp.dump');
N <- dim(d)[1];
if ( N != 32 ) {
    print('N is not 32! something is wrong!');
    exit(1);
}

n_briks <- system( paste0("3dinfo -nv ", input_filename), intern=TRUE );
print( paste0("number of briks = ", n_briks) );

output_a <- d;


label_string <- system( paste0("3dinfo -label ", input_filename), intern=TRUE );
labels <- strsplit(label_string, "|", fixed=TRUE);
labels <- unlist(labels);
labels <- labels[-1:-9];
labels <- gsub("#[0-9]", "", labels)
labels <- c("oxy/doxy", "channel", labels)
print(labels)

for ( i in 1:N ) {
    if ( d[i,1] == 0 ) {
        output_a[i,1] <- "oxy";
    } else {
        output_a[i,1] <- "doxy";
    }
    channel <- 8*d[i,2] + (d[i,3]+1);
    output_a[i,2] <- channel;
}

output_a <- output_a[, -3:-12];
colnames(output_a) <- labels;

write.csv(output_a, file=output_filename, row.names=FALSE);
system( "rm tmp.dump" );
