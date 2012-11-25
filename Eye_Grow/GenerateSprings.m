function [Springs] = GenerateSprings(NumberofNodes,Nodes,loosening,K_change,loc,len)
% [Springs] = GenerateSprings(NumberofNodes,Nodes,loosening,K_change,loc,len)
%
% Generate a spring object
%
% Input
% -----
% NumberofNodes: number of nodes in simulation
% Nodes: structure containing node information
% loosening: Select whether to loosen any of the springs. Yes = 1, No = 0.
% K_change: If loosening, select how much to change the spring constant, K.
% loc: If loosening, select the region to loosen. Currently loosening is
%     symmetric
% len: If loosening, select the number of springs to loosen.
%
%
% Output
% ------
% Springs: spring structure with 'young' and 'old' spring constants and
% spring equalibrium.
%
%
% Notes
% -----
% May eventually want to make the loosening area gaussianly distributed.

Spring_Eq = ones(NumberofNodes,1)*(max(dist(Nodes.x,Nodes.y)));
Springs = struct('Young',ones(NumberofNodes,1)*0.19,'Old',ones(NumberofNodes,1)*0.025,...
        'Spring_Eq',Spring_Eq); 

% set the location of weakened springs.
% multiply K by specific locations of Spring to tighten or weaken it.
if loosening == 1;

    Springs.Young(loc:loc+len-1) = Springs.Young(loc:loc+len-1).*K_change;
    Springs.Young(NumberofNodes-(loc+len-1)+1:NumberofNodes-(loc)+1) = ...
            Springs.Young(NumberofNodes-(loc+len-1)+1:NumberofNodes-(loc)+1).*K_change;

    Springs.Old(loc:loc+len-1) = Springs.Old(loc:loc+len-1).*K_change;
    Springs.Old(NumberofNodes-(loc+len-1)+1:NumberofNodes-(loc)+1) = ...
            Springs.Old(NumberofNodes-(loc+len-1)+1:NumberofNodes-(loc)+1).*K_change;
end
