function [Nodes] = ComputePressure(Nodes)
% [Nodes] = ComputePressure(x,y,Initial_Press,Initial_Area)
%
% Calculate the intraocular pressure as a function of eye area. Accounts
% for decreased pressure as the area increases
%
% Input
% -----
% Nodes: node structure.
%
% Output
% ------
% Nodes: updated node structure.
%
% Notes
% -----
% Not currently being used since intraocular pressure usually remains
% constant or increases throughout development. Consequently, this function
% has not been fully tested.

    [~,rho] = cart2pol(Nodes.x,Nodes.y);
    area = sum((rho.^2)*pi./length(rho));
    ratio = area/Nodes.Initial_Area;
    
    P = Nodes.Initial_Press/2; % divide by 2 corrects for x and y dimensions spreading pressure.
    Nodes.Pressure = P./ratio;
