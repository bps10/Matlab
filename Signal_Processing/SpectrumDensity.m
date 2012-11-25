function [decibel] = SpectrumDensity(rawSpectrum)
% function [decibel] = SpectrumDensity(rawSpectrum)
%
% find the spectrum density (sums to 1), then find log10 to convert
% into decibels.
%
% Input
% -----
% rawSpectrum: Power Spectrum
%
%
% Output
% ------
% decibel: log 10 spectrum normalized to sum to 1. (spectral density in
% decibels.
%
%
% Notes
% -----
% Called by Welch2d.m and Welch3d.m.
    normSpec = rawSpectrum./sum(rawSpectrum(:));
    decibel = log10(normSpec);