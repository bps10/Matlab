function [Sequence] = SpaceTimeStats(Sequence,Analysis_Opt,SIZE)
% [Sequence] = SpaceTimeStats(Sequence, MEAN_OPT)
%
% Find the power spectrum for a series of images or a temporally meaned image for
% three color channels.
%
% Input
% -----
% Sequence: Structure containing video or image data to be analyzed
% Analysis_Opt: 0 = video only. 
%               1 = temporally meaned only. 
%               2 = compute video and mean anlysis.
% 
% 
% Output
% ------
% Sequence: Updated structure with output from video or image power
% spectrum.
%
%
% Options
% -------
% SIZE: If not a structure, input the size of the region of interest.
%
%
% Notes
% -----
% Continue to generalize.

if nargin < 3
    SIZE = Sequence.MetaData.SIZE;
end

switch Analysis_Opt 
    case 0

        Sequence.RED_FFT = welch3d(Sequence.RED_CUT,SIZE);
        Sequence.GREEN_FFT = welch3d(Sequence.GREEN_CUT,SIZE);
        Sequence.BLUE_FFT = welch3d(Sequence.BLUE_CUT,SIZE);

    case 1

        % compute mean and spatiotemporal FFTs
        Sequence.Mean_RED_Power = welch2d(mean(Sequence.RED_CUT,3),SIZE); % 64 pxl = 64/26.7 deg.
        Sequence.Mean_GREEN_Power = welch2d(mean(Sequence.GREEN_CUT,3),SIZE);
        Sequence.Mean_BLUE_Power = welch2d(mean(Sequence.BLUE_CUT,3),SIZE);

    case 2
        
        % compute mean and spatiotemporal FFTs
        Sequence.Mean_RED_Power = welch2d(mean(Sequence.RED_CUT,3),SIZE); % 64 pxl = 64/26.7 deg.
        Sequence.Mean_GREEN_Power = welch2d(mean(Sequence.GREEN_CUT,3),SIZE);
        Sequence.Mean_BLUE_Power = welch2d(mean(Sequence.BLUE_CUT,3),SIZE);

        Sequence.RED_FFT = welch3d(Sequence.RED_CUT,SIZE);
        Sequence.GREEN_FFT = welch3d(Sequence.GREEN_CUT,SIZE);
        Sequence.BLUE_FFT = welch3d(Sequence.BLUE_CUT,SIZE);
        

end