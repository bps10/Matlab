function [m] = FitPowerLaw(powerspec,options)
% [m] = FitPowerLaw(powerspec,options)
%
% fit 1/f^m powerlaw to data, returns exponent
% 
% 
% Input
% -----
% powerspec: power spectrum for fitting.
% options: Indicate what form the data is in:
%           1 = raw power spec
%           2 = preprocessed into decibels
% 
% Output
% m: exponent that best fits a y(x) = 1/x^m power law to the data.
%
%
% Notes
% -----
% uses ezfit toolbox to fit data; see http://www.fast.u-psud.fr/ezyfit/
    
    eq = 'y(x) = a*(1/x^m);log';
    if options == 1
        dat = ezfit(powerspec,eq);
    end
    if options == 2
        dat = ezfit(10.^powerspec,eq);
    end
    m  = dat.m(2);