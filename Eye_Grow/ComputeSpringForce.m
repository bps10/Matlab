function [Nodes] = ComputeSpringForce(Nodes,Spring_Eq,K)
% [Nodes] = ComputeSpringForce(x,y,Spring_Eq,K)
%
% Finds the inward force exerted by the two springs pulling on each node. 
% Uses Hooke's Law and assumes two springs pull on each node.  
%
%
% Input
% -----
% Nodes: structure containing nodes
% Spring_Eq: array of spring equilibrium values.
% K: array of K values.
%
%
% Output
% ------
% Nodes: updated node structure.
%
%
% Notes
% -----
% K values typically change with age.
%
    
[theta,~] = cart2pol(Nodes.x,Nodes.y);
distance = dist(Nodes.x,Nodes.y);
    
F_s1 = -K.*(Spring_Eq - distance);
F_s2 = F_s1([end 1:end-1]);
F_S = F_s1+F_s2;
[Nodes.F_Sx,Nodes.F_Sy] = pol2cart(theta,F_S);
