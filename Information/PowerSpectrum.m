function [avg] = PowerSpectrum(im)
n = ndims(im);

if n == 2
    [xs ys] = size(im);
    fftim = abs(fftshift(fft2(double(im)))).^2;
    f2 = -xs/2:xs/2-1;
    f1 = -ys/2:ys/2-1;
    [XX YY] = meshgrid(f1,f2);
    [~, r] = cart2pol(XX,YY);
    if mod(xs,2)==1 || mod(ys,2)==1
        r = round(r)-1;
    else
        r = round(r);
    end

    avg = accumarray(r(:)+1, fftim(:)) ./ accumarray(r(:)+1, 1);
    avg = avg(2:floor(min(xs,ys)/2)+1);

elseif n == 3
    
    [xs ys] = size(im(:,:,1));
    fftim = abs(fftshift(fftn(double(im)))).^2;
    
    W_s = zeros(length(fftim(1,1,:)),floor(xs/2));
    for i = 1:length(fftim(1,1,:))
        fft = fftim(:,:,i);
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
end    