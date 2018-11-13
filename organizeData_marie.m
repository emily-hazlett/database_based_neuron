%% organize data about neuron
%Strings, syllables, and rep rate
if contains(data.soundCat, 'Vocal', 'IgnoreCase', true)
    index = find(contains(data_peth.Properties.VariableNames, 'Wav', 'IgnoreCase', true));
    stimListNew = data_peth.(index);
    run('C:\Users\emily\OneDrive\Documents\GitHub\database_based_neuron\wavFileLookUp_marie.m')
    data.stim = stimListNew;
    
    % Tones
elseif contains(data.soundCat, 'Tones', 'IgnoreCase', true)
    index = find(contains(data_peth.Properties.VariableNames, 'Freq') & ~contains(data_peth.Properties.VariableNames, 'BBN')>0);
    stimListNew = cell(size(data_peth.(index),1),1);
    for n = 1:size(stimListNew,1)
        stimListNew(n) = {['Hz_',num2str(data_peth.(index)(n))]};
    end
    data.stim = stimListNew;
    data.preStim = data.preStim+ data_peth.(find(contains(data_peth.Properties.VariableNames, 'TimeShift', 'IgnoreCase', true),1))(1);
    data.postStim = data.postStim - data_peth.(find(contains(data_peth.Properties.VariableNames, 'TimeShift', 'IgnoreCase', true),1))(1);
    
    % BBN
elseif contains(data.soundCat, 'BBN', 'IgnoreCase', true)
    index1 = find(contains(data_peth.Properties.VariableNames, 'RampUp'));
    index2 = find(contains(data_peth.Properties.VariableNames, 'HoldTime'));
    index3 = find(contains(data_peth.Properties.VariableNames, 'RampDown'));
    durations = data_peth.(index1) + data_peth.(index2) + data_peth.(index3);
    if length(unique(durations)) == 1
        data.stim(1:size(data_peth,1)) = {['BBN_', num2str(unique(durations))]};
    else
        data.stim(1:size(data_peth,1)) = {'BBN_X'};
    end
    data.preStim = data.preStim+ data_peth.(find(contains(data_peth.Properties.VariableNames, 'TimeShift', 'IgnoreCase', true),1))(1);
    data.postStim = data.postStim- data_peth.(find(contains(data_peth.Properties.VariableNames, 'TimeShift', 'IgnoreCase', true),1))(1);
    
    % Dunno what it is
else
    data.stim(1:size(data_peth,1)) = {'undetermined'};
end

data.stimList = unique(data.stim);
data.attenList = unique(data_peth.(find(contains(data_peth.Properties.VariableNames, 'Atten', 'IgnoreCase', true))));
data.attenList = cellstr(horzcat(repmat('dB_', length(data.attenList),1),num2str(data.soundcalibrate - data.attenList)));
data.timestamp = abs(data_peth.Timestamp);
data.peth = table2array(data_peth(:,end-999:end));
dater = data.date;
