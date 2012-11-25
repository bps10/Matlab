function [M_X,M_Y] = FindPowerExponents(spectrum)
% [M_X,M_Y] = FindPowerExponents(spectrum)
% 
% Find the exponent,m, that provides a best fit for to data using 1/f^m for
% a 2D spectrum.
%
% Input
% -----
% spectrum: power spectrum.
%
%
% Output
% ------
% M_X: values that are best fits to data in X columns
% M_Y: values that are best fits to data in Y columns
%
%
% Notes
% -----
%

[xs ys] = size(spectrum);

M_Y = zeros(ys,1);
M_X = zeros(xs,1);

for i = 1:xs
    M_X(i) = FitPowerLaw(spectrum(i,:),2);
end

for i = 1:ys
    M_Y(i) = FitPowerLaw(flipud(spectrum(:,i)),2);
end

