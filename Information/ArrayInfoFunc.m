function [XY_array] = ArrayInfoFunc(XY_array,interp_method)
% [XY_array] = ArrayInfoFunc(P_ratio_XY,P_ratio_LS,Numer_XY,Numer_LS)
%
% Compute the information in an array of cones based on small array
% information rates computed by ConeInfoFunc.m
%
% Input
% -----
% XY_array: takes XY_array generated from ConeInfoFunc.m and generates
% approximation of larger cone array using equation 3 from page 6 of
% garrigan et al.
%
%
% Output
% ------
% XY_array: updated XY_array.
%
% Options
% -------
% interp_method: 'poly' or 'linear'. Default = 'poly'.
%
%
% Notes
% -----
% Used after a call to ConeInfoFunc.m

if nargin < 3
    interp_method = 'poly';
end

% First find the P_ratio_XY, i.e. Mutual/Total Information.
XY_array.P_ratio_XY = XY_array.Mutual_XY./mean(XY_array.Info_XY);

% Second find the numerator to equation 3 on page 6 of Garrigan et al.
XY_array.Numerator_XY = mean(XY_array.Info_XY) - XY_array.Mutual_XY;


switch interp_method
    case 'linear' % linear interpolation to find P_XY, looks complicated but it's not:
        P_XY = zeros(1000,1);
        Num_XY = zeros(1000,1);
        Proportion = linspace(0,1,1000);
        for i = 1:1000
            Proportion_X = (Proportion(i)*6) + 1;
            P_XY(i) = XY_array.P_ratio_XY(floor(Proportion_X)) + ...
                (( (Proportion_X - floor(Proportion_X))* ...
                XY_array.P_ratio_XY(ceil(Proportion_X)) - ...
                ((Proportion_X - floor(Proportion_X))* ...
                XY_array.P_ratio_XY(floor(Proportion_X))) ) / ...
                (ceil(Proportion_X) - floor(Proportion_X))); 

            Num_XY(i) = XY_array.Numerator_XY(floor(Proportion_X)) + ...
                (( (Proportion_X - floor(Proportion_X))* ...
                XY_array.Numerator_XY(ceil(Proportion_X)) - ...
                ((Proportion_X - floor(Proportion_X))* ...
                XY_array.Numerator_XY(floor(Proportion_X))) ) / ...
                (ceil(Proportion_X) - floor(Proportion_X))); 

        end

    case 'poly' % this appears to be what Garrigan et al. use.
        Pfit_XY = polyfit(0:6,XY_array.P_ratio_XY,2);
        P_XY = polyval(Pfit_XY,linspace(0,6,1000));
        
        Nfit_XY = polyfit(0:6,XY_array.Numerator_XY,2);
        Num_XY = polyval(Nfit_XY,linspace(0,6,1000));
    otherwise
        error('Unexpected interpolation method');
end


% Fourth find the Array Information using equation 3, page 6.
Array_Info_XY = zeros(1000,1);
for i = 1:1000
    Array_Info_XY(i) = Num_XY(i) / (1 + P_XY(i));
end

XY_array.Array_Info_XY = Array_Info_XY/(6*10);




