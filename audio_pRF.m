%% toy example for auditory pRF
% Assumes population reponds to 1 specific location and to one frequency
% this basically assumes that the gaussian of pRF is either 0 or so small
% that stimulation at other location do not affect a given neuronal
% population.

% In this example we have 4 locations and only 2 frequencies but this can
% be adapted below.
% Simplifies things as this way we only have 8 model pRF to compute

% Also the stimulus presented at each location has a different frequency
% content (this content can be changed in the script too)

% The script assumes that all the time series are generated with a 1 hz
% temporal resolution. And we use spm default HRF with TR = 1 second.

% TO DO
% implement population that respond differently to more than one frequency
% implment gaussian

clear
close all
clc

%% stimulus parameters
stim.duration = 1; % duration of each noise burst (in seconds)
stim.repeat = 5; % number of repeats of each noise burst at each location
stim.ISI = 1; % time between repeats of each noise burst at each location
stim.time_bet_loc = 6; % time between the end of a stim at one location and
% the beginning of stim at the next location
stim.num_cycles = 8; % number of time we cycles through all the locations

% positions simulated (0, 0) would be center of the screen
stim.pos = [
    1, 1;...
    1, -1;...
    -1, -1;...
    -1, 1];

stim.freq = [
    2000, 4000]; % which frequency are present in the stimulus

stim.pos_power = [
    2, 1;...
    0.5, 0.75;...
    1, 2;...
    0.75, 1]; % power of each frequency at each location


%% model parameters
pop_resp_model.pos = [
    1, 1;...
    1, -1;...
    -1, -1;...
    -1, 1];

pop_resp_model.freq = [
    2000, 4000];


%% create stimulus time series
[s, xy]  = effective_stim(stim);


%% compute all model responses
m = size(pop_resp_model.pos,1);
n = numel(pop_resp_model.freq);

for i_loc = 1:m
    for i_freq = 1:n
        % Each model population responds to only one frequency so we can only
        % take one of the columns from s
        % In a more realistic scenario each column would have to weighted by
        % how sensitive the population is to each frequency
        pop_resp = s(:,i_freq);
        
        
        % We then only take the inputs from the prefered location this model population is
        % sentitive to.
        % Once again a more realistic scenario would weight the different
        % locations differently like with a gaussian kernel as in the case of
        % vision pRF.
        pref_loc = all(xy==repmat(pop_resp_model.pos(i_loc,:), [size(xy,1), 1]), 2);
        
        pop_resp = pop_resp .* pref_loc;
        
        hrf = spm_hrf(1); % use an hrf for a TR = 1 second
        
        predictions{i_loc,i_freq} = conv(pop_resp, hrf); % convolve
        
    end
end


% plot the different model reponses
figure('name', 'possible predicted responses', 'position', [50 50 700 700])

MIN = cellfun(@min, predictions);
MIN = min(MIN(:));
MAX = cellfun(@max, predictions);
MAX = max(MAX(:));
i_mod = 1;
for i_loc = 1:m
    for i_freq = 1:n
        subplot(m, n, i_mod)
        plot(predictions{i_loc,i_freq}, 'linewidth', 2);
        axis([1 size(predictions{1},1) MIN MAX])
        title(sprintf(...
            'x = %i ; y = %i, freq = %i',...
            pop_resp_model.pos(i_loc,1),...
            pop_resp_model.pos(i_loc,2),...
            pop_resp_model.freq(i_freq)))
        i_mod = i_mod + 1;
    end
end