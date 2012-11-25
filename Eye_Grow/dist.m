function [distance] = dist(X,Y)
% [distance] = dist(X,Y)
%
% computes the distance between points on a circle
% Formula = sqrt((X(i) - X(i+1))^2 + (Y(i)-Y(i+1))^2)
%
%
% Input
% -----
% X: array of x values.
% Y: array of y values.
% 
%
% Output
% ------
% distance: array of distances in form: (Point(1) - Point(2) ... (Point(N) - Point(1))
%
%
% Notes
% -----
% Called by ComputeSpringForce
  

NumberofNodes = length(X);
distance = zeros(NumberofNodes,1);

for i=1:(NumberofNodes-1)
    distance(i) = sqrt((X(i)-X(i+1))^2 + (Y(i)-Y(i+1))^2);
end
% complete the circle, calcute distance between first and last node.
distance(NumberofNodes) = sqrt((X(1)-X(NumberofNodes))^2 + (Y(1)-Y(NumberofNodes))^2);