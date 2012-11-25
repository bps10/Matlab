clear all; close all;

%% Settings

SIZE = 64; % size of analysis region in pixels.

GAZE_DIRECTORY = 'C:\Data\Video\gaze\natural_movies_gaze';
VIDEO_DIRECTORY = 'C:\Data\Video\movies-m2t';
LOCATION = 'bridge_1';
SUBJECT = 'All'; % Enter subject initials or 'All' to analyze gaze data 
                 % across all subjects
Find_Exponents = 1;
% Plotting options (1 = plot, 0 = don't plot):
Plot_Image_Sequence = 0;
Plot_Mean_Power = 0;
Plot_3D_SpaceTime = 0;
Plot_2D_SpaceTime = 1;

%% Notes:

% see http://www.inb.uni-luebeck.de/tools-demos/gaze for more details.
% data reported in Dorr, Martinetz, Gefenfurtner & Barth. 2010 JOV.

% gaze parameters:
% from the paper: 'videos covered about 48 by 27 degrees of visual field 
% and about 26.7 pixels on the screen corresponded to 1 degree of visual
% angle for the high resolution movies (1280 by 720 pixels)'


%% Import video

VIDEO = mmread([VIDEO_DIRECTORY,'\',LOCATION,'.m2t']); % can select certain frames.
% this imports huge object.
FPS = round(VIDEO.rate);

%% Main Section:

% Decide if analyzing only one subject or all subjects on the same scene.
if strcmp(SUBJECT,'All');
    Analysis_Type = 2;
else
    Analysis_Type = 1;
end


switch Analysis_Type
    case 1
        % find the mean eye position during each 33ms frame.
        EYE_POS = findEyePosition(VIDEO.nrFramesTotal,EYE.data(:,4),EYE.data(:,2:3));
        
        % find the first continuous period of time long enough for analysis.
        START_TIME = findStartTime(EYE_POS,SIZE,FPS);

        % slice video into regions of interest - fixated and central regions:
        [FIXATION, STABLE] = CutVideos(VIDEO, EYE_POS, SIZE,START_TIME);

        [FIXATION] = SpaceTimeStats(FIXATION,2);
        [STABLE] = SpaceTimeStats(STABLE,2);


    case 2
        
        files = getAllFiles(GAZE_DIRECTORY);
        gaze_files = endswith(files,[LOCATION,'.coord']);
        files = files(gaze_files==1);

        FIXATION = struct('RED_FFT',0,'GREEN_FFT',0,'BLUE_FFT',0);
        STABLE = struct('RED_FFT',0,'GREEN_FFT',0,'BLUE_FFT',0);
        n = length(files);
        for i = 1:n
            % import gaze data into an object.
            EYE = importdata(char(files(i)), ' ',2);

            % Extract gaze matrix
            
            % find the mean eye position during each 33ms frame.
            EYE_POS = findEyePosition(VIDEO.nrFramesTotal,EYE.data(:,4),EYE.data(:,2:3));
            
            % find the first continuous period of time long enough for analysis.
            START_TIME = findStartTime(EYE_POS,SIZE,FPS);

            % slice video into regions of interest - fixated and central regions:
            [fixation, stable] = CutVideos(VIDEO, EYE_POS, SIZE,START_TIME);
            
            
            FIXATION.RED_FFT = FIXATION.RED_FFT + welch3d(fixation.RED_CUT,SIZE)./n;
            FIXATION.GREEN_FFT = FIXATION.GREEN_FFT + welch3d(fixation.GREEN_CUT,SIZE)./n;
            FIXATION.BLUE_FFT = FIXATION.BLUE_FFT + welch3d(fixation.BLUE_CUT,SIZE)./n;

            STABLE.RED_FFT = STABLE.RED_FFT + welch3d(stable.RED_CUT,SIZE)./n;
            STABLE.GREEN_FFT = STABLE.RED_FFT + welch3d(stable.GREEN_CUT,SIZE)./n;
            STABLE.BLUE_FFT = STABLE.RED_FFT + welch3d(stable.BLUE_CUT,SIZE)./n;

        end

        % inherit meta data:
        FIXATION.MetaData = fixation.MetaData;
        STABLE.MetaData = stable.MetaData;
        
        
        %save([num2str(LOCATION),'_FIXATION.mat'],'-struct','FIXATION');
        %save([num2str(LOCATION),'_STABLE.mat'],'-struct','STABLE');
        if Find_Exponents == 1;
            X_Bin = linspace(1,3,20);
            Y_Bin = linspace(0,2.5,20);
            [Xfix Yfix] = FindPowerExponents(FIXATION.RED_FFT);
            Xfix = hist(Xfix,X_Bin);
            Yfix = hist(Yfix,Y_Bin);

            [Xstab Ystab] = FindPowerExponents(STABLE.RED_FFT);
            Xstab = hist(Xstab,X_Bin);
            Ystab = hist(Ystab,Y_Bin);

            % create outlines of histogram for prettier plots
            [Xfix,X_Bins] = histOutline(Xfix,X_Bin);
            [Xstab,~] = histOutline(Xstab,X_Bin);
            [Yfix,Y_Bins] = histOutline(Yfix,Y_Bin);
            [Ystab,~] = histOutline(Ystab,Y_Bin);
            
            figure;
            plot(X_Bins,Xfix,X_Bins,Xstab,'linewidth',2.5);
            box off;
            set(gca,'fontsize',20,'TickDir', 'out');
            xlabel('m','fontsize',20);
            ylabel('count','fontsize',20);
            title('temporal freq','fontsize',20);
            xlim([1 3]);
            legend('fixated','stable'); legend boxoff;
            
            figure;plot(Y_Bins,Yfix,Y_Bins,Ystab,'linewidth',2.5); 
            box off;
            set(gca,'fontsize',20,'TickDir', 'out');
            xlabel('m','fontsize',20);
            ylabel('count','fontsize',20);
            title('spatial freq','fontsize',20);
            xlim([0 2.5]);
            legend('fixated','stable', 'location','NorthWest'); legend boxoff;

        end
end

%% Plot sequential scenes
if Plot_Image_Sequence == 1

    PlotImageSequence(FIXATION,STABLE);

end
%% Mean Power Stats and Plot:

if Plot_Mean_Power == 1

    PlotMeanPower(FIXATION);
    PlotMeanPower(STABLE);

end
%% Space-time statistics:

if Plot_3D_SpaceTime == 1

    PlotSpaceTime3D(FIXATION);
    
end
%% 2D Space-time plot:

if Plot_2D_SpaceTime == 1;

    PlotSpaceTime2D(FIXATION,STABLE);
    
end
