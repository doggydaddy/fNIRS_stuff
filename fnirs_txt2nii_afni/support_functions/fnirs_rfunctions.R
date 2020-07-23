importData <- function ( file.name ) {
  data <- read.table(file.name, fill=TRUE);
  N <- length(data[,1]);
  clip_length <- 50; # cut 50 time points at the end
  tc_range <- 1:(N-clip_length)
  ecg <- data[tc_range, 1];
  eda <- data[tc_range, 2];
  glm1 <- data[tc_range, 3];
  glm2 <- data[tc_range, 4];
  doxy <- data[tc_range, seq(5,36,2)];
  oxy <- data[tc_range, seq(6,36,2)];
  r.o <- list("oxy"=oxy, "doxy"=doxy, "glm1"=glm1, "glm2"=glm2, "hrv"=ecg, "eda"=eda);
  return( r.o );
}

importData_noHRV <- function ( file.name ) {
  data <- read.table(file.name, fill=TRUE);
  N <- length(data[,1]);
  clip_length <- 50; # cut 50 time points at the end
  tc_range <- 1:(N-clip_length)
  eda <- data[tc_range, 1];
  glm1 <- data[tc_range, 2];
  glm2 <- data[tc_range, 3];
  doxy <- data[tc_range, seq(4,35,2)];
  oxy <- data[tc_range, seq(5,35,2)];
  r.o <- list("oxy"=oxy, "doxy"=doxy, "glm1"=glm1, "glm2"=glm2, "eda"=eda);
  return( r.o );
}

# support function to sum two glms together
sumglm <- function ( raw_glm1 , raw_glm2 )
{
  N <- length( raw_glm1 );
  sum_glm <- array(0, dim=N);
  for ( i in 1:N )
  {
    sum_glm[i] <- max(raw_glm1[i], raw_glm2[i]);
  }
  return( sum_glm );
}

# run this on fear data
fixglm_fear <- function( raw_glm )
{
  N <- length( raw_glm );
  fixed_glm <- array(0, dim=N);

  block_length <- 305;
  ins_mrk <- 20;
  for ( i in 2:(N-block_length) )
  {
    if ( raw_glm[i] > 0 && 
         raw_glm[i-1] < 1 &&
         raw_glm[i+ins_mrk] > 0 &&
         fixed_glm[i] < 1
         ) 
    {
      fixed_glm[i:(i+block_length)] <- 1;
      fixed_glm[(i+block_length):(i+block_length+ins_mrk)] <- 0;
      i <- i + block_length + ins_mrk;
    }
  }
  return( fixed_glm );
}

# run this on stroop and vft data
fixglm_stroop_vft <- function ( raw_glm )
{
  N <- length( raw_glm );
  fixed_glm <- array(0, dim=N);
  for ( i in 1:N ) {
    if ( raw_glm[i] > 3) {
      fixed_glm[i] <- 1;
    } else {
      fixed_glm[i] <- 0;
    }
  }
  return ( fixed_glm ); 
}

# detrend function
# for preprocessing cell
Order3Detrend <- function( eda ) {
    x <- seq(1, length(eda))
    x <- x/8
    df <- data.frame("t"=x, "eda"=eda)
    baseline <- lm(eda~t+I(t^2)+I(t^3), data=df)
    # return the detrended time course, but make it absolutely positive.
    if ( min(baseline$residuals) < 0 ) {
        r.o <- baseline$residuals + abs( min(baseline$residuals) )
    } else {
        r.o <- baseline$residuals
    }
    return( r.o )
}

# block duration is known to be 305 (empirical testing)
#valid for emo fear only!
fearBlockDuration <- 305
#valid for stroop only!
stroopBlockDuration <- 240
# 30 seconds * 8 Hz = 240 time units

# rise time function
riseTime <- function( x_data, y_data, start_index, stop_index=start_index+as.integer(fearBlockDuration/3) ) {
    ymax <- max(y_data[start_index:stop_index])
    ymax_index <- which( y_data == ymax )
    if ( length(ymax_index) > 1 ) {
        ttp <- ymax_index[1] - start_index
    } else {
        ttp <- ymax_index - start_index
    }
    start_offset <- 80 # should the baseline be hard-coded like this?
    if ( start_index > start_offset ) {
        baseline <- y_data[(start_index):start_index]
    } else {
        baseline <- y_data[(start_index-start_offset):start_index] 
    }
    baseline_value <- mean(baseline)
    peak_amplitude <- ymax - baseline_value
    if ( peak_amplitude < 0 ) {
        # no signal! return "NA"
        rise_time <- NA
    } else {
        rise_time <- peak_amplitude / ttp 
    }
    return( rise_time )
}

# support function to get block start locations, three variations

# for emo fear only
getBlockStarts_fear <- function( glm1 , glm2 ) {  
    # generate x axis
    unit_time <- 1:length( glm1 )
    # find first block
    sum_glm <- fixglm_fear( glm1 + glm2 )
    N <- length(sum_glm)
    blockStartIndices <- array(0, dim=6)
    c <- 1
    for ( i in 10:(N-1) ) {    # leave a bit or wriggle room at the start
        if ( sum_glm[i] == 0 && sum_glm[i+1] > 0) {
            # found a block start location
            blockStartIndices[c] <- i+1
            c <- c+1
        }
    }
    if ( c != 7 ) {
        print("Error: GetBlockStarts:")
        print("Error in finding block start!")
        print("Expected 6 block start locations")
        print(paste0("Found ", c-1))
        return(list("blockStartIndices"=rep(-1, 6), "fors"=rep(-1, 6)))
    }
    fors <- array(0, dim=6)
    offset <- 10
    for ( j in 1:6 ) {
        if ( glm1[blockStartIndices[j]+offset] > 0) {
            fors[j] <- 1 #feel
        } else {
            fors[j] <- 2 #suppress
        }
    }
    return( list("blockStartIndices"=blockStartIndices, "fors"=fors) )
}
# for vft only (warning! no safety is currently built into this one!)
getBlockStart_vft <- function(glm1, glm2) {
    #generate x axis
    N <- length(glm1)
    unit_time <- 1:N
    # find start of glm1
    for( i in 10:(N-1) ) {
        if ( glm1[i] == 0 && glm1[i+1] > 0 ) {
            glm1_start <- i+1
        }
        if ( glm1[i] > 0 && glm1[i+1] == 0 ) {
            glm1_end <- i+1
        }
        if ( glm2[i] == 0 && glm2[i+1] > 0 ) {
            glm2_start <- i+1
        }
        if ( glm2[i] > 0 && glm2[i+1] == 0 ) {
            glm2_end <- i+1
        }
    }
    if ( !exists("glm1_start") || !exists("glm1_end") || !exists("glm2_start") || !exists("glm2_end") ) {
        print("Error! cannot get all starts and ends of VFT paradigm!")
        glm1_start <- -1
        glm1_end <- -1
        glm2_start <- -1
        glm2_end <- -1
    }
    return( c(glm1_start, glm1_end, glm2_start, glm2_end) )
}
# for stroop only
getBlockStarts_stroop <- function(glm1, glm2) {
    # generate x axis
    unit_time <- 1:length( glm1 )
    # find first block
    sum_glm <- fixglm_stroop_vft( glm1 + glm2 )
    N <- length(sum_glm)
    blockStartIndices <- array(0, dim=8)
    c <- 1
    for ( i in 10:(N-1) ) {    # leave a bit or wriggle room at the start
        if ( sum_glm[i] == 0 && sum_glm[i+1] > 0) {
            # found a block start location
            blockStartIndices[c] <- i+1
            c <- c+1
        }
    }
    if ( c != 9 ) {
        print("Error: GetBlockStarts:")
        print("Error in finding block start!")
        print("Expected 8 block start locations")
        print(paste0("Found ", c-1))
        blockStartIndices <- rep(-1, 8)
    }
    return( blockStartIndices )
}
