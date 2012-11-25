function [FIXATION,STABLE] = CutVideos(video, EYE_POS, SIZE,START_TIME)
% [FIXATION,STABLE] = CutVideos(video, EYE_POS, SIZE,START_TIME)
%
% Extract out area of a video fixated by a viewer and a stable region in
% the center of the video for comparison.  This function will keep the RGB
% channels seperate and add meta data to the struct output (FPS, SIZE,
% Pxl_Per_Degree).
%
% Input
% -----
% video: video file read into matlab with VideoReader or mmread.
% EYE_POS: processed gaze data.
% SIZE: size of the region of interest (in spacetime; pxls x pxls x frames).  
%       A 15 pixel boarder will be included around this area.  When viewers
%       look near the edge of a video, a simple heuristic is employed to    
%       ensure the full image is cropped.
% START_TIME: time (in sec) in the video to begin cutting.
%
%
% Output
% ------
% FIXATION: Structure with RGB channels cropped for a fixated region of the image.
% STABLE: Structure with RGB channels cropped for a fixated region of the image.
%
%
% Notes
% -----
% Eventually, buffer should be a percentage of the SIZE, not just a hard
% coded number.
%
RED_CUT = zeros((SIZE) + 31,(SIZE) + 31, SIZE + 31);
GREEN_CUT = zeros((SIZE) + 31,(SIZE) + 31,SIZE + 31);
BLUE_CUT = zeros((SIZE) + 31,(SIZE) + 31,SIZE + 31);

% Add MetaData:
FPS = round(video.rate);
Meta.FPS = FPS;
Meta.SIZE = SIZE;
Meta.Pxl_Per_Degree = 26.7;


FIXATION = struct('RED_CUT',RED_CUT,'GREEN_CUT',GREEN_CUT,'BLUE_CUT',BLUE_CUT,...
    'MetaData',Meta);
STABLE = struct('RED_CUT',RED_CUT,'GREEN_CUT',GREEN_CUT,'BLUE_CUT',BLUE_CUT,...
    'MetaData',Meta);

HALF_SIZE = round(SIZE/2) + 15;

for i = 1:SIZE
    % will want to mean data between scenes, take INDEX into account.
    LOC = round(EYE_POS(i+(START_TIME*FPS),:));

    if LOC(1) > 720-HALF_SIZE
        LOC(1) = 720-HALF_SIZE;
    elseif LOC(1) < HALF_SIZE+1
        LOC(1) = HALF_SIZE+1;
    end
    if LOC(2) > 1280 - HALF_SIZE
        LOC(2) = 1280 - HALF_SIZE;
    elseif LOC(2) < HALF_SIZE+1
        LOC(2) = HALF_SIZE+1;
    end

    RedChannel = video.frames(i).cdata(:,:,1);
    GreenChannel = video.frames(i).cdata(:,:,2);
    BlueChannel = video.frames(i).cdata(:,:,3);
    
    % cut out region of fixation:
    FIXATION.RED_CUT(:,:,i) = RedChannel(LOC(1)-HALF_SIZE:LOC(1)+HALF_SIZE,LOC(2)-...
        HALF_SIZE:LOC(2)+HALF_SIZE);
    FIXATION.GREEN_CUT(:,:,i) = GreenChannel(LOC(1)-HALF_SIZE:LOC(1)+HALF_SIZE,LOC(2)-...
        HALF_SIZE:LOC(2)+HALF_SIZE);
    FIXATION.BLUE_CUT(:,:,i) = BlueChannel(LOC(1)-HALF_SIZE:LOC(1)+HALF_SIZE,LOC(2)-...
        HALF_SIZE:LOC(2)+HALF_SIZE);
    
    STABLE.RED_CUT(:,:,i) = RedChannel(360-HALF_SIZE:360+HALF_SIZE,640-HALF_SIZE:...
        640+HALF_SIZE);
    STABLE.GREEN_CUT(:,:,i) = GreenChannel(360-HALF_SIZE:360+HALF_SIZE,640-HALF_SIZE:...
        640+HALF_SIZE);
    STABLE.BLUE_CUT(:,:,i) = BlueChannel(360-HALF_SIZE:360+HALF_SIZE,640-HALF_SIZE:...
        640+HALF_SIZE);
    
    % subtract the DC of each image region:
    FIXATION.RED_CUT(:,:,i) = RemoveMean(FIXATION.RED_CUT(:,:,i)); 
    FIXATION.GREEN_CUT(:,:,i) = RemoveMean(FIXATION.GREEN_CUT(:,:,i));
    FIXATION.BLUE_CUT(:,:,i) = RemoveMean(FIXATION.BLUE_CUT(:,:,i));
    
    FIXATION.MetaData.Type = 'fixation';
    
    STABLE.RED_CUT(:,:,i) = RemoveMean(STABLE.RED_CUT(:,:,i));
    STABLE.GREEN_CUT(:,:,i) = RemoveMean(STABLE.GREEN_CUT(:,:,i));
    STABLE.RED_CUT(:,:,i) = RemoveMean(STABLE.BLUE_CUT(:,:,i));
    
    STABLE.MetaData.Type = 'stable';
    
    
end
