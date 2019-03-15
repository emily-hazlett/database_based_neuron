% This script takes a PETH and spike waveforms exported from datawave as text
% files and compiles the data into the larger data structure. PETHs are
% exported in tidydata form, but then imported to be compatible with previous
% data processing work flows. Waveforms are exported with each row being a
% separate event, as more rows can be included in a datawave output than
% columns.

% neurons(1).animalNum = [];
% neurons(1).date = [];
% neurons(1).depth = [];
% neurons(1).sounds = [];

ddffilename = '12-07-2018--000055_spikes';
data.animalNum = 8888; %data_peth.AnimalNum(1);
data.date = 120718; %data_peth.Date(1);
data.depth = 0001;
unitselect = 1; % which spike id assigned by datawave to find?

%% import data
filename_spikes = [ddffilename, '_spike1.txt'];
filename_peth = [ddffilename, '_PSTH', num2str(unitselect), '.txt'];
data_spikes = readtable(filename_spikes);
data_peth = readtable(filename_peth);

p = ismissing((data_peth(:,1)));
data_peth(p,:) = [];
clear p
p = ismissing((data_spikes(:,1)));
data_spikes(p,:) = [];
clear p
% organize data about neuron

data.stimList = unique(data_peth.StimName);
data.stimIDList = unique(data_peth.id_);

data_peth.Timestamp = abs(data_peth.Timestamp);
peth = table2array(data_peth(:,11:end));
data_peth(:,11:end) = [];
data_peth.PETH = peth;

trace = table2array(data_spikes(:,4:end));
data_spikes(:,4:end) = [];
data_spikes.trace = trace;

% Find out if this neuron has been processed before


for i = 1:length(neurons)+1
    if i > length(neurons)
        neurons(i).animalNum = data.animalNum;
        neurons(i).date = data.date;
        neurons(i).depth = data.depth;
        continue
    end
    
    if neurons(i).animalNum == data.animalNum
        if neurons(i).date == data.date
            if neurons(i).depth == data.depth
                break
            end
        end
    end
end

%% Add PETH and spike waveforms to data structure
for ii =1:length(data.stimList)
    if isfield(neurons(i).sounds, data.stimList{ii})
        if isfield(neurons(i).sounds.(data.stimList{ii}), 'dB_70')
            for retester = 1:100
                if isfield(neurons(i).sounds, [data.stimList{ii}, '_retest', num2str(retester)])
                else
                    data.stimList{ii} = [data.stimList{ii}, '_retest', num2str(retester)];
                    break
                end
            end
        end
    end
    
    neurons(i).sounds.(data.stimList{ii}).dB_70.peth = data_peth(data_peth.id_ == data.stimIDList(ii), :).PETH';
    neurons(i).sounds.(data.stimList{ii}).dB_70.markertime = data_peth(data_peth.id_ == data.stimIDList(ii), :).Timestamp';
    
    % Find spikes that happen around each presentation of each sound
    chunker_timestamp = [];
    chunker_id = [];
    chunker_detectPoint = [];
    chunker_trace = [];
    for iii = 1:length(neurons(i).sounds.(data.stimList{ii}).dB_70.markertime)
        index = true(1,size(data_spikes,1));
        index(data_spikes.timestamp>neurons(i).sounds.(data.stimList{ii}).dB_70.markertime(iii)+850) = false;
        index(data_spikes.timestamp<neurons(i).sounds.(data.stimList{ii}).dB_70.markertime(iii)-150) = false;
        if any(index)
            chunker_timestamp = [chunker_timestamp; data_spikes.timestamp(index,:)];
            chunker_id = [chunker_id; data_spikes.id_(index,:)];
            chunker_detectPoint = [chunker_detectPoint; data_spikes.detectPoint(index,:)];
            chunker_trace = [chunker_trace; data_spikes.trace(index,:)];
        end
    end
    if any(chunker_id) % save actual spikes
        neurons(i).sounds.(data.stimList{ii}).dB_70.spikes.timestamp = chunker_timestamp(chunker_id == unitselect,:);
        neurons(i).sounds.(data.stimList{ii}).dB_70.spikes.detectPoint = chunker_detectPoint(chunker_id == unitselect,:);
        neurons(i).sounds.(data.stimList{ii}).dB_70.spikes.trace = chunker_trace(chunker_id == unitselect,:);
    elseif ~isempty(chunker_id) % save rejected waveforms for future reference
        neurons(i).sounds.(data.stimList{ii}).dB_70.noise.timestamp = chunker_timestamp(chunker_id == 0,:);
        neurons(i).sounds.(data.stimList{ii}).dB_70.noise.detectPoint = chunker_detectPoint(chunker_id == 0,:);
        neurons(i).sounds.(data.stimList{ii}).dB_70.noise.trace = chunker_trace(chunker_id == 0,:);
    else
    end
    
end

% plot waveforms and add psth to plot
%     figure;
%     for pp = 1:length(output)
%         subplot(6,1,pp)
%         plot(output{pp,2},'color', [0.5 0.5 0.5])
%         hold on
%         plot(mean(output{pp,2},2), 'k', 'linewidth', 2)
%         title(output{pp,1},'interpreter', 'none')
%         set(gca, 'ylim', [-10000, 10000])
%     end

