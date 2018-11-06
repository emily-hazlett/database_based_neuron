% This script takes a PETH and spike waveforms exported from datawave as text
% files and compiles the data into the larger data structure. PETHs are
% exported in tidydata form, but then imported to be compatible with previous
% data processing work flows. Waveforms are exported with each row being a
% separate event, as more rows can be included in a datawave output than
% columns.
cd('D:\mouse free moving\839\Neuron characterization\839_051615\')
clear data*
ddffilename = '839_051615_Char_USV_80dB_random_1_spikes';
filename_spikes = [ddffilename, '_spikeoverlay2.txt'];
filename_peth = [ddffilename, '_peth2.txt'];
data.animalnum = 839;
data.date = 051613;
data.condition = 'free_moving'; % free_moving, restrained
data.presentationmode = 'randomized'; % randomized, blocked, ISI_200, ISI_500, RLF
data.soundCat = 'Vocal'; % BBN, Tones, Vocal, Sensory_gating
data.stimList = {'find'}; % BBN_X, p100_X, find
data.UnitID = '02a';
data.channel = 'Ch3';

%% import data
data_spikes = readtable(filename_spikes);
data_peth = readtable(filename_peth);

trace = table2array(data_spikes(:,4:end));
data_spikes(:,4:end) = [];
data_spikes.trace = trace;
clear trace

%% organize data about neuron
% Examines marker info from input text files to find information about the
% test
run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\organize_data_freemoving.m')

%% Find out if this neuron has been processed before
% either loads neuron if it has been run before or updates reference.mat
% with new neuron information
run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\neuron_lookup_freemoving.m')

%% Add PETH and spike waveforms to data structure
run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\adddata_freemoving.m')


