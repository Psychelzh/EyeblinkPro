function eyeblinkplot(EOGv, stat, cfg)
%For visual checking of the fitness of the algorithm. And also a way of
%checking the validity of data.
%
%cfg contains these fields:
%   pid: subject id
%   resamplefs: sampling rate
%   starttime: start time

%By Zhang, 2/29/2016.
%Change log: changed input arguments. 3/22/2016.

%Checking input argument.
if nargin <= 2
    cfg.pid = nan;
    cfg.starttime = 0;
    cfg.resamplefs = 256;
end
if ~isfield(cfg, 'pid'), cfg.pid = nan; end
if ~isfield(cfg, 'starttime'), cfg.starttime = 0; end
if ~isfield(cfg, 'resamplefs'), cfg.resamplefs = 256; end
if nargin <= 1
    error('UDF:EYEBLINKPLOT:NotEnoughInput', 'At least two input arguments are needed.');
end

%Initializing processing.
startpoint = floor(cfg.resamplefs * cfg.starttime) + 1;
%Plotting.
ntrial = length(EOGv.trial);
for itrial = 1:ntrial
    figure
    hold on
    EOG = EOGv.trial{itrial}(3, startpoint:end);
    plot((1:length(EOG)) / cfg.resamplefs, EOG)
    for i = 1:length(stat(itrial).blinkpeak)
        plot((stat(itrial).LB(i):stat(itrial).RB(i)) / cfg.resamplefs, EOG(stat(itrial).LB(i):stat(itrial).RB(i)), 'g')
        plot(stat(itrial).blinkpeak(i) / cfg.resamplefs, EOG(stat(itrial).blinkpeak(i)), 'xr')
    end
    xlabel('Time(s)')
    ylabel('EOG(\muV)')
    title(sprintf('Subject: %d', cfg.pid));
    %Wait until user close the gui.
    uiwait(gcf)
end
