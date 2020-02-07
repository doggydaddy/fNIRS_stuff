%% Prepares our .txt files 
% 
% Finding "start of experiment ping" from (any?) digital channel,
% and discards all data prior to it
% 
% From digital channels, determine which blocks are feel, and which are 
% suppress blocks respectively. 
% Use this information to construct condition.mat given prior knowledge
% about experimental durations.
% 
% Date: 2020-02-07
% By: Yanlu Wang
% _________________________________________________________________________

%% script parameters


% true/false: If true, then debug plots will be displayed
dbg = false;
% true/false: If true, save clipped data to new txt file provided a name
save_clipped = true;
% true/false: If true, then save condition.mat provided a name
save_condition = true;


%% cut txt file and save it


[input_filename, input_filepath] = uigetfile();
input_data = readmatrix(input_filename);
input_data = rmmissing(input_data, 2);

% sum digital channels (as I have no idea which gives the start ping)
d1 = input_data(:, 3);
d2 = input_data(:, 4);
dig = d1 + d2;

first_idx = find(dig, 1); % find first index which is not zero
% clip data starting from index above
clipped_data = input_data(first_idx:end, :); 

% save clipped data
if (save_clipped)
    output_filename = input('Enter output filename: ', 's');
    dlmwrite(output_filename, clipped_data, 'delimiter', '\t');
end


% debug plots ...
if (dbg) 
    subplot(2,1,1);
    plot(dig)

    subplot(2,1,2);
    plot(dig(first_idx:end))
end


%% find blocks


d1 = clipped_data(:, 3);
d2 = clipped_data(:, 4);
dig = d1 + d2;

% smooth digital channels for better peak detection etc ..
% values are set empirically for now, so may not work for all data
% with difference sampling rates
sd1 = smoothdata(d1, 'gaussian', 2500);
sd2 = smoothdata(d2, 'gaussian', 2500);
sd = smoothdata(dig, 'gaussian', 5000);

% debug plot, mostly to check smoothing is a-ok
if (dbg)
    subplot(2,1,1)
    plot(1:size(d1), sd1, 1:size(d2), sd2)
    subplot(2,1,2)
    plot(smoothdata(dig, 'gaussian', 5000))
end

% find peaks, sanity check for number of peaks detected == 6
% if not, print error message
[pks, locs] = findpeaks(sd);
if size(pks, 1) ~= 6
    disp('ERROR: Number of detected blocks is not exactly 6!')
    fprintf('DBG: Number of detected blocks = %d.\n', size(pks, 1));
end

block_setup = [0 0 0 0 0 0];
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
    disp('ERROR: Sanity check failed! Detected blocks not balanced!')
end

% dipslay output
disp('FEEL/SUPPRESS blocks, in order from left to right')
disp('FEEL = 1 ; SUPP = -1')
disp(block_setup)


%% create conditions.mat


names = {'feel', 'suppress'}; 
durations = {[40;40;40], [40;40;40]}; % durations, fixed 40 second blocks
% onset timings in seconds
% given 30 seconds prior to first block, we have the following onsets
% provided assumptions are true: 40 second blocks and 30 second rest
% 30 100 170 240 310 380
times = [30 100 170 240 310 380];
feel_blocks = block_setup == 1;
supp_blocks = block_setup == -1;
feel_onsets = times(feel_blocks);
supp_onsets = times(supp_blocks);
onsets = {feel_onsets', supp_onsets'};

% save condition.mat
if (save_condition)
    cond_filename = input('Enter output filename for condition: ', 's');
    save(cond_filename, 'durations', 'names', 'onsets');
end



