%% organize data about neuron
if contains(data.soundCat, 'gating', 'IgnoreCase', true)
    data.stim(1:size(data_peth,1)) = data.stimList;
    if contains(data.stimList, 'BBN')
        data.postStim = 900;
        data.preStim = 100;
        data.soundcalibrate = 90;
    else
        data.postStim = 890;
        data.preStim = 110;
        data.soundcalibrate = 80;
    end
elseif ~contains(data.stimList, 'BBN')
    if ismember('StimNameR', data_peth.Properties.VariableNames) % Does StimName field exist in the marker?
        data.stim = data_peth.(find(contains(data_peth.Properties.VariableNames, 'StimName')));
        data.postStim = 890;
        data.preStim = 110;
        data.soundcalibrate = 80; % dB SPL of stimuli at 0 dB attenuation
        
        % Find wave file names
    elseif iscell(data_peth.(find(contains(data_peth.Properties.VariableNames, 'WAV')))) % Is the wav filename field empty?)
        index = find(contains(data_peth.Properties.VariableNames, 'WAV'));
        stimListNew = data_peth.(index);
        stimListNew(contains(stimListNew, '\p100_11'),1) = {'p100_11'};
        stimListNew(contains(stimListNew, '\p100_10'),1) = {'p100_10'};
        stimListNew(contains(stimListNew, '\p100_1'),1) = {'p100_1'};
        stimListNew(contains(stimListNew, '\p100_2'),1) = {'p100_2'};
        stimListNew(contains(stimListNew, '\p100_3'),1) = {'p100_3'};
        stimListNew(contains(stimListNew, '\p100_4'),1) = {'p100_4'};
        stimListNew(contains(stimListNew, '\p100_5'),1) = {'p100_5'};
        stimListNew(contains(stimListNew, '\p100_6'),1) = {'p100_6'};
        stimListNew(contains(stimListNew, '\p100_7'),1) = {'p100_7'};
        stimListNew(contains(stimListNew, '\p100_8'),1) = {'p100_8'};
        stimListNew(contains(stimListNew, '\p100_9'),1) = {'p100_9'};
        stimListNew(contains(stimListNew, '\Appease'),1) = {'Appease'};
        stimListNew(contains(stimListNew, '\Biosonar'),1) = {'Biosonar'};
        stimListNew(contains(stimListNew, '\HighAgg'),1) = {'HighAgg'};
        stimListNew(contains(stimListNew, '\LowAgg'),1) = {'LowAgg'};
        data.stim = stimListNew;
        data.soundCat = 'Vocal';
        data.postStim = 890;
        data.preStim = 110;
        data.soundcalibrate = 80; % dB SPL of stimuli at 0 dB attenuation
        
        % Find frequency information for tones
    elseif any(data_peth.(find(contains(data_peth.Properties.VariableNames, 'Freq') & ...
            ~contains(data_peth.Properties.VariableNames, 'BBN')))>0) % Is frequency field (but not for bbn) empty?
        index = find(contains(data_peth.Properties.VariableNames, 'Freq') & ~contains(data_peth.Properties.VariableNames, 'BBN')>0);
        stimListNew = cell(size(data_peth.(index),1),1);
        for n = 1:size(stimListNew,1)
            stimListNew(n) = {['Hz_',num2str(data_peth.(index)(n))]};
        end
        data.stim = stimListNew;
        data.soundCat = 'Tones';
        data.soundcalibrate = 80;
        data.preStim = 100+ data_peth.(find(contains(data_peth.Properties.VariableNames, 'TimeShift', 'IgnoreCase', true),1))(1);
        data.postStim = 900- data_peth.(find(contains(data_peth.Properties.VariableNames, 'TimeShift', 'IgnoreCase', true),1))(1);
    else
        
        % Dunno what it is
        data.stim(1:size(data_peth,1)) = {'undetermined'};
        data.soundCat = {'undetermined'};
        data.soundcalibrate = 80;
        data.preStim = 100+ data_peth.TimeShiftR(1);
        data.postStim = 900- data_peth.TimeShiftR(1);
    end
    
    %It's a BBN
elseif contains(data.stimList, 'BBN')
    data.stim(1:size(data_peth,1)) = data.stimList;
    data.soundCat = 'BBN';
    data.soundcalibrate = 90;
    data.postStim = 900;
    data.preStim = 100;
end

data.stimList = unique(data.stim);
data.attenList = unique(data_peth.(find(contains(data_peth.Properties.VariableNames, 'Atten', 'IgnoreCase', true))));
data.attenList = cellstr(horzcat(repmat('dB_', length(data.attenList),1),num2str(data.soundcalibrate - data.attenList)));
data.timestamp = abs(data_peth.Timestamp);
data.peth = table2array(data_peth(:,end-999:end));
dater = num2str(data.date);
if numel(dater) == 5
    dater = ['0', dater];
end