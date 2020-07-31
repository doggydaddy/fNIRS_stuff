function [P, channel_info, num_overfiltered] = spm_fnirs_temporalpreproc_no_ui(F)
    % Apply temporal filters to fNIRS data 
    % Modified by Erik Boberg 2020-04-08 to not require GUI input. 
    % Expects that the supplied file has the settings pre-set in P.K
    % FORMAT [P] = spm_fnirs_temporalpreproc_ui(F)
    %
    % F     'NIRS.mat' file to be analysed 
    %
    % P     structure array of filter parameters (P.K) 
    %
    %__________________________________________________________________________
    % Copyright (C) 2015 Wellcome Trust Centre for Neuroimaging
    
    %
    % $Id$
    
    fprintf('--------------------------------------------------------- \n'); 
    fprintf('Apply temporal filters to fNIRS data...\n'); 
    fprintf('--------------------------------------------------------- \n'); 
    
    if ~nargin, % specify file name of NIRS.mat 
        [F sts] = spm_select(1, '^NIRS*.*.\.mat$', 'Select fNIRS file for temporal preprocessing');
        if ~sts, P = []; return; end 
    end
    
    spm_input('Apply temporal preprocessing to fNIRS data:', 1, 'd'); 
    
    %--------------------------------------------------------------------------
    fprintf('Read and display time series of fNIRS data...\n'); 
    
    % CHANGE MADE HERE: LOAD THE P.K into the function.
    load(F); K = P.K;
    
    % identify channels of interest: 
    % [ERIK] This could probably be removed,
    % and then just remove the viewing of timeseries below as well
    if isfield(P.fname, 'pos') 
        load(P.fname.pos);
        mask = zeros(1, R.ch.nch);
        indx = find(R.ch.mask == 1);
        mask(R.ch.label(indx)) = 1; clear R;
    else 
        mask = ones(1, P.nch); 
    end
    
    mask = mask .* P.mask;
    ch_roi = find(mask ~= 0); 
    
    % display time series of fNIRS data
    %spm_fnirs_viewer_timeseries(Y, P, [], ch_roi);
        
    %==================================
    % apply filters to hemoglobin changes
    %================================== 
    fprintf('Apply a temporal filter to hemoglobin changes... \n'); 
    
    load(F); % mask of measurements might be changed using spm_fnirs_viewer_timeseries 
    P.K = K; % update structure P 

    % Create a motion_params.mat file
    chs = P.K.M.chs;
    sfname = fullfile(spm_file(P.fname.nirs, 'path'), 'motion_params.mat');
    save(sfname, 'chs', spm_get_defaults('mat.format'));
  
    % change structure array to matrix 
    y = spm_vec(rmfield(Y, 'od')); 
    y = reshape(y, [P.ns P.nch 3]); 
    
    [fy, P] = spm_fnirs_preproc(y, P); 
    [fy] = spm_fnirs_filter(fy, P, P.K.D.nfs); 

    % TEMP: SAVE THE FILTERED DATA (FOR YANLU)
    signals = ["HbO" "HbR" "HbT"];
    signal_varnames = ["hbo", "hbr", "hbt"];
    for s = 1:size(signals, 2)
        signal = signals(s);
        signal_varname = signal_varnames(s);

        signal_path = fullfile(spm_file(P.fname.nirs, 'path'), signal);
        mkdir(signal_path);
        session_name = strrep(spm_file(P.fname.nirs, "basename"), "NIRS_", "");
        filtered_data_filename = strcat(session_name, "_filtered_data_", signal_varname, ".txt");
        dlmwrite(fullfile(signal_path, filtered_data_filename), fy(:, :, s), 'delimiter', '\t');
    end
    % END TEMP
    
    fprintf('Completed. \n\n');
    
    %--------------------------------------------------------------------------
    % save the results (parameters)
    fprintf('Update header of NIRS.mat file...\n'); 
    save(P.fname.nirs, 'P', '-append', spm_get_defaults('mat.format')); 
    fprintf('Completed. \n\n');
    
    %--------------------------------------------------------------------------
    fprintf('Display results...\n'); 
        
    %OLD: fig = spm_fnirs_viewer_timeseries(y, P, fy, ch_roi); 
    % Print output images
    [channel_info, num_overfiltered] = print_output_images(P, Y, fy);
    
    fprintf('--------------------------------------------------------- \n'); 
    fprintf('%-40s: %30s\n','Completed.', spm('time')); 
    fprintf('--------------------------------------------------------- \n'); 

end

% Plot raw and filtered signals and save plots as images.
function [channel_info, num_overfiltered] = print_output_images(P, Y, fy)
    % For y and fy it is "timepoint", "channel", "signal (HbO, HbR, HbT)"

    signals = ["HbO" "HbR" "HbT"];
    signal_varnames = ["hbo", "hbr", "hbt"];
    chs = P.K.M.chs;

    num_signals = size(signals, 2);
    num_channels = size(chs, 2);
    channel_info = strings(num_signals, num_channels);
    num_overfiltered = 0;

    % Yanlus NN som klassificerar kanaler i over-filtered eller normala
    %overfiltered_NN_path = fullfile(meta_data_dir, "eb_classnet.mat");
    %load("eb_classnet", "eb_classnet");

    % Create a figure without a window
    %close all hidden
    f = figure();

    for s = 1:size(signals, 2)
        signal = signals(s);
        signal_varname = signal_varnames(s);

        signal_path = fullfile(spm_file(P.fname.nirs, 'path'), signal);
        if ~exist(signal_path, "dir"), mkdir(signal_path); end
        
        fig_path = fullfile(signal_path, "temporal_processing_plots");
        if ~exist(fig_path, "dir"), mkdir(fig_path); end

        mask = P.mask;

        for i = 1:size(chs, 2)
            etime = P.ns/P.fs; 
            raw_y = Y.(signal_varname)(:,i);
            filtered_y = fy(:, i, s);
            time_raw = linspace(0, etime, size(raw_y, 1));
            time_filtered = linspace(0, etime, size(filtered_y, 1));

            % Calc the std of the filtered Y: If it is very low in comparison to the 
            % mean of the filtered values, it is likely that the filtering messed up the 
            % values (made them into a straight line...)
            %std_filtered = std(filtered_y);
            %mean_filtered = mean(filtered_y);
            %std_vs_mean = abs(std_filtered / mean_filtered);

            % Find over-filtered channels using Yanlus script
            
            %inputData = loadToNet(raw_y, filtered_y);
            % size(inputData) bör vara 1024 x 2
            %is_overFiltered = classify(eb_classnet, inputData)

            %is_overFiltered = detect_failed(filtered_y);
            is_overFiltered = categorical(0);

            fprintf('Rendering graph for: %s, Ch %d...\n', signal, i); 

            plot(time_raw, raw_y, time_filtered, filtered_y);
            xlabel('Time [s]'); 
            axis tight;

            session_name = strrep(spm_file(P.fname.nirs, "basename"), "NIRS_", "");
            fig_name_base = strcat(session_name, "_", signal_varname, "_ch", int2str(i));

            if mask(i) ~= -1
                if is_overFiltered == categorical(1)
                    channel_info(s, i) = "OVER-FILTERED";
                    num_overfiltered = num_overfiltered + 1;
                    fig_name = strcat(fig_name_base, " (over-filtered).png");
                else 
                    channel_info(s, i) = "OK";
                    fig_name = strcat(fig_name_base, ".png");
                end
            else 
                channel_info(s, i) = "MASKED";
                fig_name = strcat(fig_name_base, " (masked).png");
            end

            saveas(f, fullfile(fig_path, fig_name));
        end

    end

    % Close the figure
    close(f);

end

