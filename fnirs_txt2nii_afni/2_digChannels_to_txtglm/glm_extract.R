#!/usr/bin/Rscript

# Main working script for glm_wrapperScript.sh uses functions defined in
# fnirs_rfunctions.R to perform most of the work.

# For baseline task, nothing will be done.
# For stroop task, a single glm (*.glm1) will be generated as the sum of
# congruent and incongruent digital channels combined.
# For fear task, three glms will be produced.
# 	- glm1 = feel (assumed)
# 	- glm2 = suppress (assumed)
# 	- glm3 = feel or suppress (i.e. task) 
# For vft task, two glms will be produced, which corresponds exactly to the
# dig1 and dig2 channels in the paradigm.

# How the digital channels are prepared are implemented in fnirs_rfunctions.R,
# if any bugs/errors are found in how the glms are produced, code in
# corresponding "fixglm_<paradigm>" function should be patched.

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
