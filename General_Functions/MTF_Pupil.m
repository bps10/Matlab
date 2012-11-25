function [f] = MTF_Pupil(spatial_frequency,pupilDiameter,normalized)
% [f] = MTF(spatial_frequency, eccentricity)
%
% Compute the modulation frequency transfer as a function of pupil size
% as derrived in Artal and Navarro 1994. 
% F = 1-C * exp(-A*f) + C*exp(-B*f)
%
% Input
% -----
% spatial_frequency: array or integer of spatial frequencies
% eccentricity: eccentricity from 0 to 60 degrees at which to compute MTF.
% Linear interpolation is used for values that fall inbetween those
% reported in Navarro et al and are, therefore, less reliable though as expected.
% Pupil size reported (in mm): [2.5, 3.0, 4.0, 6.0, 8.0]. The behavior of
% this function in between reported sizes may be worse than MTF().
%
%
% Output
% ------
% f: MTF for input frequencies at given eccentricity.
%
%
% Options
% -------
% normalized: Default = 0 (no). 1 (yes) will normalize the spatial
% frequency.  This is not fully tested.  Permits comparison of a given
% optical system (eye) to a perfect one.  Requires consideration of maximum
% spatial frequency of the optical system (uLim).
%
%
% Notes
% -----
% normalized option 1 is not fully tested.

if nargin < 3
    normalized = 0;
end

pupil = [2.5, 3.0, 4.0, 6.0, 8.0];% in mm.

switch normalized
    case 0

    A_pupil = [0.16, 0.16, 0.18, 0.31, 0.53];% in degrees
    B_pupil = [0.06, 0.05, 0.04, 0.06, 0.08];% in degrees
    C_pupil = [0.36, 0.28, 0.18, 0.2, 0.11];% unitless

    
    A = interp1(pupil,A_pupil,pupilDiameter,'linear');
    B = interp1(pupil,B_pupil,pupilDiameter,'linear');
    C = interp1(pupil,C_pupil,pupilDiameter,'linear');


    f = (1 - C) .* exp(-A.*spatial_frequency) + C .* ...
            exp(-B.*spatial_frequency);

    case 1
        
    A_pupil = [10.57, 12.68, 19.04, 49.19, 112.15];% no dimension
    B_pupil = [3.96, 3.96, 4.23, 9.52, 16.92];% no dimension
    C_pupil = [0.36, 0.28, 0.18, 0.2, 0.11];% no dimension
    uLim = [66.1, 79.3, 105.8, 158.7, 211.6]; % in cycles/degree;
    
    A = interp1(pupil,A_pupil,pupilDiameter,'linear');
    B = interp1(pupil,B_pupil,pupilDiameter,'linear');
    C = interp1(pupil,C_pupil,pupilDiameter,'linear');
    u = interp1(pupil,uLim, pupilDiameter,'linear');
    
    f = (1 - C) .* exp(-A.*(spatial_frequency./u)) + C .* ...
            exp(-B.*(spatial_frequency./u));
end

