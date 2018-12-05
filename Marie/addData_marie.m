%% Add PETH and spike waveforms to data structure
data.attenList = strrep(data.attenList, ' ', '');
data.stimList =  strrep(data.stimList, ' ', '');

for s =1:length(data.stimList)
    if any(data.stimList{s} ~= '0')
        for ii = 1:length(data.attenList)
            if isfield(neuron, 'Sounds')
                if isfield(neuron.Sounds, data.soundCat)
                    if isfield(neuron.Sounds.(data.soundCat), data.stimList{s})
                        if isfield(neuron.Sounds.(data.soundCat).(data.stimList{s}), data.presentationmode)
                            if isfield(neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode), data.attenList{ii})
                                data.presentationmode = [data.presentationmode, '_retest'];
                            end
                        end
                    end
                end
            end
            
            % was this stimulus actually presented?
            if size(data.peth(strcmp(data.stimList{s},data.stim) & strcmp(data.attenList{ii},data.atten), :)', 2) == 0
                continue
            end
            
            % Save peth and markertimes for all presentations of this stimulus
            neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).peth = ...
                data.peth(strcmp(data.stimList{s},data.stim) & strcmp(data.attenList{ii},data.atten), :)';
            neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).markertime = ...
                data.timestamp(strcmp(data.stimList{s},data.stim) & strcmp(data.attenList{ii},data.atten), :)';
            
            % Does the peth indicate that any spikes occured?
            if any(any(neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).peth)) > 0
                
                % Find spikes that happen around each presentation of each sound
                chunker_timestamp = [];
                chunker_id = [];
                chunker_detectPoint = [];
                chunker_trace = [];
                for iii = 1:length(neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).markertime)
                    index = true(1,size(data_spikes,1));
                    index(data_spikes.timestamp>neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).markertime(iii)+data.postStim) = ...
                        false;
                    index(data_spikes.timestamp<neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).markertime(iii)-data.preStim) = ...
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
                neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).spikes.timestamp = ...
                    chunker_timestamp(chunker_id == 1,:);
                neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).spikes.detectPoint = ...
                    chunker_detectPoint(chunker_id == 1,:);
                neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).spikes.trace = ...
                    chunker_trace(chunker_id == 1,:);
                
                % If there were no spikes
            else
                neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).spikes.timestamp = [];
                neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).spikes.detectPoint = [];
                neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).spikes.trace = [];
            end
            
            neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).preStim = data.preStim;
            neuron.Sounds.(data.soundCat).(data.stimList{s}).(data.presentationmode).(data.attenList{ii}).postStim = data.postStim;
            data.presentationmode = strrep(data.presentationmode, '_retest', ''); %remove retest suffix if it was addedd
        end
    end
end

save(['D:\bat neuron database\', num2str(data.animalnum), '_', num2str(data.date), '_', num2str(data.depth), '.mat'], 'neuron')
clear neuron