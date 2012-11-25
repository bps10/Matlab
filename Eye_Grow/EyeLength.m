function [eyeLength] = EyeLength(age)
% [eyeLength] = EyeLength(age)
%
% this function derived from Zadnik et al. (2004) - Emmetropic Eye
% Growth
%
% Input
% -----
% age: age in years at which to compute axial length.
%
%
% Output
% ------
% eyeLength: axial length of eye in mm.
%
% 
% Notes
% -----
% This function is called by GenerateNodes.m and Eye_Growth_Main.m for
% plotting.
    
if age < 10.5
    eyeLength = 20.189 + 1.258*log(age);
elseif age >= 10.5
    eyeLength = 21.353 + 0.759*log(age);
end
    
    