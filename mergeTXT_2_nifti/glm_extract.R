#!/usr/bin/Rscript

source('fnirs_rfunctions.R');

args <- commandArgs(TRUE);

inputData <- args[1];
flag <- strtoi(args[2]);
outputfileName <- args[3];

# reading data
if ( grepl("no_HRV", inputData) ) {
    d <- importData_noHRV( inputData );
} else {
    d <- importData( inputData );
}

if ( flag == 1 ) { #baseline
}
if ( flag == 2 ) { #stroop
    tmp_glm1 <- fixglm_stroop_vft(d$glm1);
    tmp_glm2 <- fixglm_stroop_vft(d$glm2);
    glm1 <- sumglm(tmp_glm1, tmp_glm2);
}
if ( flag == 3 ) { #vft
    glm1 <- fixglm_stroop_vft(d$glm1);
    glm2 <- fixglm_stroop_vft(d$glm2);
}
if ( flag == 4 ) { #fear
    glm1 <- fixglm_fear(d$glm1);
    glm2 <- fixglm_fear(d$glm2);
    glm3 <- sumglm(glm1, glm2);
}
if ( exists('glm1') ) {
    write.table(glm1, file=paste0(outputfileName,".glm1"), quote=FALSE, col.names=FALSE, row.names=FALSE);
}
if ( exists('glm2') ) {
    write.table(glm2, file=paste0(outputfileName,".glm2"), quote=FALSE, col.names=FALSE, row.names=FALSE);
}
if ( exists('glm3') ) {
    write.table(glm3, file=paste0(outputfileName,".glm3"), quote=FALSE, col.names=FALSE, row.names=FALSE);
}