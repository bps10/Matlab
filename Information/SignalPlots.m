function SignalPlots(L_analysis,M_analysis,S_analysis,BINS,Compute_Analyses)
% SignalPlots(L_analysis,M_analysis,S_analysis,BINS,Compute_Analyses)
%
% Plot statistical data about Signals: histograms, spatial frequency and
% average correlation.
%
% Input
% -----
% L_analysis: structure containing L data from SignalGen.m
% M_analysis: structure containing M data from SignalGen.m
% S_analysis: structure containing S data from SignalGen.m
% BINS: BINS used to create histograms of LMS singals. Output from
%     SignalGen.m
% Compute_Analyses: Option about what plots to generate. Must agree with
%     the data contained in LMS_analysis structures (can't plot what isn't
%     there.
%
%
% Output
% ------
% Plots: Compute_Analyses = 1; signal hist
%                         = 2; signal hist, spatial freq
%                         = 3; signal hist, spatial freq, correlation
%
%
%
% Options
% -------
% Coming soon!
%
%
% Notes
% -----
% 

figure('Units', 'pixels','Position', [500 700 800 575]);
plot(BINS,mean(L_analysis.count,1),'r',BINS,mean(M_analysis.count,1),...
    'g',BINS,mean(S_analysis.count,1),'b', 'linewidth',2.5);
box off;
xlim([-1000 Inf])
ylim([-20000 Inf])
legend('L','M','S'); legend boxoff;
set(gca,'fontsize',25, 'linewidth',2, 'TickDir', 'out');
xlabel('R*/10ms');
ylabel('pixels');


%% Plot average spatial frequency
if Compute_Analyses >= 2
    figure('Units', 'pixels','Position', [500 700 800 575]);
    loglog((1:length(L_analysis.power)).*2./46/2,mean(L_analysis.power,1),'r.','markersize',8);
    hold on;
    loglog((1:length(M_analysis.power)).*2./46/2,mean(M_analysis.power,1),'g.','markersize',8);
    hold on;
    loglog((1:length(S_analysis.power)).*2./46/2,mean(S_analysis.power,1),'b.','markersize',8);
    box off;
    legend('L','M','S'); legend boxoff;
    set(gca,'fontsize',25, 'linewidth',2, 'TickDir', 'out');
    xlabel('spatial frequency (cycles / deg)');
    ylabel('power');
end
%% Plot average correlation
if Compute_Analyses == 3
    figure('Units', 'pixels','Position', [500 700 800 575]);
    plot((1:length(L_analysis.corr))./46,mean(L_analysis.corr,1),'r','linewidth',2.5);
    hold on;
    plot((1:length(M_analysis.corr))./46,mean(M_analysis.corr,1),'g','linewidth',2.5);
    hold on;
    plot((1:length(S_analysis.corr))./46,mean(S_analysis.corr,1),'b','linewidth',2.5);
    box off;
    legend('L','M','S'); legend boxoff;
    set(gca,'fontsize',25, 'linewidth',2, 'TickDir', 'out');
    ylim([0 1]);
    xlim([0 7]);
    xlabel('seperation (deg)');
    ylabel('mean correlation');
end