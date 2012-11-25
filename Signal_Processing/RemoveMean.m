function [out] = RemoveMean(image)
%  [out] = RemoveMean(image)
%
% subtract the mean of an image.
%
% Input
% -----
% image: input image.
%
%
% Output
% ------
% out: image with mean subtracted
%
%
% Notes
% -----
%

[x y] = size(image);
mu = sum(sum(image))/(x*y);
out = image - mu;