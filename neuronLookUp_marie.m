%% Find out if this neuron has been processed before
cd('D:\bat neuron database\')
reflookup = dir('*.mat');

for r = 1:size(reflookup,1)
    if contains(reflookup(r).name, num2str(data.animalnum))
        if contains(reflookup(r).name, num2str(data.date))
            if contains(reflookup(r).name, num2str(data.depth))
                load(reflookup(r).name)
            end
        end
    end
end

% If an entry can't be found, make a new one
if ~exist('neuron', 'var')
    neuron.animalNum = data.animalnum;
    neuron.Date = data.date;
    neuron.Depth = data.depth;

    load('Reference.mat')
    reference(end+1).animalNum = neuron.animalNum;
    reference(end).Date = data.date;
    reference(end).Depth = data.depth;
    reference(end).filename = [num2str(neuron.animalNum), '_', data.date, '_', num2str(data.depth), '.mat'];
     save('Reference.mat', 'reference', '-v7.3')
    clear reference
end