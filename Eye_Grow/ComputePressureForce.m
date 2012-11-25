function [Nodes] = ComputePressureForce(Nodes)
% [Nodes] = ComputePressureForce(Nodes)
%
% Update the pressure force on the nodes.
%
% Input
% -----
% Nodes: node structure.
%
%
% Output
% ------
% Nodes: updated node structure.
%
% 
% Notes
% -----
%

    F_Px = Nodes.Pressure.*(Nodes.x./(abs(Nodes.x)+abs(Nodes.y)));
    F_Py = Nodes.Pressure.*(Nodes.y./(abs(Nodes.x)+abs(Nodes.y)));

    hyp = hypot(F_Px,F_Py);
    Nodes.F_Px = F_Px.*(Nodes.Pressure./hyp);
    Nodes.F_Py = F_Py.*(Nodes.Pressure./hyp);