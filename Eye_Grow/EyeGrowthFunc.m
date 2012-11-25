function [Nodes] = EyeGrowthFunc(NumberofNodes,age,LengthofTime,INTSTEP,Pressure,...
    LOOSEN,K_change,LocationOfLoosen,LengthofLoosen,VideoPlot)
% [Nodes] = EyeGrowthFunc((NumberofNodes,age,LengthofTime,INTSTEP,Pressure,...
%    LOOSEN,K_change,LocationOfLoosen,LengthofLoosen,VideoPlot)
%
% Compute the change in node position given a set of input parameters
%
% Input
% -----
% NumberofNodes: Typical = 36.
% age: Age in years at start of simulation. Typical = 6.
% LengthofTime: Duration of simulation in years. Typical = 12.
%  
%
% Output
% ------
% Nodes: structure containing info about node locations
% 
%
% Options
% -------
% INTSTEP: Integration step in fraction of year. Typical = 0.01.
% Pressure: Intraocular eye pressure. Default = 0.002.
%
%
% Loosening Options
% -----------------
% LOOSEN: Choose whether to loosen springs, 0 = no, 1 = yes. Default = 0.
% K_change: If loosening, chose how much to change the spring constant,K 
%     by. Default = 0.25.
% LocationOfLoosen: If loosening, choose location of loosened springs. 
%     Default = 1.
% LengthofLoosen: If loosening,choose number of springs to loosen.          
%     Default = 1.
%  
%
% Plot Options:
% ------------
% VideoPlot: Choose to plot a video of the nodes. Default = 0 (no).
%
%
% Notes
% -----
% see Hung et al. 2010.

%% Input defaults:
if nargin < 10
    VideoPlot = 1;
end
if nargin < 9
    LengthofLoosen = 1;
end
if nargin < 8
    LocationOfLoosen = 1;
end
if nargin < 7
    K_change = 0.25;
end
if nargin < 6
    LOOSEN = 0;
end
if nargin < 5
    Pressure = 0.002;
end
if nargin < 4
    INTSTEP = 0.01;
end


%% Set up for main loop
AGE = age:INTSTEP:(LengthofTime+(age-INTSTEP));

% Generate Nodes as objects
Nodes = GenerateNodes(NumberofNodes,age,Pressure,LengthofTime,INTSTEP);
% Generate Springs as objects
Springs = GenerateSprings(NumberofNodes,Nodes,LOOSEN,K_change,LocationOfLoosen,...
    LengthofLoosen);

if VideoPlot == 1;
    [plt,txt] = GenerateMovie(Nodes,AGE,INTSTEP);
end

%% Start of main loop
for time = 1:LengthofTime/INTSTEP

    if AGE(time) < 10.5
        K = Springs.Young;
    elseif AGE(time) >= 10.5
        K = Springs.Old;
    end     
    
    Nodes = ComputeSpringForce(Nodes,Springs.Spring_Eq,K);
    
    Nodes = ComputePressureForce(Nodes);
    
    Nodes.xx = Nodes.F_Px - Nodes.F_Sx; % force
    Nodes.yy = Nodes.F_Py - Nodes.F_Sy; % force

    Nodes.xDOT = Nodes.xDOT + Nodes.xx*INTSTEP; % update velocity
    Nodes.yDOT = Nodes.yDOT + Nodes.yy*INTSTEP; % update velocity

    Nodes.x = Nodes.x + Nodes.xDOT*INTSTEP; 
    Nodes.y = Nodes.y + Nodes.yDOT*INTSTEP; 

    Nodes = CheckNodes(Nodes,time);
    
    
    switch VideoPlot
        case 1
    %if VideoPlot == 1
            set(plt,'XData',Nodes.x([1:end 1])*Nodes.Radius);
            set(plt,'YData',Nodes.y([1:end 1])*Nodes.Radius);
            set(txt,'String',num2str(AGE(time),'%.0f'));
            drawnow;
            pause(0.001);
            Nodes.ModelEyeLength(time) = abs(min(Nodes.x)*Nodes.Radius) + max(Nodes.x*Nodes.Radius);
        case 0
            Nodes.ModelEyeLength(time) = abs(min(Nodes.x)*Nodes.Radius) + max(Nodes.x*Nodes.Radius);
    end

end