%% Find out if this neuron has been processed before
cd('D:\neuron database\')
reflookup = dir('*.mat');

% Look up by unit ID if listed, otherwise look for entries with the naimal
% number and date
if isfield(data, 'UnitID')
    for r = 1:size(reflookup,1)
        if contains(reflookup(r).name,data.UnitID)
            load(reflookup(r).name)
            break
        end
    end
else
    ref = [num2str(data.animalnum), '_', dater, '.mat'];
    for r = 1:size(reflookup,1)
        if contains(reflookup(r).name,ref)
            load(reflookup(r).name)
            break
        end
    end
end

% If an entry can't be found, make a new one
if ~exist('neuron', 'var')
    neuron.UnitID = 'unassigned';
    neuron.UnitType = 'unassigned';
    neuron.channel = 'undetermined';
    neuron.animalNum = data.animalnum;
    neuron.Date = data.date;
    load('Reference.mat')
    reference(end+1).UnitID = neuron.UnitID;
    reference(end).UnitType = neuron.UnitType;
    reference(end).animalNum = neuron.animalNum;
    reference(end).Date = neuron.Date;
     save('Reference.mat', 'reference', '-v7.3')
    clear reference
end