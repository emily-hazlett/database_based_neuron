% Saves neuron as mat file in database folder and updates reference mat
% file
clear index
if ~exist('data', 'var') || ~exist('neuron', 'var')
    disp('Data not loaded into workspace, cannot save neuron to database')
    return
end

cd('D:\neuron database\')
reflookup = dir('*.mat');
load('Reference.mat')

if ~exist('dater', 'var')
    dater = num2str(data.date);
    if numel(dater) == 5
        dater = ['0', dater];
    end
end

if isfield(data, 'UnitID')
    neuron.UnitID = data.UnitID;
    neuron.channel = data.channel;
    for r = 1:size(reference,1)
        if contains(reference(r).UnitID, data.UnitID)
            index = r;
            break
        end
    end
    
else
    ref = [num2str(data.animalnum), '_', dater, '.mat'];
    for r = 1:size(reflookup,1)
        if contains(reflookup(r).name,ref)
            index = r;
            break
        end
    end
end

if ~exist('index', 'var')
    index = size(reflookup,1) + 1;
end

reference(index).filename = [neuron.UnitID,'_', ...
    num2str(neuron.animalNum), '_', dater, '.mat'];
reference(index).Channel = neuron.channel;

save('Reference.mat', 'reference', '-v7.3')
save(reference(index).filename, 'neuron')