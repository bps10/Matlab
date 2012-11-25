function PlotSpaceTime3D(Sequence,FONT)
% PlotSpaceTime3D(Sequence)
%
% Plot a 3D representation of Spatial freq, Temporal Freq and Power for 3
% color channels.
% 
% Input
% -----
% Sequence: Structure containing FFT for a sequence of images (video).
%
%
% Output
% ------
% Plot
% 
%
% Options
% -------
% FONT: Fontsize. Default = 24.
% 
% Notes
% -----
% Need to add in color limit to standardize across all three plots.  Should
% be an option.

if nargin < 2
    FONT = 24;
end
SIZE = Sequence.MetaData.SIZE;
FPS = Sequence.MetaData.FPS;



hFig = figure();
set(hFig, 'Position', [1.25 2.5 1400.0 1400.0])
%clims = [0 max(max(log(Sequence.RED_FFT)))];

[x y] = size(Sequence.RED_FFT');
[xx yy] = meshgrid(1:x, 1:y);
x = xx/26.7*2;
y = yy*(SIZE/FPS);

subplot(2,2,1);
surf(x,y,log10(flipud(Sequence.RED_FFT)),'EdgeColor','none','FaceColor','interp'); view(2); %'CDataMapping','scaled'
grid off; box on;
set(gca,'xscale','log','fontsize',FONT,'linewidth',2, 'TickDir', 'in'); %'xscale','log',
xlim([min(min(x)) max(max(x))]);
ylim([min(min(y)) max(max(y))]);
xlabel('spatial frequency (cpd)','fontsize',FONT);
ylabel('temporal frequency (Hz)','fontsize',FONT);
%caxis([0 max(max(log(RED_FFT)))]);
colorbar('linewidth',2,'fontsize',FONT);
pbaspect([1 1 1]);
title('red channel');

subplot(2,2,2);
surf(x,y,log10(flipud(Sequence.GREEN_FFT)),'EdgeColor','none','FaceColor','interp'); view(2);
grid off; box on;
set(gca,'xscale','log','fontsize',FONT,'linewidth',2, 'TickDir', 'in'); %'xscale','log',
xlim([min(min(x)) max(max(x))]);
ylim([min(min(y)) max(max(y))]);
xlabel('spatial frequency (cpd)','fontsize',FONT);
ylabel('temporal frequency (Hz)','fontsize',FONT);
%caxis[0 max(max(log(RED_FFT)))];
colorbar('linewidth',2,'fontsize',FONT);
pbaspect([1 1 1]);
title('green channel');

subplot(2,2,3);
surf(x,y,log10(flipud(Sequence.BLUE_FFT)),'EdgeColor','none','FaceColor','interp'); view(2);
grid off; box on;
set(gca,'xscale','log','fontsize',FONT,'linewidth',2, 'TickDir', 'in'); %'xscale','log',
xlim([min(min(x)) max(max(x))]);
ylim([min(min(y)) max(max(y))]);
xlabel('spatial frequency (cpd)','fontsize',FONT);
ylabel('temporal frequency (Hz)','fontsize',FONT);
%caxis[0 max(max(log(RED_FFT)))];
colorbar('linewidth',2,'fontsize',FONT);
pbaspect([1 1 1]);
title('blue channel')
