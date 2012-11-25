function [data,bins] = histOutline(histIn,binsIn)
% [data,bins] = histOutline(histIn,binsIn]
%
% Process histogrammed data for plotting as an outline with plot().
%
% Input
% -----
% histIn: 1D histogram counts.
% binsIn: bins used for 1D histogram.
%
%
% Output
% ------
% data: processed data ready to be plotted.
% bins: processed bins ready to be plotted with data.
%
%
% Notes
% -----
%

stepSize = binsIn(2) - binsIn(1);
 
bins = zeros((length(binsIn)*2 + 2),1);
data = zeros((length(binsIn)*2 + 2),1);
for bb = 1:length(binsIn)
    bins(2*bb + 1) = binsIn(bb);
    bins(2*bb + 2) = binsIn(bb) + stepSize;
    if bb < length(histIn)
        data(2*bb + 1) = histIn(bb);
        data(2*bb + 2) = histIn(bb);
    end
end
bins(1) = bins(2);
bins(end-1) = bins(end-2);
data(1) = 0;
data(end-1) = 0; 
