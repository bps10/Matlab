function PlotImageSequence(Sequence1,Sequence2,FONT)
% PlotImageSequence1(Structure)
%
% Plot a sequences of images 
%
% Input 
% -----
% Structure:
% Color: 
%
% 
% Output
% ------
% Plot
%
%
% Options
% -------
% FONT: Fontsize. Default = 18.
%
%
% Notes
% -----
% Add option to change color channel used.
if nargin < 3
    FONT = 18;
end

FPS = Sequence1.MetaData.FPS;
SIZE = Sequence1.MetaData.SIZE;

% First sequence
hFig = figure(1);
set(hFig, 'Position', [1.25 2.5 1600.0 800.0])

subplot(2,5,1);
imagesc(Sequence1.RED_CUT(:,:,1)); colormap(gray(256)); daspect([1 1 1]); axis off;
title('time 0s','fontsize',FONT);

subplot(2,5,2);
frame = round((SIZE/3)*1);
imagesc(Sequence1.RED_CUT(:,:,frame)); colormap(gray(256)); 
daspect([1 1 1]); axis off;
title(['time ',num2str(frame/FPS,3),'s'],'fontsize',FONT);

subplot(2,5,3);
frame = round((SIZE/3)*2);
imagesc(Sequence1.RED_CUT(:,:,20)); colormap(gray(256));
daspect([1 1 1]); axis off;
title(['time ',num2str(frame/FPS,3),'s'],'fontsize',FONT);

subplot(2,5,4);
imagesc(Sequence1.RED_CUT(:,:,SIZE)); colormap(gray(256)); 
daspect([1 1 1]); axis off;
title(['time ', num2str(SIZE/FPS,3),'s'],'fontsize',FONT);

subplot(2,5,5);
imagesc(mean(Sequence1.RED_CUT(:,:,1:SIZE),3));colormap(gray(256));
daspect([1 1 1]); axis off;
title('mean image','fontsize',FONT);

% Second sequence
FPS = Sequence2.MetaData.FPS;
SIZE = Sequence2.MetaData.SIZE;

subplot(2,5,6);
imagesc(Sequence2.RED_CUT(:,:,1)); colormap(gray(256)); daspect([1 1 1]); axis off;
title('time 0s','fontsize',FONT);

subplot(2,5,7);
frame = round((SIZE/3)*1);
imagesc(Sequence2.RED_CUT(:,:,frame)); colormap(gray(256)); 
daspect([1 1 1]); axis off;
title(['time ',num2str(frame/FPS,3),'s'],'fontsize',FONT);

subplot(2,5,8);
frame = round((SIZE/3)*2);
imagesc(Sequence2.RED_CUT(:,:,20)); colormap(gray(256));
daspect([1 1 1]); axis off;
title(['time ',num2str(frame/FPS,3),'s'],'fontsize',FONT);

subplot(2,5,9);
imagesc(Sequence2.RED_CUT(:,:,SIZE)); colormap(gray(256)); 
daspect([1 1 1]); axis off;
title(['time ', num2str(SIZE/FPS,3),'s'],'fontsize',FONT);

subplot(2,5,10);
imagesc(mean(Sequence2.RED_CUT(:,:,1:SIZE),3));colormap(gray(256));
daspect([1 1 1]); axis off;
title('mean image','fontsize',FONT);
