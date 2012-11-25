function [plt,txt] = GenerateMovie(Nodes,AGE,INTSTEP)
% [plt,txt] = GenerateMovie(Nodes,AGE,INTSTEP)
%
% Create a movie of eye growth. To be used with EyeGrowthFunc.m
%
% Input
% -----
% Nodes: structure containing nodes
% AGE: array of ages (e.g. linspace(start_age, end_age,(end_age/INTSTEP) ))
% INTSTEP: time step used for integration
%
%
% Output
% ------
% plt: plot handle for Node plot.  Used to update during for loop.
% txt: text handle for Node plot.  "                            "
%
%
% Plotting Options
% ----------------
% Coming soon!
%
%
% Notes
% -----
% Called in EyeGrowthFunc.m

%set plotting parameters:
hFig = figure;
set(hFig, 'Position', [.25 2.5 700.0 700.0])
plot(Nodes.x([1:end 1])*Nodes.Radius,Nodes.y([1:end 1])*Nodes.Radius, '-ok', ...
    'linewidth', 3,'MarkerFaceColor','k','MarkerSize',7);
xlim([-13 13])
ylim([-13 13])
axis equal;
hold on;
plt = plot(Nodes.x([1:end 1])*Nodes.Radius,Nodes.y([1:end 1])*Nodes.Radius,'-or',...
    'linewidth',3,'MarkerFaceColor','r');
text(-12,-11,'Age:','fontsize',15);
txt = text(-12.0,-12.0,num2str(AGE(1)+INTSTEP,'%.0f'),'erasemode','normal','fontsize',15);