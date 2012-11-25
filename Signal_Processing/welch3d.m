function avg = welch3d(x,L_xyz,over,win,Density)
% [avg] = welch3d(x,L,over,win,Density)
%
% 3D spectrum estimation using Welch's method.
% The spectrum of a process x is estimated using Welch's method
%	of averaging modified periodograms.
%
% Input
% -----
% x: input sequence
% L: section length 
% over: amount of overlap, where 0<over<1, 
% win : The window type 
%           1 = Rectangular
%           2 = Hamming
%           3 = Hanning
%           4 = Bartlett
%           5 = Blackman
%
%
% Output
% ------
% [avg] = Welch's estimate of the power spectrum, returned in decibels. 
%	
%
% Options
% -------
% Density: default returns estimate in spectral density measured in
% decibels. Passing a 1 here will turn this off and return the raw
% estimate.
%
% 
% Notes
% ------
% Modified from:
% M.H. Hayes.  "Statistical Digital Signal Processing and Modeling"
% (John Wiley & Sons, 1996).

if nargin < 5
    Density = 0;
end

if (nargin <= 3)
    win=2; 
end

if (nargin<=2) 
    over =0.5; %default is %50 overlap.
end

if (nargin<=1)
    L_xyz = length(x(:,:,1));% round(length(x(:,1))/2); %default is %100 window size
end


if L_xyz < length(x(:,1))/2
    error('Length must be longer than 1/2 length of x');
end

if (over >= 1) || (over < 0)
    error('Overlap is invalid');
end

n0 = (1-over)*L_xyz;
n1 = [1 1 1] - n0;
n2 = [L_xyz L_xyz L_xyz] - n0;
nsect = 1 + floor((length(x)-L_xyz)/(n0));

Px = 0;
for ix = 1:nsect
        n1(1) = n1(1) + n0;
        n2(1) = n2(1) + n0;
    for iy = 1:nsect
        n1(2) = n1(2) + n0;
        n2(2) = n2(2) + n0;
        for iz = 1:nsect
            n1(3) = n1(3) + n0;
            n2(3) = n2(3) + n0;
            Px = Px + PowerSpectrum3(x( n1(1):n2(1), n1(2):n2(2), n1(3):n2(3) ),...
                win)/(nsect^3);
        end
    end
end

%Px = log10(Px);

[xs ys zs] = size(Px);

W_s = zeros(floor(zs),floor(xs/2));
for i = 1:floor(zs)
    fft = Px(:,:,i);
    f2 = -xs/2:xs/2-1;
    f1 = -ys/2:ys/2-1;
    [XX YY] = meshgrid(f1,f2);
    [~, r] = cart2pol(XX,YY);
    if mod(xs,2)==1 || mod(ys,2)==1
        r = round(r)-1;
    else
        r = round(r);
    end

    avg = accumarray(r(:)+1, fft(:)) ./ accumarray(r(:)+1, 1);
    avg = avg(2:floor(min(xs,ys)/2)+1);
    W_s(i,:) = avg';
end

[xs ys] = size(W_s);
if mod(xs,2)==1
    x2s = round(xs/2) +1;
else
    x2s = xs/2;
end
avg = zeros(x2s-1,ys);
for i = 1:x2s-1
    avg(i,:) = 0.5*(W_s(i,:) + W_s((xs+1)-i,:));
end

if Density == 0
    avg = SpectrumDensity(avg);
end








