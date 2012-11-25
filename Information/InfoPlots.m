function InfoPlots(XY_array1,XY_array2)
% InfoPlots(XY_array1,XY_array2)
%
% Plot data Information data
%
% Input
% -----
% XY_array1: structure with Information from 2 cone array.
% XY_array2: structure with Information from 2 cone array.
%
%
% Output
% ------
% Plots
%
%
% Options
% -------
% Working on it!
%
%
% Notes
% -----
% working fine now.

% plot Info results from arrays of different compositions:
figure('Units', 'pixels','Position', [500 700 800 575])
plot(XY_array1.Num/max(XY_array1.Num)*100,mean(XY_array1.Info_XY),'k',...
     XY_array2.Num/max(XY_array2.Num)*100,mean(XY_array2.Info_XY),'--k','linewidth',3);
set(gca,'fontsize',25, 'linewidth',2, 'TickDir', 'out');
legend('L,M array','L,S array','Location','South'); legend boxoff;
xlabel('% L');
ylabel('information (bits)');
box off;

% plot mutual/info from %L
figure('Units', 'pixels','Position', [500 700 800 575])
plot(XY_array1.Num/max(XY_array1.Num)*100,XY_array1.P_ratio_XY,'k',...
     XY_array2.Num/max(XY_array2.Num)*100,XY_array2.P_ratio_XY,'--k','linewidth',3);
set(gca,'fontsize',25, 'linewidth',2, 'TickDir', 'out');
legend('L,M array','L,S array','Location','South'); legend boxoff;
xlabel('% L');
ylabel('mutual/total information');
box off;


% plot optimal mosaic from %L
figure('Units', 'pixels','Position', [500 700 800 575])
plot(linspace(0,100,1000),XY_array1.Array_Info_XY,'k',...
     linspace(0,100,1000),XY_array2.Array_Info_XY,'--k','linewidth',3);
set(gca,'fontsize',25, 'linewidth',2, 'TickDir', 'out');
legend('L,M array','L,S array','Location','South'); legend boxoff;
xlabel('% L');
ylabel('information rate'); % (bits/(cone*10ms)
box off;
