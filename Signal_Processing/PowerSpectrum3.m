function [fftim] = PowerSpectrum3(im,win,n1,n2)
% [fftim] = PowerSpectrum3(im,win,n1,n2)
%
% 3D spectrum estimation using the modified periodogram.
% This one includes a window function to decrease variance in the estimate.
%
% Input
% -----
% x   : input sequence
% n1  : starting index, x(n1)
% n2  : ending index, x(n2)
% win : The window type 
%           1 = Rectangular
%           2 = Hamming
%           3 = Hanning
%           4 = Bartlett
%           5 = Blackman
%
% Output
% ------
% fftim: spectrum estimate.
%
% 
% Notes
% -----
% If n1 and n2 are not specified the periodogram of the entire
%       sequence is computed.
% 

if nargin <= 2
    n1 = 1;  n2 = length(im(:,1));  
end

if nargin == 1
    win = 2;
end

[xs ys zs] = size(im);
if xs/ys ~= 1 || xs/zs ~=1
    error('Dimensions must be equal');
end

N  = n2 - n1 +1;
w  = ones(N,1);

if (win == 2) 
    w = hamming(N(1));
elseif (win == 3) 
   w = hanning(N(1));
elseif (win == 4) 
   w = bartlett(N(1));
elseif (win == 5) 
   w = blackman(N(1)); 
end

m = ones(length(w),length(w),length(w));
foo = (w(:)*w(:).');
for i = 1:length(w)
    m(:,:,i) = foo;
end

U  = norm(w)^3/N(1)^3;

fftim = abs(fftshift(fftn(double(im.*m)))).^2/((N(1)^3)*U);

    
end
