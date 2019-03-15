%% Find each test, stim, and atten combo for each neuron
close all
clearvars -except neurons


binSize = 20; %ms per bin for smaller peth
slide = 5; %ms of sliding window

for i = length(neurons)-2:length(neurons)
    plots = figure('units','normalized','outerposition',[0 0 0.5 1]);
    plots.Name = [num2str(neurons(i).animalNum), '_', num2str(neurons(i).date), '_', num2str(neurons(i).depth), '_',   ' rasters and PSTHs' ];
    spikes = figure('units','normalized','outerposition',[0 0 0.5 1]);
    plots.Name = [num2str(neurons(i).animalNum), '_', num2str(neurons(i).date), '_', num2str(neurons(i).depth), '_',   ' rasters and PSTHs' ];
    count = 0;
    
    stimuli = fieldnames(neurons(i).sounds);
    % drop1 = contains(stimuli, 'Appease');
    % stimuli(drop1|drop2|drop3) = []; % Drop attenuated tests
    % Batch through all sound categories
    for ii = 1:length(stimuli)
        % Batch through all attenuations
        attenuations = fieldnames(neurons(i).sounds.(stimuli{ii}));
        drop1 = contains(attenuations, 'dB_70');
        attenuations(~drop1) = []; % Drop attenuated tests
        
        % Batch through all attenuation levels
        for iii = 1:length(attenuations)
            data.preStim = 150;%neurons(i).sounds.(stimuli{ii}).(attenuations{v}).preStim;
            data.postStim = 850;%neurons(i).sounds.(stimuli{ii}).(attenuations{v}).postStim;
            data.peth1ms.peth = neurons(i).sounds.(stimuli{ii}).(attenuations{iii}).peth;
            [~, col] = find(isnan(data.peth1ms.peth));
            data.peth1ms.peth(:, unique(col)) = []; % drop reps with NaN
            [data.peth1ms.bins, data.peth1ms.reps] = size(data.peth1ms.peth);
            [data.rasterrow, data.raster] = find(data.peth1ms.peth);
            
            if data.peth1ms.reps < 3
                clear data
                continue
            end
            
            bin=0;
            for p = binSize:binSize:data.peth1ms.bins
                bin = bin + 1;
                data.pethBin.peth (bin, 1:data.peth1ms.reps) = sum(data.peth1ms.peth(p-binSize+1:p, :));
            end
            
            bin = 0;
            for p = (binSize/2):slide:data.peth1ms.bins-(binSize/2)
                bin = bin + 1;
                data.pethBinSlide.peth (bin, 1:data.peth1ms.reps) = sum(data.peth1ms.peth(p-(binSize/2)+1:p+(binSize/2), :));
            end
            clear p bin
            
            data.pethBin.meanRate = (mean(data.pethBin.peth, 2) / binSize) * 1000;
            data.pethBinSlide.meanRate = (mean(data.pethBinSlide.peth, 2) / binSize) * 1000;
            
            %% Mean PSTH responsive bins
            count = count+1;
            heighth =max(data.pethBinSlide.meanRate)+10;
            data.rasterspacer = heighth / data.peth1ms.reps;
            
            figure(plots)
            ax(1) = subplot(ceil(length(fieldnames(neurons(i).sounds))/3), 3, count);
            plot(linspace(-data.preStim, data.postStim, length(data.pethBinSlide.meanRate)), data.pethBinSlide.meanRate', ...
                'Color', [0.5 0.5 0.5], 'linewidth', 2)
            hold on
            scatter(data.rasterrow-data.preStim, data.raster*data.rasterspacer, 1, 'filled', 'k')
            ylim([-2 heighth+2])
            xlim([-(data.preStim+5) (data.postStim+5)])
            title([stimuli{ii}, ' ', attenuations{iii}, ' (nReps=', num2str(data.peth1ms.reps),')'], 'Interpreter', 'none')
            xlabel('time (ms)'); ylabel('Firing rate (Hz)');
            set(gca, 'TickDir', 'out'); set(gca, 'xcolor', 'k')
            set(gca, 'FontName', 'Arial Narrow'); set(gca, 'fontsize', 8)
            %         set(gca, 'ytick', []); set(gca, 'color', 'none')
            set(gca, 'box', 'off')
            
            %% Plot spike overlays
            figure(spikes)
            ax(2) = subplot(ceil(length(fieldnames(neurons(i).sounds))/3), 3, count);
            if isfield(neurons(i).sounds.(stimuli{ii}).(attenuations{iii}), 'spikes')
                plot(neurons(i).sounds.(stimuli{ii}).(attenuations{iii}).spikes.trace', 'Color', [0.5 0.5 0.5]);
                hold on
                plot(mean(neurons(i).sounds.(stimuli{ii}).(attenuations{iii}).spikes.trace,1), ...
                    'k', 'LineWidth', 2)
            end
            title([stimuli{ii}, ' ', attenuations{iii}], 'Interpreter', 'none')
            axis tight
            set(gca, 'FontName', 'Arial Narrow'); set(gca, 'fontsize', 8)
            set(gca, 'ytick', []); set(gca, 'xtick', [])
            set(gca, 'color', 'none')
            %                     set(gca, 'box', 'off')
            
            clear data
        end
    end
    saveas(plots, ...
        [num2str(neurons(i).animalNum), '_', num2str(neurons(i).date), '_', num2str(neurons(i).depth), '_',   ' rasters and PSTHs' ], ...
        'png')
    saveas(spikes, ...
        [num2str(neurons(i).animalNum), '_', num2str(neurons(i).date), '_', num2str(neurons(i).depth), '_',   ' spikes' ], ...
        'png')
    close all
end


% set(ax, 'YLim', [-2, heighth]);% max(scaler)])
% clear ax scaler
