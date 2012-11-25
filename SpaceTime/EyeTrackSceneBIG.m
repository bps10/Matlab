clear all; close all;

%% Settings

SIZE = 64; % size of analysis region in pixels.

GAZE_DIRECTORY = 'C:\Data\Video\gaze\natural_movies_gaze';
VIDEO_DIRECTORY = 'C:\Data\Video\movies-m2t';
DATA_DIRECTORY = 'C:\Data\Video\FFT_DATA\';

Find_Exponents = 1;
Mode = 'Plotting'; % Either 'Plotting' or 'Analysis'.  
                   % Note: 'Analysis' is long and slow.  Will save a lot of files.
Save_Files = 0;
%% Notes:

% see http://www.inb.uni-luebeck.de/tools-demos/gaze for more details.
% data reported in Dorr, Martinetz, Gefenfurtner & Barth. 2010 JOV.

% gaze parameters:
% from the paper: 'videos covered about 48 by 27 degrees of visual field 
% and about 26.7 pixels on the screen corresponded to 1 degree of visual
% angle for the high resolution movies (1280 by 720 pixels)'

%% Get file names

% Import eye tracking data:

video_files = getAllFiles(VIDEO_DIRECTORY);
LOCATION = cell(length(video_files),1);
for i = 1:length(video_files)
    foo = char(video_files(i));
    LOCATION{i} = foo(length(char(VIDEO_DIRECTORY))+2:end-4);
end

%% Analysis section
if strcmp(Mode,'Analysis')
    Mode = 0;
elseif strcmp(Mode,'Plotting')
    Mode = 1;
else 
    error('Mode not supported.  Please check your spelling and try again.')
end

switch Mode
    case 0
        for j = 1:length(LOCATION)
            disp(j);

            VIDEO = mmread([VIDEO_DIRECTORY,'\',LOCATION{j},'.m2t']); 
            % this imports huge object.
            FPS = round(VIDEO.rate);

            files = getAllFiles(GAZE_DIRECTORY);
            gaze_files = endswith(files,[LOCATION{j},'.coord']);
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


            if Save_Files == 1 % figure out how to save to directory. i.e.DATA_DIRECTORY
                save([DATA_DIRECTORY, num2str(LOCATION{j}),'_FIXATION.mat'],...
                    '-struct','FIXATION');
                save([DATA_DIRECTORY, num2str(LOCATION{j}),'_STABLE.mat'],...
                    '-struct','STABLE');
            end

            clear FIXATION; clear STABLE; clear fixation; clear stable; clear EYE_POS;
            clear START_TIME;
        end

%% Plotting Section:
    case 1
        MEAN_FIXATION = struct('RED_FFT',0,'GREEN_FFT',0,'BLUE_FFT',0);
        MEAN_STABLE = struct('RED_FFT',0,'GREEN_FFT',0,'BLUE_FFT',0);


        n = length(LOCATION);
        for i = 1:n

            loc = [DATA_DIRECTORY,char(LOCATION(i))];
            fixation = load([loc,'_FIXATION']);
            stable = load([loc,'_STABLE']);

            MEAN_FIXATION.RED_FFT = MEAN_FIXATION.RED_FFT + fixation.RED_FFT./n;
            MEAN_FIXATION.GREEN_FFT = MEAN_FIXATION.GREEN_FFT + fixation.GREEN_FFT./n;
            MEAN_FIXATION.BLUE_FFT = MEAN_FIXATION.BLUE_FFT + fixation.BLUE_FFT./n;

            MEAN_STABLE.RED_FFT = MEAN_STABLE.RED_FFT + stable.RED_FFT./n;
            MEAN_STABLE.GREEN_FFT = MEAN_STABLE.GREEN_FFT + stable.GREEN_FFT./n;
            MEAN_STABLE.BLUE_FFT = MEAN_STABLE.BLUE_FFT + stable.BLUE_FFT./n;

        end

        % inherit meta data:
        MEAN_FIXATION.MetaData = fixation.MetaData;
        MEAN_STABLE.MetaData = stable.MetaData;


        if Save_Files == 1
            save([DATA_DIRECTORY,'_MeanFixation.mat'],'-struct','MEAN_FIXATION');
            save([DATA_DIRECTORY,'_MeanStable.mat'],'-struct','MEAN_STABLE');
        end    

        % Plot data for each color channel:

        color = {'Red','Green','Blue'};
        for i = 1:3
            PlotSpaceTime2D(MEAN_FIXATION,MEAN_STABLE,color(i));
        end
        
        if Find_Exponents == 1;
            
            X_Bin = linspace(1,3,20);
            Y_Bin = linspace(0,2.5,20);
            [Xfix Yfix] = FindPowerExponents(MEAN_FIXATION.RED_FFT);
            Xfix = hist(Xfix,X_Bin);
            Yfix = hist(Yfix,Y_Bin);

            [Xstab Ystab] = FindPowerExponents(MEAN_STABLE.RED_FFT);
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

