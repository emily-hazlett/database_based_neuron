% Saves neuron as mat file in database folder and updates reference mat
% file

if ~exist('data', 'var') || ~exist('neuron', 'var')
    disp('Data not loaded into workspace, cannot save neuron to database')
    return
end

cd('D:\neuron database\')
reflookup = dir('*.mat');

if ~exist('dater', 'var')
    dater = num2str(data.date);
    if numel(dater) == 5
        dater = ['0', dater];
    end
end
    
ref = [num2str(data.animalnum), '_', dater, '.mat'];
for r = 1:size(reflookup,1)
     if contains(reflookup(r).name,ref)
         index = r;
         break
     end
end

reference(r).filename = [neuron.UnitID,'_', ...
    num2str(neuron.animalNum), '_', dater, '.mat'];

save('Reference.mat', 'reference', '-v7.3')
save(reference(r).filename, 'neuron')