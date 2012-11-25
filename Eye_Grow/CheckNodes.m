function [Nodes] = CheckNodes(Nodes,time)
% [Nodes] = CheckNodes(Nodes,time)
%
% Make sure that the nodes do not cross over or move in towards the center.
%
% Input
% -----
% Nodes: node structure
% time: time in the integration algorithm
%
% Output
% ------
% Nodes: updated node structure.
% 
% Notes
% -----
%

% COnditionals constraining the motion of nodes
    [Nodes.theta(:,time+1),Nodes.r(:,time+1)] = cart2pol(Nodes.x,Nodes.y);
    a = find((Nodes.r(:,time+1)-Nodes.r(:,time))<0);
    [~,Nodes.I(:,time+1)] = sort(Nodes.theta(:,time+1));
    if time > 1
        c = find(Nodes.I(:,time+1)-Nodes.I_initial~=0);
    else
        c = 0;
    end
    if sum(a)>0 && sum(c)>0
        Nodes.r(a,time+1) = Nodes.r(a,time);
        d = Nodes.I(c,time+1);
        Nodes.theta(d,time+1) = Nodes.theta(d,time);
        [Nodes.x,Nodes.y] = pol2cart(Nodes.theta(:,time+1),Nodes.r(:,time+1));
    elseif sum(c)>0
        d = Nodes.I(c,time+1);
        Nodes.theta(d,time+1) = Nodes.theta(d,time);
        [Nodes.x,Nodes.y] = pol2cart(Nodes.theta(:,time+1),Nodes.r(:,time+1));
    elseif sum(a)>0
        Nodes.r(a,time+1) = Nodes.r(a,time);
        [Nodes.x,Nodes.y] = pol2cart(Nodes.theta(:,time+1),Nodes.r(:,time+1));
    end