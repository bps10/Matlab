function avg = pxl_corr(a,b)

if nargin == 1
    b = a;
end
corr = conv2(a,rot90(b,2));
%corr = c/var(a(:));

[xs ys] = size(corr);
f2 = -xs/2:xs/2-1;
f1 = -ys/2:ys/2-1;
[XX YY] = meshgrid(f1,f2);
[~, r] = cart2pol(XX,YY);
if mod(xs,2)==1 || mod(ys,2)==1
    r = round(r)-1;
else
    r = round(r);
end

avg = accumarray(r(:)+1, corr(:))./ accumarray(r(:)+1, 1);
avg = avg(1:floor(min(xs,ys)/2)+1);
avg = avg./max(avg);