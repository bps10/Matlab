function [f] = MTF(spatial_frequency,eccentricity)
% [f] = MTF(spatial_frequency, eccentricity)
%
% Compute the modulation frequency transfer as a function of eccentricity
% as derrived in Navarro, Artal, and Williams 1993. 
% F = 1-C * exp(-A*f) + C*exp(-B*f)
%
% Input
% -----
% spatial_frequency: array or integer of spatial frequencies
% eccentricity: eccentricity from 0 to 60 degrees at which to compute MTF.
% Linear interpolation is used for values that fall inbetween those
% reported in Navarro et al and are, therefore, less reliable though as expected.
% Eccentricities reported (in degrees): [0, 5, 10, 20, 30, 40, 50, 60]
%
%
% Output
% ------
% f: MTF for input frequencies at given eccentricity.
%
%
% Notes
% -----
%

theta = [0.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0]; % in degrees
A_theta = [0.172, 0.245, 0.245, 0.328, 0.606, 0.82, 0.93, 1.89];% in degrees
B_theta = [0.037, 0.041, 0.041, 0.038, 0.064, 0.064, 0.059, 0.108];% in degrees
C_theta = [0.22, 0.2, 0.2, 0.14, 0.12, 0.09, 0.067, 0.05];% unitless

% linear interpolation:

A = interp1(theta,A_theta,eccentricity,'linear');
B = interp1(theta,B_theta,eccentricity,'linear');
C = interp1(theta,C_theta,eccentricity,'linear');

f = (1 - C) .* exp(-A.*spatial_frequency) + C .* ...
    exp(-B.*spatial_frequency);