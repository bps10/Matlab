function PlotSpaceTime2D(Sequence1,Sequence2,color,SIZE,FPS,Pxl_Per_Degree)
% PlotSpaceTime2D(Sequence1,Sequence2)
%
% Compare two FFT matrices in space time.
%
% Input
% -----
% Sequence1: 2 or 3D FFT matrix
% Sequence2: 2 or 3D FFT matrix
%
%
% Output
% ------
% Plot
%
%
% Options
% -------
% color: Indicate color of markers. Default = 'k'.
% SIZE: If meta data not available, indicate size of FFT matrix.
% FPS: If meta data not available, indiate FPS of FFT analyzed video.
% Pxl_Per_Degree: If meta data not available, indicate Pxl_Per_Degree.
% 
%
% Notes
% -----
%  Need to generalize 'FFT' into just find FFT.

if nargin < 3
    color = 'k';
    FFT1 = Sequence1.RED_FFT;
    FFT2 = Sequence2.RED_FFT;
else
    
    if strcmp(color, 'Red')
        FFT1 = Sequence1.RED_FFT;
        FFT2 = Sequence2.RED_FFT;
        color = 'r';
        
    elseif strcmp(color, 'Green')
        FFT1 = Sequence1.GREEN_FFT;
        FFT2 = Sequence2.GREEN_FFT;
        color = 'g';
        
    elseif strcmp(color, 'Blue')
        FFT1 = Sequence1.BLUE_FFT;
        FFT2 = Sequence2.BLUE_FFT;
        color = 'b';
        
    end

end

if nargin < 4
    SIZE = Sequence1.MetaData.SIZE;
end

if nargin < 5
    FPS = Sequence1.MetaData.FPS;
end

if nargin < 6
    Pxl_Per_Degree = Sequence1.MetaData.Pxl_Per_Degree;
end

% Draw in 1/f^2 and 1/f lines
hFig = figure; 
set(hFig, 'Position', [1.25 2.5 1600.0 1200.0])
FONT = 24;

freq = (1:length(FFT1(1,:)))/Pxl_Per_Degree;
subplot(2,2,1);
semilogx(freq,FFT1(1,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT1(5,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT1(10,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT1(15,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT1(20,:), '.','Color',color,'MarkerSize',14);
hold on;
semilogx(freq,log10(PowerLaw(freq,1,10^(min(FFT1(1,:))+1.25))),'k','Linewidth',2);
hold on;
semilogx(freq,log10(PowerLaw(freq,2,10^(max(FFT1(1,:))+1))),'k','Linewidth',2);
box off;
ylim([-7 -1])
xlim([0.025 1.5])
set(gca,'fontsize',FONT, 'linewidth',1, 'TickDir', 'out');
ylabel('spectral density (dB)','fontsize',FONT);
xlabel('spatial frequency (cpd)','fontsize',FONT);
title('fixation','fontsize',FONT);

% Draw in 1/w^2 and 1/w lines
subplot(2,2,3);
freq = (1:length(FFT1(:,1)))*(SIZE/FPS);

semilogx(freq,flipud(FFT1(:,1)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT1(:,5)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT1(:,10)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT1(:,15)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT1(:,20)), '.','Color',color,'MarkerSize',14);
hold on;
semilogx(freq,log10(PowerLaw(freq,1,10^(min(FFT1(:,20))))),'k','Linewidth',2);
hold on;
semilogx(freq,log10(PowerLaw(freq,2,10^(max(FFT1(:,1))+1.5))),'k','Linewidth',2);
box off;
ylim([-7 1])
set(gca,'fontsize',FONT, 'linewidth',1, 'TickDir', 'out');
ylabel('spectral density (dB)','fontsize',FONT);
xlabel('temporal frequency (Hz)','fontsize',FONT);



SIZE = Sequence2.MetaData.SIZE;
FPS = Sequence2.MetaData.FPS;

freq = (1:length(FFT2(1,:)))/Pxl_Per_Degree;
subplot(2,2,2);
semilogx(freq,FFT2(1,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT2(5,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT2(10,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT2(15,:), '.','Color',color,'MarkerSize',14);
hold on; semilogx(freq,FFT2(20,:), '.','Color',color,'MarkerSize',14);
hold on;
semilogx(freq,log10(PowerLaw(freq,1,10^(min(FFT2(1,:))+0.9))),'k','Linewidth',2);
hold on;
semilogx(freq,log10(PowerLaw(freq,2,10^(max(FFT2(1,:))+1.7))),'k','Linewidth',2);
box off;
ylim([-7 -1])
xlim([0.025 1.5])
set(gca,'fontsize',FONT, 'linewidth',1, 'TickDir', 'out');
ylabel('spectral density (dB)','fontsize',FONT);
xlabel('spatial frequency (cpd)','fontsize',FONT);
title('stable','fontsize',FONT);
% Draw in 1/w^2 and 1/w lines
subplot(2,2,4);
freq = (1:length(FFT2(:,1)))*(SIZE/FPS);

semilogx(freq,flipud(FFT2(:,1)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT2(:,5)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT2(:,10)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT2(:,15)), '.','Color',color,'MarkerSize',14);
hold on;semilogx(freq,flipud(FFT2(:,20)), '.','Color',color,'MarkerSize',14);
hold on;
semilogx(freq,log10(PowerLaw(freq,1,10^(min(FFT2(:,20)+0.5)))),'k','Linewidth',2);
hold on;
semilogx(freq,log10(PowerLaw(freq,2,10^(max(FFT2(:,1))+1.15))),'k','Linewidth',2);
box off;
ylim([-7 1])
set(gca,'fontsize',FONT, 'linewidth',1, 'TickDir', 'out');
ylabel('spectral density (dB)','fontsize',FONT);
xlabel('temporal frequency (Hz)','fontsize',FONT);