%% Add PETH and spike waveforms to data structure
for i =1:length(data.stimList)
    for ii = 1:length(data.attenList)
        % Save peth and markertimes for all presentations of this stimulus
        neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).peth = ...
            data.peth(strcmp(data.stimList{i},data.stim), :)';
        neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).markertime = ...
            data.timestamp(strcmp(data.stimList{i},data.stim), :)';
        
        % Find spikes that happen around each presentation of each sound
        chunker_timestamp = [];
        chunker_id = [];
        chunker_detectPoint = [];
        chunker_trace = [];
        for iii = 1:length(neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).markertime)
            index = true(1,size(data_spikes,1));
            index(data_spikes.timestamp>neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).markertime(iii)+data.postStim) = ...
                false;
            index(data_spikes.timestamp<neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).markertime(iii)-data.preStim) = ...
                false;
            % If spikes occured, add them to the record
            if any(index)
                chunker_timestamp = [chunker_timestamp; data_spikes.timestamp(index,:)];
                chunker_id = [chunker_id; data_spikes.id_(index,:)];
                chunker_detectPoint = [chunker_detectPoint; data_spikes.detectPoint(index,:)];
                chunker_trace = [chunker_trace; data_spikes.trace(index,:)];
            end
        end
        
        % Add record of actual spikes to the data structure for that stimulus
        if any(chunker_id) % save actual spikes
            neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).spikes.timestamp = ...
                chunker_timestamp(chunker_id == 1,:);
            neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).spikes.detectPoint = ...
                chunker_detectPoint(chunker_id == 1,:);
            neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).spikes.trace = ...
                chunker_trace(chunker_id == 1,:);
        end
        
        % Add record of rejected 'spikes' to the data structure for that stimulus
        if any(~chunker_id) % save rejected waveforms for future reference
            neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).noise.timestamp = ...
                chunker_timestamp(chunker_id == 0,:);
            neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).noise.detectPoint = ...
                chunker_detectPoint(chunker_id == 0,:);
            neuron.Sounds.(data.soundCat).(data.stimList{i}).(data.condition).(data.presentationmode).(data.attenList{ii}).noise.trace = ...
                chunker_trace(chunker_id == 0,:);
        end
    end
end