function PlotMeanPower(Sequence1,Pixels_Per_Degree,FONT)
% PlotMeanPower(Sequence1,Pixels_Per_Degree,FONT)
%
% Plot the Mean Power over a sequence of images
%
% Input
% -----
% Sequence1: Image sequence with Power meaned for each color channel.
%
%
% Output
% ------
% Plot
%
%
% Options
% -------
% Pixels_Per_Degree: Default = 26.7, from Dorr et al. 2010.
% FONT: fontsize.  Default = 20.
% 
%
% Notes
% -----
%
%
if nargin < 2
    Pixels_Per_Degree = 26.7;
end

if nargin < 3
    FONT = 20;
end

figure();
freq = (1:length(Sequence1.Mean_RED_Power))/Pixels_Per_Degree;
semilogx(freq,Sequence1.Mean_RED_Power, 'r.','MarkerSize',14);
hold on;
semilogx(freq,Sequence1.Mean_GREEN_Power,'g.','MarkerSize',14);
hold on;
semilogx(freq,Sequence1.Mean_BLUE_Power,'b.','MarkerSize',14);
hold on;
semilogx(freq,log10(PowerLaw(freq,1,10^(min(Sequence1.Mean_GREEN_Power)+1))),'k','Linewidth',2);
hold on;
semilogx(freq,log10(PowerLaw(freq,2,10^(max(Sequence1.Mean_GREEN_Power)+0.5))),'k','Linewidth',2);
ylabel('spectral density (dB)','FontSize',FONT);
xlabel('cycles/degree','FontSize',FONT);
xlim([1/30 length(Sequence1.Mean_RED_Power)/20]);
%ylim([10^floor(log10(min(Mean_BLUE_Power))) 10^10]);% 20^ceil(log10(max(Mean_RED_Power)))]);
legend('L','M','S'); legend boxoff;
set(gca,'fontsize',FONT, 'linewidth',1, 'TickDir', 'out');
title([Sequence1.MetaData.Type, ' region'],'fontsize',FONT);
box off;