function [s, xy]  = effective_stim(stim)
% creates an effective stimulus time series
% s will have as many columns as there are "frequencies" in the stimulus
% this is pretty much a time course saying how much of each frequency is presented at
% each time point.
% xy simply says which x y location was stimulated at each time point

% create a basic template of ON / OFF stimulation at each location
template = cat(1, ones(stim.duration,1), zeros(stim.ISI,1));
template = repmat(template, [stim.repeat, 1]);

base_repeat_freq = repmat(template, [1, numel(stim.freq)]);
base_repeat_loc = repmat(template, [1, 2]);

% loops through cycles and location to extend the time series
s = [];
xy = []; %to keep track of which location is presented
for i_cycle = 1:stim.num_cycles
    for i_loc = 1:size(stim.pos,1)
        
        tmp_power = repmat(stim.pos_power(i_loc,:), [size(template,1),1]);
        s = [s; ...
            base_repeat_freq.*tmp_power];
        
        xy = [xy; ...
            base_repeat_loc.*stim.pos(i_loc,:)];
        
        s = [s; ...
            zeros(stim.time_bet_loc, numel(stim.freq))];
        
        xy = [xy; ...
            zeros(stim.time_bet_loc, numel(stim.freq))];
        
    end
end

end