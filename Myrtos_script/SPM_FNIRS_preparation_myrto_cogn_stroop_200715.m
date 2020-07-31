%% Prepare Acqknowledge data for SPM_FNIRS analysis
function SPM_FNIRS_preparation_myrto_cogn_stroop()

% EDIT BELOW HERE TO FIT YOUR DATA AND ANALYSIS REQUIREMENTS
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

% a little information about the data
sample_freq = 125; % sampling frequency in Hz
time_prior = 30; % in seconds

%% The directory where the data analysis should take place.
% - Should contain a folder called "raw_data" with the raw data text files
% The raw data text files should be named as follows: [PAT_ID]_[PARADIGM]_[TIMEPOINT].txt
% For example: "AB-1415_VFT_pre.txt", "AB-1415_stroop_post.txt".
%
% OBS: emo paradigms ("emo fear" and "emo disgust") should be labeled as "emo_fear" and 
% "emo_disgust" in the file name. For example: "AB-1415_emo_fear_pre.txt". 
%
% - Should contain a folder called "Optode_positions" where the optode positions files 
%   are located (made by Myrto). They should be called "ch_config.csv" and "optode_positions_MNI.csv"
% - Should contain a folder called "meta_data_dir" where the file containing patient 
%   ages are located. That file should be called "patient_ages.txt". 
%   The patient ages file should be a tab delimited text file with the first column containing
%   patient ID:s and the second column containing patient ages, example below:
%
%
%   pat_id	age
%   MN-2541	24
%   RR-4399	55
%   ML-8084	67
%
%
base_data_dir = '/Users/msklivan/Documents/MATLAB/Analysis_all_Control1/Data_All_Control';


% SPM FNIRS path
spm_path = '/Users/msklivan/Documents/MATLAB/spm12';
spm_fnirs_path = '/Users/msklivan/Documents/MATLAB/spm_fnirs';


% SETTINGS USED FOR THE ANALYSIS
%--------------------------------------------------------------------------

%% Temporal preprocessing settings used
% MARA processing
% temporal_preproc_settings.M.type = 'MARA';
temporal_preproc_settings.M.type = 'no';

% ALL channels
temporal_preproc_settings.M.chs = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]; % ALL channels

% Moving window length
temporal_preproc_settings.M.L = 2;

% Threshold factor-motion detection
temporal_preproc_settings.M.th = 3;

% Smoothing factor-motion artifact
temporal_preproc_settings.M.alpha = 5;

% Band-stop filter with "stopband frequencies" in Hz
temporal_preproc_settings.C.type = 'Band-stop filter';
temporal_preproc_settings.C.cutoff = [0.12 0.35; 0.7 2.0];

% Change sampling rate to 1Hz
temporal_preproc_settings.D.type = 'yes';
temporal_preproc_settings.D.nfs = 1;

% Detrending
temporal_preproc_settings.H.type = 'DCT';
temporal_preproc_settings.H.cutoff = 128;

% Skip detrending for some of the paradigms
skip_detrending_for_paradigms = ["VFT"];

% No temporal smoothing!
temporal_preproc_settings.L.type = 'no';

%% 1st level parameters
% chromophores to be analysed (ALL)
first_level_params.str_nirs{1,1} = 'HbO';
first_level_params.str_nirs{2,1} = 'HbR';
first_level_params.str_nirs{3,1} = 'HbT';

% Experiment design 
first_level_params.experiment_design = 'secs';

% Basis function
first_level_params.basis_function = 'hrf (with time and dispersion derivatives)';

% Covariates
first_level_params.covariates = 0;

% Correct for serial correlations
first_level_params.correct_serial_correlations = 'AR(1)'; % Alternative is 'none'

%% Contrasts
% EMO FEAR
contrasts.emo_fear(1).name = char("Feel-Rest");
contrasts.emo_fear(1).STAT = "T";
%contrasts.emo_fear(1).contrast_str = char("1 1 1 0 0 0 0");
contrasts.emo_fear(1).contrast_str = char("1 0 0 0 0 0 0");

contrasts.emo_fear(2).name = char("Suppress-Rest");
contrasts.emo_fear(2).STAT = "T";
%contrasts.emo_fear(2).contrast_str = char("0 0 0 1 1 1 0");
contrasts.emo_fear(2).contrast_str = char("0 0 0 1 0 0 0");

contrasts.emo_fear(3).name = char("Suppress-Feel");
contrasts.emo_fear(3).STAT = "T";
%contrasts.emo_fear(3).contrast_str = char("-1 -1 -1 1 1 1 0");
contrasts.emo_fear(3).contrast_str = char("-1 0 0 1 0 0 0");

% EMO DISGUST
contrasts.emo_disgust(1).name = char("Feel-Rest");
contrasts.emo_disgust(1).STAT = "T";
%contrasts.emo_disgust(1).contrast_str = char("1 1 1 0 0 0 0");
contrasts.emo_disgust(1).contrast_str = char("1 0 0 0 0 0 0");

contrasts.emo_disgust(2).name = char("Suppress-Rest");
contrasts.emo_disgust(2).STAT = "T";
%contrasts.emo_disgust(2).contrast_str = char("0 0 0 1 1 1 0");
contrasts.emo_disgust(2).contrast_str = char("0 0 0 1 0 0 0");

contrasts.emo_disgust(3).name = char("Suppress-Feel");
contrasts.emo_disgust(3).STAT = "T";
%contrasts.emo_disgust(3).contrast_str = char("-1 -1 -1 1 1 1 0");
contrasts.emo_disgust(3).contrast_str = char("-1 0 0 1 0 0 0");

% STROOP
contrasts.stroop(1).name = char("Task-Rest");
contrasts.stroop(1).STAT = "T";
contrasts.stroop(1).contrast_str = char("1 0 0 0");

% VFT
contrasts.VFT(1).name = char("Task-Rest");
contrasts.VFT(1).STAT = "T";
%contrasts.VFT(1).contrast_str = char("0 0 0 1 1 1 0");
contrasts.VFT(1).contrast_str = char("0 0 0 1 0 0 0");

contrasts.VFT(2).name = char("Vowel-Rest");
contrasts.VFT(2).STAT = "T";
%contrasts.VFT(2).contrast_str = char("1 1 1 0 0 0 0");
contrasts.VFT(2).contrast_str = char("1 0 0 0 0 0 0");

contrasts.VFT(3).name = char("Task-Vowel");
contrasts.VFT(3).STAT = "T";
%contrasts.VFT(3).contrast_str = char("-1 -1 -1 1 1 1 0");
contrasts.VFT(3).contrast_str = char("-1 0 0 1 0 0 0");

% AGE: Set this variable to give all patients the same age and skip the 
% pat_ages.txt file in the meta_data folder. Set it to something else than
% 0 to acieve this

fixed_pat_age = 30;

% Digital start signal: Indicates that the digital channels in the data have 
% "start signal". That means that one of the channels are positive for a brief
% moment before the first rest phase begins. If this is set to false and no 
% signal is detected within 30s of data start, the paradigm will be assumed to
% start 30s before the first digital channel. 

% Can not be empty. If no paradigms have start signals, put "NONE" in the array instead 
% i.e digital_start_signal = ["NONE"];
digital_start_signal = ["emo_fear", "emo_disgust"];

% Shorter length of first rest phase? Some data has been cut in the beginning so that the 
% first rest phase is too short (<30s). To take this into consideration, put the length of 
% the first rest phase here. Replace "-" with "_" in the patient IDs if necessary.

shorter_first_rest.("Subj15").("stroop").("CTRL") = 24;
shorter_first_rest.("Subj6").("stroop").("CTRL") = 25;
shorter_first_rest.("Subj75").("emo_fear").("CTRL") = 11;
shorter_first_rest.("Subj75").("emo_fear").("CTRL") = 11;
shorter_first_rest.("Subj76F").("emo_fear").("CTRL") = 14;
shorter_first_rest.("Subj77").("emo_fear").("CTRL") = 14;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% STOP EDITING HERE!


raw_data_dir = fullfile(base_data_dir, "myrto_raw_data");
positions_dir = fullfile(base_data_dir, "Optode_positions");
meta_data_dir = fullfile(base_data_dir, "meta_data", "myrto");

cd(base_data_dir);

% Make an output data dir if it does not exist
output_data_dir = fullfile(base_data_dir, "myrto_output_data");
if ~exist(output_data_dir, 'dir'), mkdir(output_data_dir); end

% Make a temporary folder for the Y.mat and P.mat files.
temp_dir = fullfile(base_data_dir, "temp");
if ~exist(temp_dir, 'dir'), mkdir(temp_dir); end

% Create a new output data dir
if ~exist(output_data_dir, "dir"), mkdir(output_data_dir); end

% Add SPM and SPM FNIRS to the path
addpath(spm_path);
addpath(spm_fnirs_path);
addpath(output_data_dir);
addpath(positions_dir);

% STOLEN from spm_fnirs/spm_fnirs.m
mdir = fileparts(which('spm_fnirs'));
sdir = fullfile(mdir, 'nfri_functions');
addpath(genpath(sdir));
addpath(fullfile(mdir, 'canonical')); 
addpath(genpath(fullfile(mdir, 'external'))); 
addpath(fullfile(mdir, 'gen_conimg')); 

% Add the base data dir and subfolders to the path
%addpath(genpath(base_data_dir));

% Paradigms: A list of names of the paradigms that were ran
%paradigms = ["baseline" "emo_fear" "stroop" "VFT"];

% Output data for second level analysis
OUTDATA_TBL = array2table(zeros(0, 7), 'VariableNames', {'pat_id' 'paradigm' 'timepoint' 'signal' 'channel' 'contrast' 'cbeta'});

% Log file for errors
cur_time = datetime('now');
log_file_name = strcat("log_", datestr(cur_time, "yyyymmdd_HHMM"), ".txt");
log_file = fullfile(output_data_dir, log_file_name);
fid = fopen(log_file, 'at');

% Read all raw data files
raw_data_files = dir(raw_data_dir);

% Read all patient ages
if fixed_pat_age == 0
    pat_ages_file = fullfile(meta_data_dir, "patient_ages.txt");
    pat_ages = tdfread(pat_ages_file, 'tab');
    pat_id_ar = char(pat_ages.pat_id);
    pat_ages_ar = pat_ages.age;
end

% Some statistics for the log file
global already_analysed_files skipped_files_due_to_errors overfiltered_channels num_channels_masked;
already_analysed_files = strings(0);
skipped_files_due_to_errors = strings(0);
overfiltered_channels = strings(0);
num_channels_masked = 0;

for k = 1:length(raw_data_files)
    raw_data_filename = raw_data_files(k).name;

    % DO not process these files
    if raw_data_files(k).isdir || raw_data_filename == "." || raw_data_filename == ".." || raw_data_filename == "patient_ages.txt" || raw_data_filename == "masks.csv"
        continue;
    end

    % Remove the file ending
    file_name_and_ending = split(raw_data_filename, ".");
    file_name_without_ending = join(file_name_and_ending(1:end-1));

    % Split the file name into parts
    name_parts = split(file_name_without_ending, "_");

    % Expect at least 3 name parts (PAT_ID, PARADIGM, TIMEPOINT)
    if size(name_parts, 1) < 3
        write_to_log("SKIP", fid, "NO_PATIENT", "NO_PARADIGM", "NO_TIMEPOINT", 'The file "%s" does not have a valid file name. Expecting "PAT-ID_PARADIGM_TIMEPOINT.txt"', raw_data_filename);
        continue;
    end

    % Part 1 = Patient id
    pat_id = name_parts{1};

    % Part 2 and possibly 3 = paradigm
    if name_parts(2) == "emo"
        paradigm = strcat(name_parts(2), "_", name_parts(3));
        timepoint_idx = 4;
    else 
        paradigm = name_parts{2};
        timepoint_idx = 3;
    end

    % The final part equals the time point
    timepoint = name_parts{timepoint_idx};

    % If we have more name parts than this, it is probably a "no_HRV" file
    % The no_HRV files do not have a HRV column in the beginning, so the digital
    % channels are on index 2 and 3 instead of index 3 and 4.
    if length(name_parts) > timepoint_idx + 1 && name_parts(timepoint_idx + 1) == "no" && name_parts(timepoint_idx + 2) == "HRV"
        d1_idx = 2;
        d2_idx = 3;
    else
        d1_idx = 3;
        d2_idx = 4;
    end

    % The current patient´s age
    if fixed_pat_age == 0
        age_index = find(ismember(pat_id_ar, cellstr(pat_id)), 1);

        % If the pat ID is not in the ages file, use the median age instead.
        if size(age_index, 1) == 0
            age = round(median(pat_ages_ar));
        else 
            age = pat_ages_ar(age_index);
        end
    else
        age = fixed_pat_age;
    end

    % Print who we are working on currently
    fprintf("\n\n---------------------------------------------------------\n");
    fprintf('Current file: %s.\n', raw_data_filename);
    fprintf('Pat ID: %s.\n', pat_id);
    fprintf('Paradigm: %s.\n', paradigm);
    fprintf('Timepoint: %s.\n', timepoint);
    fprintf('Age: %d.\n', age);
    fprintf("---------------------------------------------------------\n\n");

    % Create a folder for the output data to be placed in
    pat_folder = fullfile(output_data_dir, pat_id);

    % Create the patient output dir
    if ~exist(pat_folder, "dir")
        mkdir(pat_folder);
        addpath(genpath(pat_folder));
    end

    paradigm_folder = fullfile(pat_folder, paradigm);
    if ~exist(paradigm_folder, "dir")
        mkdir(paradigm_folder);
        addpath(genpath(paradigm_folder));
    end

    timepoint_folder = fullfile(paradigm_folder, timepoint);

    % Remove the old timepoint folder if it exists, to remove all the old analyses.
    if exist(timepoint_folder, "dir")
        % IF we have an output file it means that this data is already analysed, continue
        cur_output_file = fullfile(timepoint_folder, "cBeta_output.csv");
        if isfile(cur_output_file)

            % Add it to the total table
            tbl = readtable(cur_output_file);
            OUTDATA_TBL = [OUTDATA_TBL; tbl];

            % No more analysis!
            %fprintf('Folder is already completed (%s), skipping...\n', timepoint_folder);
            write_to_log("SKIP", fid, pat_id, paradigm, timepoint, 'This analysis is already completed, skipping...');
            continue;
        end

        %fprintf('Deleting unfinished patient folder: %s.\n', timepoint_folder);
        write_to_log("INFO", fid, pat_id, paradigm, timepoint, 'Deleting unfinished patient folder (%s).', timepoint_folder);
        rmdir(timepoint_folder, 's');
    end

    mkdir(timepoint_folder);
    addpath(timepoint_folder);

    %%% BEGIN FILE PREPARATION. YANLU:s FIRST SCRIPT (cut_txt.m)

    % Read the raw data file to a matrix
    raw_data_file = fullfile(raw_data_dir, raw_data_filename);
    input_data_raw = readmatrix(raw_data_file);

    % first, determine end-of-line (EOL) characeter isread:
    % if your data has 37 lines instead of the 36 expected lines, is the 37th
    % line just NaNs (EOL characters?)
    % We expect 32 columns with channel data after the second digital channel
    exp_num_cols = d2_idx + 32; 
    if (size(input_data_raw, 2) == exp_num_cols + 1)
        if (sum(isnan(input_data_raw(:, exp_num_cols + 1))) == size(input_data_raw(:, exp_num_cols + 1), 1))
            % it probably is, remove it without further checks
            input_data_raw = input_data_raw(:, 1:exp_num_cols);
        end
    end

    input_data = rmmissing(input_data_raw);

    %%% Find blocks
    % d1 and d2 are the columns with paradigm indicators (digital channels)
    % sum digital channels (as I have no idea which gives the start ping)
    d1 = input_data(:, d1_idx);
    d2 = input_data(:, d2_idx);
    dig = d1 + d2;
    max_dig = max(dig);
    min_dig = min(dig);

    first_idx = find(dig, 1); % find first index which is not zero

    % Check how long this digital signal lasts, if it is less than a second, it is very likely 
    % a start signal
    dig_from_first = dig(first_idx:end);
    first_zero = find(~dig_from_first, 1) + first_idx;
    spike_length = first_zero - first_idx;

    % Check if the file is in the list of "shorter first rest phase" files.
    pat_id_underscore = strrep(pat_id, "-", "_");
    first_rest_length = -1;
    subtract_from_times = 0;
    if exist("shorter_first_rest", "var") 
        if isfield(shorter_first_rest, pat_id_underscore)
            if isfield(shorter_first_rest.(pat_id_underscore), paradigm)
                if isfield(shorter_first_rest.(pat_id_underscore).(paradigm), timepoint)
                    first_rest_length = shorter_first_rest.(pat_id_underscore).(paradigm).(timepoint);
                    subtract_from_times = time_prior - first_rest_length;
                    write_to_log("INFO", fid, pat_id, paradigm, timepoint, 'Using a modified first rest phase length: %ds.', first_rest_length);
                end
            end
        end
    end
    
    % "Baseline" files start from the beginning.
    if paradigm == "baseline"
        start_index = 1;
        fprintf("Baseline. Starting from 1.\n");

    % If we have a predetermined first rest length, set start index to 1
    elseif first_rest_length > 0
        start_index = 1;
        fprintf("Predetermined first rest length.\n");
    
    % Handle files that has one or more digital channels that starts positive.
    elseif first_idx == 1

        start_of_first_block = find_start_of_first_block(dig, paradigm, sample_freq, 1);
        start_index = start_of_first_block - (time_prior * sample_freq);
        fprintf("One or both digital channels positive from the beginning.\n");

    % We have a very short spike, it is therefor very likely a start signal
    elseif spike_length < sample_freq
        start_index = first_idx;
        fprintf("Start signal present in one digital channel.\n");
    
    % We have detected the start of task 1. 
    elseif first_idx > time_prior * sample_freq & length(find(contains(digital_start_signal, paradigm))) < 1

        % It seems like it is better to find the end of task 1 and subtracting block length from it instead
        start_of_first_block = find_start_of_first_block(dig, paradigm, sample_freq, first_idx);
        start_index = start_of_first_block - (time_prior * sample_freq);

        fprintf("Starting 30s before first signal for paradigm %s, since it does not seem to have a start signal.\n", paradigm);

    % If we have < 30s from start of file to first digital signal
    % OR if the paradigm is listed as having a start signal
    else 

        % IF a paradigm that was marked as not having a start signal still ended up here, put a warning in the log
        if length(find(contains(digital_start_signal, paradigm))) < 1
            write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: This file has the paradigm %s, that is not listed as having a start signal in the digital channel, but still a start signal was assumed, likely because the first index is very early in the file. Skipping.', paradigm);
            continue;
        end

        fprintf("Starting at the start signal that was detected for paradigm %s\n", paradigm);
        start_index = first_idx;
    end
    
    % sanity check
    if (start_index < 0.0)
        write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: There is not time enough before first block! Skipping this file: Start index: %d', start_index);
        continue;
    end 

    % Clip the data
    % Use only the first 4 blocks (cogn stroop)
    if paradigm == "stroop"
        end_index = start_index + 270 * sample_freq - 1;
        clipped_data = input_data(start_index:end_index, :);

    % All other paradigms: Cut to the end
    else 
        clipped_data = input_data(start_index:end, :);
    end

    % save clipped data
    output_filename_clipped = strcat(pat_id, "_", paradigm, "_", timepoint, "_clipped.txt");
    clipped_data_location = fullfile(timepoint_folder, output_filename_clipped);
    dlmwrite(clipped_data_location, clipped_data, 'delimiter', '\t');

    % debug plots ...
    %subplot(2,1,1);
    %plot(dig)

    %subplot(2,1,2);
    %plot(dig(first_idx:end))

    % Do not try to process baseline for now
    if paradigm == "baseline"
        continue;
    end

    % EMO FEAR Processing
    if paradigm == "emo_fear" || paradigm == "emo_disgust"
        expected_num_peaks = 6;
        block_setup = [0 0 0 0 0 0];
        names = {'feel', 'suppress'}; 
        durations = {[40;40;40], [40;40;40]}; % durations, fixed 40 second blocks

        % onset timings in seconds
        % given 30 seconds prior to first block, we have the following onsets
        % provided assumptions are true: 40 second blocks and 30 second rest
        % 30 100 170 240 310 380
        times = [30 100 170 240 310 380];

        % Subtract from times if we modified the first rest phase length
        if first_rest_length > 0, times = times - subtract_from_times; end

        %% Do a peak detection to find which blocks are FEEL and which are SUPPRESS

        % smooth digital channels for better peak detection etc ..
        % values are set empirically for now, so may not work for all data
        % with difference sampling rates
        sd1 = smoothdata(d1, 'gaussian', time_prior * sample_freq);
        sd2 = smoothdata(d2, 'gaussian', time_prior * sample_freq);
        sd = smoothdata(dig, 'gaussian', time_prior * sample_freq*2);

        % Plot the peaks
        subplot(2,1,1);
        plot(1:size(d1), sd1, 1:size(d2), sd2);
        subplot(2,1,2);
        plot(sd);

        % find peaks, sanity check for number of peaks detected == 6 (the expected number)
        % if not, print error message
        [pks, locs] = findpeaks(sd);
        top_pks = pks > (max_dig - min_dig) / 2;
        pks = pks(top_pks);
        locs = locs(top_pks);

        if size(pks, 1) ~= expected_num_peaks

            % Plot the peaks
            subplot(2,1,1)
            plot(1:size(d1), sd1, 1:size(d2), sd2)
            subplot(2,1,2)
            plot(sd)

            write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Number of detected blocks is not exactly %d! Number of detected blocks = %d. Skipping this file.', expected_num_peaks, size(pks, 1));
            continue;
        end
        
        
        % block_setup = feel/supp layout of the 6 blocks
        % feel = 1; supp = -1
        for i = 1:size(locs, 1)
            cur_idx = locs(i);
            if sd1(cur_idx) > sd2(cur_idx)
                block_setup(i) = 1; % feel
            else
                block_setup(i) = -1; % supp
            end
        end

        % Sanity check for balanced blocks.
        % Should be exactly 3 feel and supp.
        % With our representations, 
        % the block_setup array should add up to exactly zero
        if sum(block_setup) ~= 0
            write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Sanity check failed for EMO FEAR! Detected blocks not balanced! Skipping this file.');
            continue;
        end

        % dipslay output
        disp('FEEL/SUPPRESS blocks, in order from left to right')
        disp('FEEL = 1 ; SUPP = -1')
        disp(block_setup)

        % Parameters for the conditions.mat file
        feel_blocks = block_setup == 1;
        supp_blocks = block_setup == -1;
        feel_onsets = times(feel_blocks);
        supp_onsets = times(supp_blocks);
        onsets = {feel_onsets', supp_onsets'};

    % STROOP paradigm: No need to search for peaks, because all blocks are treated equally for 
    % now. A block == a "task". 
    elseif paradigm == "stroop" 

        block_setup = [1 1 1 1];
        names = {'task'}; 
        durations = {[30;30;30;30]}; % durations, fixed 30 second blocks, 4 cognitive blocks.

        % onset timings in seconds
        % given 30 seconds prior to first block, we have the following onsets
        % provided assumptions are true: 30 second blocks and 30 second rest
        % 30 90 150 210 270 330 390 450
        times = [30 90 150 210];

        % Subtract from times if we modified the first rest phase length
        if first_rest_length > 0, times = times - subtract_from_times; end

        % Parameters for the conditions.mat file
        task_blocks = block_setup == 1;
        task_onsets = times(task_blocks);
        onsets = {task_onsets'};
    
    % VFT paradigm: No need to search for peaks. No randomized blocks.
    elseif paradigm == "VFT"

        % task = 1; vowel = -1
        block_setup = [-1 1];
        names = {'noun', 'task'};
        durations = {[20], [100]};

        % onset timings in seconds
        times = [20, 40];

        % Subtract from times if we modified the first rest phase length
        if first_rest_length > 0, times = times - subtract_from_times; end

        % Parameters for the conditions.mat file
        task_blocks = block_setup == 1;
        noun_blocks = block_setup == -1;
        task_onsets = times(task_blocks);
        noun_onsets = times(noun_blocks);
        onsets = {noun_onsets', task_onsets'};
    end

    % For sanity checking, create a column with the 
    % constructed digital channel from the times variable
    clipped_data_sanity = clipped_data;
    interpreted_digital_channel = zeros(1, size(clipped_data_sanity, 1));
    block_starts = times * sample_freq;

    if paradigm == "emo_fear" || paradigm == "emo_disgust"
        block_ends = (times + 40) * sample_freq; 
    elseif paradigm == "stroop"
        block_ends = (times + 30) * sample_freq; 
    elseif paradigm == "VFT"
        block_ends = (times + [20 100]) * sample_freq;
    end

    clipped_size = size(clipped_data_sanity, 1);
    for i = 1:size(block_starts, 2)
        block_start = block_starts(i);
        block_end = block_ends(i);
        if block_end > clipped_size
            block_end = clipped_size;
        end
        
        interpreted_digital_channel(block_start:block_end) = 5;
    end

    % Create the sanity data
    interpreted_digital_channel = transpose(interpreted_digital_channel);
    clipped_data_sanity(:, end+1) = interpreted_digital_channel;
 
    % Save the sanity data
    output_filename_clipped_sanity = strcat(pat_id, "_", paradigm, "_", timepoint, "_clipped_sanity.txt");
    clipped_data_location_sanity = fullfile(timepoint_folder, output_filename_clipped_sanity);
    dlmwrite(clipped_data_location_sanity, clipped_data_sanity, 'delimiter', '\t');

    % Plot the sanity data
    sanity_figure_file_name = fullfile(timepoint_folder, strcat(pat_id, "_", paradigm, "_", timepoint, "_clipped_sanity.png"));
    plot_sanity_data(clipped_data_sanity, d1_idx, d2_idx, sample_freq, sanity_figure_file_name);

    % save condition.mat
    cond_filename = strcat(pat_id, "_", paradigm, "_", timepoint, "_condition");
    save(fullfile(timepoint_folder, cond_filename), 'durations', 'names', 'onsets');

    % To test finding start location and special first timings, continue here...
    %disp(times);
    continue;

    %%% HÄR BÖRJAR LULU:s SCRIPT NR 2! 
    % Creates a NIRS file for further processing in spm_fnirs package

    %% Converts (our) *.txt dump of Hb data into new spm_fnirs format
    % Date: 2020-01-23
    % By: Yanlu Wang
    % _________________________________________________________________________
    
    input_data_clipped = readmatrix(clipped_data_location);
    input_data_clipped = rmmissing(input_data_clipped, 2);
    
    nt = size(input_data_clipped, 1);
    nr_channels = 16; % Always 16 FNIRS channels
    
    % construct Y (data)
    od = zeros(nt, nr_channels, 2);
    hbr = input_data_clipped(:, d2_idx+1:2:end);
    hbo = input_data_clipped(:, d2_idx+2:2:end);
    hbt = hbo + hbr;
    Y = struct('od', od, 'hbo', hbo, 'hbr', hbr, 'hbt', hbt);

    Y_filename = fullfile(temp_dir, 'Y.mat');
    save(Y_filename, 'Y');
    
    % construct P (header)
    % Notes: From what I can gather:
    % wave <- 1x2 int; std wavelengths of the two Hbs [695, 830]
    % fs <- int; Sampling frequency (ERIKS EDIT! - evident from file spm_fnirs_filter.m)
    % fname <- struct; file name
    %   raw <- struct
    %       Y <- string: full path and filename
    %       type <- string: 'Light Intensity' in sample file, other types?
    %   nirs <- string: seems to be a copy of raw->Y
    % base <- 1x2 int; (value range?)
    % mask <- 1xnch array of ones
    % nch <- int; number of channels
    % ns <- int; number of time points (nt)
    % age <- int; age (must be specified manually I suppose
    % d <- int; distance, but what distance? Set to 2.5
    % acoef <- 2x2 flaot; conversion coefficents I suppose, randomly generated
    % dpf <- 1x2 float; I don't know what this is, randomly generated
    
    wav = [695, 830];
    fs = sample_freq; % EDITED BY ERIK, USED TO BE 8.
    
     % this might not be correct, but what is the valid Hb tag?
    type = 'Light Intensity';
    Y = clipped_data_location;
    nirs = Y;
    raw = struct('Y', Y, 'type', type);
    fname = struct('raw', raw, 'nirs', nirs);
    nch = nr_channels;
    base = [1, 100]; % not sure if this is correct either

    % Create the mask
    mask = ones(1, nch);

    % If any HbO channel consists of mainly (>10%) 0, mask it so that it is not analysed. 
    % It is likely without useful data.
    for ch_num = 1:nch

        % NEW ALGORITHM: 90% ZEROES REQUIRED FOR MASKING (TOO much 90%???)
        ch_data = hbo(:, ch_num);
        zeroes = ch_data == 0;
        num_zeroes = size(ch_data(zeroes));
        ch_size = size(ch_data);
        if num_zeroes / ch_size > 0.1
            mask(ch_num) = -1; 

            % Log the masking.
            num_channels_masked = num_channels_masked + 1;
        end

        % OLD ALGORITHM: ALL ZEROES REQUIRED FOR MASKING
        %ch_sum = sum(hbo(:, ch_num));
        %ch_std = std(hbo(:, ch_num));
        %if ch_sum == 0 && ch_std == 0
        %    mask(ch_num) = -1;
        %    num_channels_masked = num_channels_masked + 1;
        %end

    end

    ns = nt;
    d = 2.5; %Distance between detectors?
    acoef = rand(2, 2);
    dpf = rand(1, 2);
    
    P = struct('wav', wav, 'fs', fs, 'fname', fname, 'base', base, 'mask', mask, 'nch', nch, 'ns', ns, 'age', age, 'd', d, 'acoef', acoef, 'dpf', dpf);
    
    output_filename = strcat("NIRS_", pat_id, "_", paradigm, "_", timepoint);
    P.fname.raw.Y = char(fullfile(timepoint_folder, strcat(output_filename, '.mat')));
    P.fname.nirs = P.fname.raw.Y;
    
    P_filename = fullfile(temp_dir, 'P.mat');
    save(P_filename, 'P');
    
    % clear workspace and only load the two structs
    load(P_filename);
    load(Y_filename);

    % saving final output
    save(fullfile(timepoint_folder, output_filename), 'P', 'Y');
    
    % Delete the temp files
    delete(P_filename);
    delete(Y_filename);

    %% Begin spm_fnirs processing!
    %_________________________________________________________________________

    %%% Step 1: Spatial processing %%%

    % Make the optode positions dir and add it to the matlab path
    opt_dir = fullfile(timepoint_folder, "opt");
    mkdir(opt_dir);
    addpath(opt_dir);

    % Copy the files with optode positions and channel config to the optode positions dir.
    copyfile(positions_dir, opt_dir);

    opt_pos = fullfile(opt_dir, "optode_positions_MNI.csv");
    ch_conf = fullfile(opt_dir, "ch_config.csv");
    nirs_file = fullfile(timepoint_folder, strcat(output_filename, ".mat"));

    % Create input for the spatial processing
    % This is from trial and error with the spm_fnirs function
    spat_proc_files = cell(3,1);
    spat_proc_files{1,1} = char([{char(opt_pos)} {char(ch_conf)}]);
    spat_proc_files{2,1} = char([{char(nirs_file)}]);

    % Do spatial processing
    try
        spm_fnirs_spatialpreproc_ui(spat_proc_files);
    catch err
        write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Spatial preprocessing error: %s. Skipping this file.\n%s', err.message, print_error_stack(err));
        continue;
    end

    %%% Step 2: Temporal processing %%%

    % Add the temporal preprocessing settings to the NIRS file
    load(nirs_file);
    
    cur_temporal_preproc_settings = temporal_preproc_settings;

    % If we chose to skip temporal processing for this paradigm, remove it from the settings.
    if ismember(skip_detrending_for_paradigms, paradigm)
        cur_temporal_preproc_settings.H.type = 'no';
        cur_temporal_preproc_settings.H = rmfield(cur_temporal_preproc_settings.H, 'cutoff');
    end

    P.K = cur_temporal_preproc_settings;

    save(nirs_file, 'P', 'Y');

    % Run the temporal processing (My own version of the SPM_FNIRS function)
    try
        [P, channel_info, num_overfiltered] = spm_fnirs_temporalpreproc_no_ui(nirs_file);
    catch err
        write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Temporal preprocessing error: %s. Skipping this file.\n%s', err.message, print_error_stack(err));
        continue;
    end

    % Put the overfiltered channels in the log.
    if num_overfiltered > 0, write_to_log("OVERFILTERED", fid, pat_id, paradigm, timepoint, 'Number of overfiltered channels: %d', num_overfiltered); end

    %%% Step 3: Specify 1st level
    try
        cond_file = fullfile(timepoint_folder, cond_filename);
        spm_fnirs_specify1st_no_ui(char(nirs_file), char(timepoint_folder), char(cond_file), first_level_params);
    catch err
        write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Specify 1st level error: %s. Skipping this file.\n%s', err.message, print_error_stack(err));
        continue;
    end

    %%% Store output data for this patient, paradigm and timepoint
    CUR_OUTDATA = {};

    %%% Step 4 and 5 are performed on the three SPM.mat files for HbO, HbR and HbT respectively.  
    error_occurred = false; % Did an error occur?
    for i = 1:size(first_level_params.str_nirs, 1)

        param = first_level_params.str_nirs{i};
        SPM_folder = char(fullfile(timepoint_folder, param));
        SPM_file = char(fullfile(SPM_folder, "SPM.mat"));

        %%% Step 4: Estimate GLM parameters for each channel
        try 
            spm_fnirs_spm(SPM_file);
        catch err
            error_occurred = err;
            write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Estimate GLM parameters for each channel error: %s. Skipping this file.\n%s', err.message, print_error_stack(err));
            break;
        end

        %%% Step 5a: Interpolate GLM parameters and compute thresholded SPM 
        try
            [SPM] = spm_fnirs_spm_interp(SPM_file);
        catch err
            error_occurred = err;
            write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Interpolate GLM parameters and compute thresholded SPM error: %s. Skipping this file.\n%s', err.message, print_error_stack(err));
            break;
        end

        %%%% Step 5b: Define contrasts and create output files with betas for group testing.
        load(SPM_file); % Load the SPM file to update everything
        paradigm_contrasts = contrasts.(paradigm);
        clear("xCon")
        for con_nr = 1:size(paradigm_contrasts, 2)
            cur_contrast = paradigm_contrasts(con_nr);

            try
                [c,I,emsg,imsg,msg] = spm_conman('ParseCon', cur_contrast.contrast_str, SPM.xX.xKXs, cur_contrast.STAT);
                DxCon = spm_FcUtil('Set', cur_contrast.name, cur_contrast.STAT, 'c', c, SPM.xX.xKXs);
                xCon(con_nr) = DxCon;
            catch err
                error_occurred = err;
                write_to_log("ERROR", fid, pat_id, paradigm, timepoint, 'ERROR: Define contrasts and create output files with betas for group testing error: %s. Skipping this file.\n%s', err.message, print_error_stack(err));
                break;
            end
        end

        % Break if error
        if error_occurred ~= false 
            break;
        end
        
        SPM.xCon = xCon;
        spm_fnirs_contrasts(SPM);

        %%%% Step 6: 
        % Read the contrast from the con_xxxx.mat files and put them in the OUTDATA 
        % for later second level analysis.
        for ic = 1:size(SPM.xCon, 2)
            xCon = SPM.xCon(ic);
            con_file = sprintf('con_%04d.mat', ic);
            con_filename = char(fullfile(SPM_folder, con_file));
            load(con_filename);

            for chnum = 1:16
                CUR_OUTDATA(end + 1, :) = {pat_id, paradigm, timepoint, param, chnum, xCon.name, S.cbeta(chnum)};
            end
        end

    end

    % Skip file if error
    if error_occurred ~= false 
        continue;
    end    

    % Save the current outdata to a CSV file for later second level analysis

    % Make a table
    tbl = cell2table(CUR_OUTDATA, "VariableNames", {'pat_id' 'paradigm' 'timepoint' 'signal' 'channel' 'contrast' 'cbeta'});

    % Save it as a file
    writetable(tbl, fullfile(timepoint_folder, "cBeta_output.csv"));

    % Add it to the total table
    OUTDATA_TBL = [OUTDATA_TBL; tbl];

end

% Write a summary to the log file
write_summary_to_log(fid);

% Close the log file
fclose(fid);

% Save the outdata to a CSV file for later second level analysis
% Add the current timestring to the output data filename
cur_datestr = datestr(datetime('now'), "yyyymmdd_HHMM");
cbeta_output_filename = strcat("cBeta_output_", cur_datestr, ".csv");
writetable(OUTDATA_TBL, fullfile(output_data_dir, cbeta_output_filename));

% Remove the temp data dir
if exist(temp_dir, "dir"), rmdir(temp_dir, 's'); end

% Final cleanup
clear all;

end

% Find the start of first block, by first finding the end and then subtracting the length.
function start_idx = find_start_of_first_block(dig, paradigm, sample_freq, start_from) 
    end_of_first_block = -1;
    searchAr = dig(start_from:end);
    amount_removed = start_from - 1;
    while end_of_first_block == -1
        pos1 = find(~searchAr, 1);
        pos2 = pos1 + round(0.5 * sample_freq);
        if searchAr(pos2) == 0
            end_of_first_block = pos1 + amount_removed;
        else
            searchAr = searchAr(pos1 + 1:end);
            amount_removed = amount_removed + pos1;
        end
    end

    if paradigm == "stroop"
        start_of_first_block = end_of_first_block - 30 * sample_freq;
    elseif paradigm == "emo_fear"
        start_of_first_block = end_of_first_block - 40 * sample_freq;
    end

    start_idx = start_of_first_block;

end

% Plot the sanity data
function plot_sanity_data(sanity_data, d1_idx, d2_idx, sample_freq, fig_filename) 

    all_channel_data = sanity_data(:, d2_idx+1:end-1);
    data_max = max(max(all_channel_data));

    channel_data_hbr = sanity_data(:, d2_idx+1:2:end-1);
    channel_data_hbo = sanity_data(:, d2_idx+2:2:end-1);

    digital_data_1 = sanity_data(:, d1_idx);
    digital_data_1(digital_data_1 > 0) = data_max;
    
    digital_data_2 = sanity_data(:, d2_idx);
    digital_data_2(digital_data_2 > 0) = data_max;

    timings_data = sanity_data(:, end);
    timings_data(timings_data > 0) = data_max;

    t = 1:size(sanity_data, 1);

    close();
    sanity_figure = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]);

    hold on;

    area(t, timings_data,...
        'FaceColor', '#eeeeee', 'LineStyle', 'none');

    plot(t, channel_data_hbo,...
        'Color', 'red');

    plot(t, channel_data_hbr,...
        'Color', 'blue');

    plot(t, digital_data_1,...
        'Color', 'green');

    p = plot(t, digital_data_2,...
        'Color', '#075900');

    % Set a tick every 30 seconds
    xtick_data = t(sample_freq:30*sample_freq:end) - sample_freq;
    xtick_labels = xtick_data / sample_freq;

    xticks(xtick_data);
    xticklabels(xtick_labels);

    hold off;
    
    saveas(sanity_figure, fig_filename);

    close(sanity_figure);
end

% Print an error stack
function error_stack = print_error_stack(err) 
    error_params = {};
    for stack_line = 1:size(err.stack, 1)
        error_params = [error_params; err.stack(stack_line).name; int2str(err.stack(stack_line).line)];
    end

    error_stack = sprintf("Error in function %s() at line %s.\n", error_params{:});
    error_stack = strcat("STACK:\n", error_stack);
end

% A function to write to the log file
function write_to_log(varargin)

    % Global arrays for collected stats.
    global already_analysed_files skipped_files_due_to_errors overfiltered_channels;

    % Get input
    reason = varargin{1};
    log_file_id = varargin{2}; 
    pat_id = varargin{3};
    paradigm = varargin{4};
    timepoint = varargin{5};
    message = varargin{6};

    % IF more than 5 inputs, the 6+ inputs are interpreted as inputs to a sprintf function
    if(nargin > 6)
        message = sprintf(message, varargin{7:end});
    end

    % Store special cases in arrays
    file = sprintf('%s %s %s', pat_id, paradigm, timepoint);
    if reason == "SKIP", already_analysed_files = [already_analysed_files; file]; end
    if reason == "ERROR", skipped_files_due_to_errors = [skipped_files_due_to_errors; strcat(file, "(", message, ")")]; end
    if reason == "OVERFILTERED", overfiltered_channels = [overfiltered_channels; strcat(file, ": ", int2str(varargin{7}))]; end

    % Add the current timestring to the message
    cur_datestr = datestr(datetime('now'));

    %fid = fopen(log_file, 'at');
    fprintf(log_file_id, '[%s %s %s (%s)]: %s\n', pat_id, paradigm, timepoint, cur_datestr, message);
    %fclose(fid);
end

% Write summary to the log
function write_summary_to_log(log_file_id)

    % Global arrays for collected stats.
    global already_analysed_files skipped_files_due_to_errors overfiltered_channels num_channels_masked;

    num_already_analysed_files = size(already_analysed_files, 1);
    num_skipped_files_due_to_errors = size(skipped_files_due_to_errors, 1);
    num_overfiltered_channels = size(overfiltered_channels, 1);

    %fid = fopen(log_file, 'at');
    fprintf(log_file_id, '\n\nSUMMARY:\n--------------------------------------------------------------');

    % Skipped files due to errors
    fprintf(log_file_id, '\n\nNumber of files not analysed due to errors (Error): %d\n', num_skipped_files_due_to_errors);
    for i = 1:num_skipped_files_due_to_errors
        fprintf(log_file_id, '- %s\n', skipped_files_due_to_errors(i));
    end

    % Number of overfiltered channels
    fprintf(log_file_id, '\n\nNumber of files with channels deemd to be "over-filtered": %d\n', num_overfiltered_channels);
    for i = 1:num_overfiltered_channels
        fprintf(log_file_id, '- %s\n', overfiltered_channels(i));
    end

    % Number of masked channels
    fprintf(log_file_id, '\n\nNumber of masked channels with HbO: %d\n', num_channels_masked);

    % Already analysed files
    fprintf(log_file_id, '\n\nNumber of files already analysed (Skipped): %d\n', num_already_analysed_files);
    for i = 1:num_already_analysed_files
        fprintf(log_file_id, '- %s\n', already_analysed_files(i));
    end

    %fclose(fid);
end
