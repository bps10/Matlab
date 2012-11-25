function [rate] = NodeRate(age,timeStep)
% [rate] = EyeLength(age)
%
% this function uses the best fit model from Zadnik et al. (2004) for axial
% growth to find growth rate over a given timeStep.
%
% Input
% -----
% age: age in years 
% timeStep: duration of time over which to compute the rate (age-timeStep),
%     in years.
%
%
% Output
% ------
% rate: rate of eye growth at a give age, during a given duration of time.
%
%
% Notes
% -----
% Called by GenerateNodes.m
%
    
if age < 10.5
    length1 = 20.189 + 1.258*log(age);
    length2= 20.189 + 1.258*log(age-timeStep);
elseif age >= 10.5
    length1 = 21.353 + 0.759*log(age);
    length2 = 21.353 + 0.759*log(age-timeStep);
end
    
rate = length1 - length2;
    