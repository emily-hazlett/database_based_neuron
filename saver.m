for i = 1:10
    neuron = neurons(i);
    dater = num2str(neurons(i).Date);
    if numel(dater) == 5
        dater = ['0', dater];
    end
    
    neuronfilename = [cd, '\', neurons(i).UnitID, '_', num2str(neurons(i).animalNum), '_', dater,'.mat'];
    save(neuronfilename, 'neuron')
end