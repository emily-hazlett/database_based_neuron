% This script takes a PETH and spike waveforms exported from datawave as text
% files and compiles the data into the larger data structure. PETHs are
% exported in tidydata form, but then imported to be compatible with previous
% data processing work flows. Waveforms are exported with each row being a
% separate event, as more rows can be included in a datawave output than
% columns.

clear dataSet1*
cd('D:\bat restrained\Bat Restrained Sorted Files_complete\')
fileList = dir('D:\bat restrained\Bat Restrained Sorted Files_complete\*.ddf');

for i = 1:size(fileList,1)
    info = fileList(i).name;
    dataSet1(i).filename = strrep(info, '.ddf', '');
    dataSet1(i).animalnum = str2double(info(1:3));
    dataSet1(i).date = info(5:14);
    dataSet1(i).depth = str2double(info(17:20));
    info(1:21) = [];
    info(end-10:end) = [];
    dataSet1(i).stimList = {'find'};
    dataSet1(i).soundcalibrate = 80;
    dataSet1(i).preStim = 100;
    dataSet1(i).postStim = 900;
    
    
    % Set sound Category
    if contains(info, 'syllable', 'IgnoreCase', true)
        dataSet1(i).soundCat = 'Vocal';
    elseif contains(info, 'string', 'IgnoreCase', true)
        dataSet1(i).soundCat = 'Vocal';
    elseif contains(info, 'RepRate', 'IgnoreCase', true)
        dataSet1(i).soundCat = 'Vocal';
    elseif contains(info, 'freq', 'IgnoreCase', true)
        dataSet1(i).soundCat = 'Tones';
    elseif contains(info, 'FRA', 'IgnoreCase', true)
        dataSet1(i).soundCat = 'Tones';
    elseif contains(info, 'BBN', 'IgnoreCase', true)
        dataSet1(i).soundCat = 'BBN';
    else
        dataSet1(i).soundCat = 'undetermined';
    end
    
    % Set presentaiton mode
    if contains(info, 'rand', 'IgnoreCase', true)
        dataSet1(i).presentationmode = 'randomized';
    elseif contains(info, 'block', 'IgnoreCase', true)
        dataSet1(i).presentationmode = 'blocked';
    elseif contains(info, 'RepRate', 'IgnoreCase', true)
        dataSet1(i).presentationmode = 'Repetition_rate';
    elseif contains(dataSet1(i).soundCat, 'Tones', 'IgnoreCase', true)
        dataSet1(i).presentationmode = 'RLF';
    elseif contains(dataSet1(i).soundCat, 'BBN', 'IgnoreCase', true)
        dataSet1(i).presentationmode = 'RLF';
    else
        dataSet1(i).presentationmode = 'undetermined';
    end
end

%Batch through each file
for i = 1: size(dataSet1,2)
    clearvars -except dataSet1 i
    data = dataSet1(i);
    cd('D:\bat restrained\Bat Restrained Sorted Files_complete\')
    
    data_spikes = readtable([data.filename, '_spikes.txt']);
    data_peth = readtable([data.filename, '_peth.txt']);
    
    trace = table2array(data_spikes(:,4:end));
    data_spikes(:,4:end) = [];
    data_spikes.trace = trace;
    clear trace
    
    %% organize data about neuron
    % Examines marker info from input text files to find information about the
    % test
    run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\organizeData_marie.m')
    
    %% Find out if this neuron has been processed before
    % either loads neuron if it has been run before or updates reference.mat
    % with new neuron information
    run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\neuronLookUp_marie.m')
    
    %% Add PETH and spike waveforms to data structure
    run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\addData_marie.m')
end


