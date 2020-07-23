#!/usr/bin/Rscript
# --------------
# <Dependencies>
# --------------
list.of.packages <- c("quantmod", "signal")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

suppressMessages(require(signal))
suppressMessages(require(quantmod))
# ---------------
# </Dependencies>
# ---------------

# -------
# <Debug>
# -------
DEBUG <- TRUE;
dbg_print <- function ( string ) {
    if (DEBUG) {
        debug_str <- "DEBUG:";
        print( paste(debug_str, string) );
    }
}
dbg_printvar <- function ( variable ) {
    if (DEBUG) {
        debug_str <- "DEBUG:";
        var_name <- deparse(substitute(variable));
        var_value <- variable;
        print( paste(debug_str, var_name, "=", var_value));
    }
}
# --------
# </Debug>
# --------

source('fnirs_rfunctions.R');

# --------------------
# <Support_Functions>
# --------------------

twicediffsquared <- function( input.data ) {
    d1 <- diff(input.data);
    d2 <- diff(d1);
    ddsq <- d2^2;
    return( smooth(ddsq) );
}

findpeaks <- function(x, th=0.01, maxrange=10, samplingrate=100) {
    N <- length(x);
    #require package quantmod;
    peaks_xcoords <- findPeaks(x, thresh=th);
    nr_peaks <- length(peaks_xcoords);
    if ( nr_peaks == 0 ) {
        print('ERROR!!! No peaks were found! Is the recording OK?');
        return(1);
    }
    # rudimentary filtering function
    for ( i in 1:(nr_peaks-1) ) {
        if ( peaks_xcoords[i+1] - peaks_xcoords[i] < 50 ) {
            peaks_xcoords[i] <- 0;
        }
    }
    peaks_xcoords <- peaks_xcoords[peaks_xcoords!=0]; # removing all zeroed out peaks coords
    nr_peaks <- length(peaks_xcoords); # updating number of peaks after filtering
    for ( i in 1:nr_peaks ) {
        peaks_xcoords[i] <- trimpeak(x, peaks_xcoords[i]);
    }        
    peaks <- cbind(peaks_xcoords, x[peaks_xcoords]);
    rr <- diff(peaks[,1]); rr <- rr/samplingrate;
    average_rr <- mean(rr);
    n <- length(rr)+1;
    rr[n] <- average_rr;

    # filtering of rr-intervals
    i <- 1;
    while ( i < n ) {
        rr <- (peaks[i+1,1] - peaks[i,1])/samplingrate;
        if (rr < 0.7*average_rr) {
            # rudimentary filtering didn't do its job properly
            # eliminate the second peak
            #dbg_print("eliminating point");
            peaks <- peaks[-(i+1), ];
            n <- n-1;
        } else if ( rr > 1.5*average_rr && i > 1 ) {
            dbg_print( "skipped a beat, attempting to relocate:" );
            newpeak <- forcedetectpeak(x, peaks[i,1], peaks[i+1,1], average_rr, samplingrate);
            peaks <- rbind(peaks[1:i,], newpeak, peaks[(i+1):n,]);
            n <- n+1;
        }
        i <- i + 1;
    }
    return( peaks );
}

forcedetectpeak <- function(data_tc, start_point, end_point, average_rr, sampling_rate) {
    offset <- floor(0.1 * average_rr * sampling_rate);
    bit <- data_tc[(start_point+offset):(end_point-offset)];
    dd_bit <- twicediffsquared(bit);
    peak_x <- which(dd_bit==max(dd_bit))[1];
    if ( !exists("peak_x") ) {
        dbg_print( "forcedetectpeak failed to detect a peak!");
        the_peak <- c(-1, -1);
    } else {
        peak_x <- trimpeak(bit, peak_x);
        peak_x <- start_point + offset + peak_x;
        the_peak <- c(peak_x, data_tc[peak_x]);
    }
    return( the_peak ) ;
}

trimpeak <- function(data_tc, peak_x, maxrange=10 ) {
    if ( (peak_x - maxrange < 0) || peak_x + maxrange > length(data_tc) ) {
        maxrange <- min(peak_x, (length(data_tc)-peak_x));
    }
    xloc_range_min <- max(c(0, peak_x-maxrange));
    xloc_range_max <- min(c(peak_x+maxrange,length(data_tc)));
    xloc_range <- c(xloc_range_min, xloc_range_max);
    ecg_bit <- data_tc[xloc_range[1]:xloc_range[2]];
    sub_factor <- (max(ecg_bit)-min(ecg_bit))/2;
    ecg_bit <- ecg_bit - sub_factor;
    offsetidx <- which(ecg_bit==max(ecg_bit));
    newpeak_x <- peak_x-maxrange+offsetidx[1];
    if ( !exists("newpeak_x") ) {
        dbg_print( "trimpeak: something went horribly wrong!");
        dbg_print( "trimpeak: newpeak_x doesn't exists!");
        dbg_print( "trimpeak: ...reverting to input peak x-coordinate");
        newpeak_x <- peak_x;
    }
    if ( newpeak_x < 1 ) {
        dbg_print( "trimpeak: something went horribly wrong!");
        dbg_printvar( newpeak_x );
        dbg_printvar( offsetidx );
        dbg_print( "trimpeak: ... forcing valid index (1) for sanity");
        newpeak_x <- 1;
    }
    return( newpeak_x );
}

rrtc <- function(ecg, peaks, sampling_rate=100) 
{
    N <- length(ecg);
    peaks_x <- peaks[,1]
    rr <- diff(peaks_x)
    rr <- rr/sampling_rate
    average_rr <- mean(rr)
    n <- length(rr)+1
    rr[n] <- average_rr

    r.o <- array(0, dim=N);
    r.o[peaks_x] <- rr;
    sliding_value = 0;
    for ( i in peaks_x[1]:N ) {
        if ( r.o[i] != 0 ) {
            sliding_value <- r.o[i];
        } else {
            r.o[i] <- r.o[i-1]
        }
    }    
    for ( i in 1:length(r.o) ) {
        if ( r.o[i] == 0 && i < peaks_x[1] )
            r.o[i] <- average_rr;
    }
    return(r.o);
}
    
prepEDA <- function( eda.raw.signal ) {
    # requires package signal
    bf <- butter(4, 0.03, type="low")
    z <- filter(bf, data$eda)
    z[1:250] <- z[251]
    return(z);
}

prepHRV <- function ( ecg.raw.data ) {
    dd <- twicediffsquared(ecg.raw.data);
    dd <- dd*10;
    peaks <- findpeaks(dd);
    z <- rrtc(ecg.raw.data, peaks);
    return(z);
}
# --------------------
# </Support_Functions>
# --------------------

# ----------------------
# <Main_Script_Function>
# ----------------------
args <- commandArgs(TRUE)
input_data <- args[1]
output_file_name <- args[2]

data <- importData(input_data);
#eda <- prepEDA(data$eda);
eda <- data$eda;
write.table(eda, file=paste0(output_file_name,".eda"), quote=FALSE, row.names=FALSE, col.names=FALSE);
#ecg <- prepHRV(data$ecg);
ecg <- data$hrv;
write.table(ecg, file=paste0(output_file_name,".ecg"), quote=FALSE, row.names=FALSE, col.names=FALSE);
#par(mfrow=c(2,1))
#plot(ecg, type='l', col="red")
#plot(eda, type='l', col="green")
# -----------------------
# </Main_Script_Function>
# -----------------------