function [out] = PowerLaw(freq,power,max_power)
% [out] = PowerLaw(freq,power,max_power)
%
% Create an array according to a power law for plotting.
%
% Input
% -----
% freq: frequencies to be plotted on x axis
% power: power exponent to use
% max_power: maximum power (y axis).
%
%
% Output
% ------
% out: array of values according to 1/freq^power . 
%
%
% Notes
% -----
%
    
    norm_freq = (1./freq.^power)./max(1./freq.^power);
    out = norm_freq.*max_power;