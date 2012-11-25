function [Nodes] = GenerateNodes(NumberofNodes,age,Pressure,LengthofTime,INTSTEP)
% [Nodes] = GenerateNodes(NumberofNodes,age,Pressure,LengthofTime,INTSTEP)
%
% Creates a structure of nodes based on the input parameters.
%
% Input
% -----
% NumberofNodes: the number of nodes desired.
% age: age at the start of the simulation, in years.
% Pressure: intraocular pressure.
% LengthofTime: duration of the simulation, in years.
% INTSTEP: integration step, in fraction of a year.
%
%
% Output
% ------
% Nodes: structure of nodes
%
%
% Notes
% -----
% Initial node acceleration is still a free parameter.

% Parameters of emmetropic eye from 2004 paper:
Child_Eye_Length = EyeLength(age); % in mm
initial_node_acc = NodeRate(age,INTSTEP);

Radius = Child_Eye_Length/2.0;
F_Px_initial = ones(NumberofNodes,1)*Pressure*0.5;
F_Py_initial = ones(NumberofNodes,1)*Pressure*0.5;%

% set the location of each of the nodes.
location = linspace(0,2*pi - (2*pi/NumberofNodes),NumberofNodes);
x = cos(location(1:NumberofNodes))'; % 16mm typical size @ birth.
y = sin(location(1:NumberofNodes))';

Pressure = Pressure./NumberofNodes;

[THETA,R] = cart2pol(x,y);
[~, I_initial] = sort(THETA);
Initial_Area = sum((R.^2)*pi./length(R));

% Preallocate memory:
% Memory for checks:
r  = zeros(NumberofNodes,(LengthofTime/INTSTEP)+1);
theta = zeros(NumberofNodes,(LengthofTime/INTSTEP)+1);
I = zeros(NumberofNodes,(LengthofTime/INTSTEP)+1);

% Memory for velocities.
[xDOT,yDOT] = pol2cart(THETA,initial_node_acc*4);
xDOT = ones(NumberofNodes,1).*xDOT;
yDOT = ones(NumberofNodes,1).*yDOT;

% Memory for force.
xx = zeros(NumberofNodes,1);
yy = zeros(NumberofNodes,1);

% Memory for eye length.
ModelEyeLength = zeros(LengthofTime/INTSTEP,1);

Nodes = struct('x',x,'y',y,'Radius',Radius,'F_Px_initial',F_Px_initial,...
    'F_Py_initial',F_Py_initial,'Node_Accel',initial_node_acc,'Pressure',...
    Pressure,'xDOT',xDOT,'yDOT',yDOT,'xx',xx,'yy',yy,'Initial_Area',Initial_Area,...
    'I_initial',I_initial,'r',r,'theta',theta,'I',I,'ModelEyeLength',ModelEyeLength);
