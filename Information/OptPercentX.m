function [XY_array] = OptPercentX(XY_array,PrintOption)
% [XY_array] = OptPercentX(XY_array,PrintOption)
% 
% Find the optimal percentage of X in an XY cone array with respect to
% information.
%
% Input
% -----
% XY_array: structure containing data about XY cone array
%
%
% Output
% ------
% XY_array: updated structure with OptPercentX
%
%
% Options
% -------
% PrintOption: print result. Yes = 1, No = 0. Default = 1.
%
%
% Notes
% -----
% Called after ConeInfoFunc.m and ArrayInfoFunc.m

if nargin < 2
    PrintOption = 1;
end

[~, indXY] = max(XY_array.Array_Info_XY);
XY_array.optPercentXY = indXY/length(XY_array.Array_Info_XY)*100;

if PrintOption == 1;
    disp(['Optimal %',XY_array.X_name',' in ',XY_array.X_name,...
        XY_array.Y_name, ': ',num2str(XY_array.optPercentXY)]);
end
