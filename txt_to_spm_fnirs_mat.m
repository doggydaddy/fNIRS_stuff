%% Converts (our) *.txt dump of Hb data into new spm_fnirs format
% Date: 2020-01-23
% By: Yanlu Wang
% _________________________________________________________________________

[input_filename, input_filepath] = uigetfile();
input_data = readmatrix(input_filename);
input_data = rmmissing(input_data, 2);

nt = size(input_data, 1);
nr_channels = 16; % hardcode number of channels 

% construct Y (data)
od = zeros(nt, nr_channels, 2);
hbo = input_data(:, 5:2:end); % ignore columns 1-4 (HRV, EDA, DIG1, DIG2)
hbr = input_data(:, 6:2:end);
hbt = hbo + hbr;
Y = struct('od', od, 'hbo', hbo, 'hbr', hbr, 'hbt', hbt);
save('Y.mat', 'Y');
% construct P (header)
% Notes: From what I can gather:
% wave <- 1x2 int; std wavelengths of the two Hbs [695, 830]
% fs <- int; do not know what it means
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
fs = 0;

 % this might not be correct, but what is the valid Hb tag?
type = 'Light Intensity';
Y = strcat(input_filepath, input_filename);
nirs = Y;
raw = struct('Y', Y, 'type', type);
fname = struct('raw', raw, 'nirs', nirs);

nch = nr_channels;
base = [1, 100]; % not sure if this is correct either
mask = ones(1, nch);
ns = nt;
age = str2double(input('Enter age: ','s'));
d = 2.5;
acoef = rand(2, 2);
dpf = rand(1, 2);

P = struct('wav', wav, 'fs', fs, 'fname', fname, 'base', base, 'mask', mask, 'nch', nch, 'ns', ns, 'age', age, 'd', d, 'acoef', acoef, 'dpf', dpf);

output_filename = input('Enter output filename: ', 's');
P.fname.raw.Y = strcat(input_filepath, output_filename, '.mat');
P.fname.nirs = P.fname.raw.Y;

save('P.mat', 'P');

% clear workspace and only load the two structs
load('P.mat');
load('Y.mat');
% saving final output
save(output_filename, 'P', 'Y');

% final cleanup
delete P.mat;
delete Y.mat;
clear all;