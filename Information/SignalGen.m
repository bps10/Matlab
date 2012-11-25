function [L_analysis,M_analysis,S_analysis,BINS] = SignalGen(DIRECTORY,...
    AUX_DIRECTORY,Analysis_Option)
% function [L_analysis,M_analysis,S_analysis,BINS] = SignalGen(DIRECTORY,...
%            AUX_DIRECTORY,Analysis_Option)
%
% Generate LMS signals for Info analysis from LMS isomerization rates from
% the specified directories.  Used AUX_DIRECTORY to avoid files that have
% greater than 5% saturated pixels (as described in Garrigan et al.).  
%
% Input
% -----
% DIRECTORY : Location of Images to be analyzed.
% AUX_DIRECTORY: Location of Auxilarly files with warning info.
% 
%
% Output
% ------
% L_analysis: struct containing analysis of L cone isomerization rates.
% M_analysis: struct containing analysis of M cone isomerization rates.
% S_analysis: struct containing analysis of S cone isomerization rates.
% BINS: Bin edges used to compute histogram.
%
%
% Options
% -------
% Analysis_Option: 1 = R* histogram, 
%                  2 = R*, Power Spectrum, 
%                  3 = R*, PS & Correlation. Default = 1.
% BIN_RESOLUTION: Number of bins to use in histogram. Default = 300.
%
%
% Notes
% -----
% Still not quite right. May need to add additional image selection
% heuristics?

%% Generate signals:
if nargin < 4
    BIN_RESOLUTION = 300;
end
if nargin < 3
    Analysis_Option = 1;
end

% Perhaps consider focus, FFT.
% can undo the cone settings by dividing by the scalar values obtained for
% cone parameters: L: 1.75*10^5, M: 1.60*105, S: 3.49*10^4 Tkacik et al. pg
% 10
%cc = image.LMS_Image;
%c = cc(:,:,1)./1.75*10^5

% First find an index of images that contain pixel saturations:
AUX_Files = getAllFiles(AUX_DIRECTORY);
goodFiles = zeros(length(AUX_Files),1);
for i=1:length(AUX_Files)
    AUX_File = load(char(AUX_Files(i)));
    if isempty(AUX_File.Image.warning)
        goodFiles(i) = 1;
    else 
        goodFiles(i) = 0;
    end
end

%set up memory and variables used in all cases
BINS = linspace(0,4*10^4,BIN_RESOLUTION);
files = getAllFiles(DIRECTORY);
stop = length(files);
L_count = zeros(sum(goodFiles),length(BINS));
M_count = zeros(sum(goodFiles),length(BINS));
S_count = zeros(sum(goodFiles),length(BINS));
j = 0;

% find the desired analysis option:
switch Analysis_Option
    case 1
        for i=1:stop
            if goodFiles(i) == 1
                j = j+1;
                image = load(char(files(i))); 

                L_raw = image.LMS_Image(:,:,1);
                L_raw = L_raw(:)./100;% change into units R*/10ms
             
                M_raw = image.LMS_Image(:,:,2);
                M_raw = M_raw(:)./100;

                S_raw = image.LMS_Image(:,:,3);
                S_raw = S_raw(:)./100;
                
                L_count(j,:) = histc(L_raw,BINS); 
                M_count(j,:) = histc(M_raw,BINS);
                S_count(j,:) = histc(S_raw,BINS);

            end
        end
        L_analysis = struct('name','L','count',L_count);
        M_analysis = struct('name','M','count',M_count);
        S_analysis = struct('name','S','count',S_count);

    case 2
        SIZE = load(char(files(1)));
        SIZE = SIZE.LMS_Image(:,:,1);
        SIZE = length(SIZE(:,1));
        L_power = zeros(length(sum(goodFiles)),floor(SIZE/2));
        M_power = zeros(length(sum(goodFiles)),floor(SIZE/2));
        S_power = zeros(length(sum(goodFiles)),floor(SIZE/2));
        for i=1:stop
            if goodFiles(i) == 1
                j = j+1;
                image = load(char(files(i))); 

                L_raw = image.LMS_Image(:,:,1);
                L_power(j,:) = PowerSpectrum(L_raw(1:SIZE,1:SIZE));
                L_raw = L_raw(:)./100;% change into units R*/10ms

                M_raw = image.LMS_Image(:,:,2);
                M_power(j,:) = PowerSpectrum(M_raw(1:SIZE,1:SIZE));
                M_raw = M_raw(:)./100;

                S_raw = image.LMS_Image(:,:,3);
                S_power(j,:) = PowerSpectrum(S_raw(1:SIZE,1:SIZE));
                S_raw = S_raw(:)./100;
                
                L_count(j,:) = histc(L_raw,BINS); 
                M_count(j,:) = histc(M_raw,BINS);
                S_count(j,:) = histc(S_raw,BINS);
            end
        end
        
        L_analysis = struct('name','L','count',L_count,'power',L_power);
        M_analysis = struct('name','M','count',M_count,'power',M_power);
        S_analysis = struct('name','S','count',S_count,'power',S_power);
        
    case 3
        SIZE = load(char(files(1)));
        SIZE = SIZE.LMS_Image(:,:,1);
        SIZE = length(SIZE(:,1));
        L_power = zeros(length(sum(goodFiles)),floor(SIZE/2));
        M_power = zeros(length(sum(goodFiles)),floor(SIZE/2));
        S_power = zeros(length(sum(goodFiles)),floor(SIZE/2));
        L_corr = zeros(sum(goodFiles),323);
        M_corr = zeros(sum(goodFiles),323);
        S_corr = zeros(sum(goodFiles),323);
        for i=1:stop
            if goodFiles(i) == 1
                j = j+1;
                image = load(char(files(i))); 

                L_raw = image.LMS_Image(:,:,1);
                L_proc = L_raw - mean(mean(L_raw));
                L_power(j,:) = PowerSpectrum(L_proc(1:SIZE,1:SIZE));
                L_corr(j,:) = pxl_corr(L_proc(100:422,100:422));
                L_raw = L_raw(:)./100;% change into units R*/10ms
               
                M_raw = image.LMS_Image(:,:,2);
                M_proc = M_raw - mean(mean(M_raw));
                M_power(j,:) = PowerSpectrum(M_proc(1:SIZE,1:SIZE));
                M_corr(j,:) = pxl_corr(M_proc(100:422,100:422));
                M_raw = M_raw(:)./100;
             
                S_raw = image.LMS_Image(:,:,3);
                S_proc = S_raw - mean(mean(S_raw));
                S_power(j,:) = PowerSpectrum(S_proc(1:SIZE,1:SIZE));
                S_corr(j,:) = pxl_corr(S_proc(100:422,100:422));
                S_raw = S_raw(:)./100;
                
                L_count(j,:) = histc(L_raw,BINS); 
                M_count(j,:) = histc(M_raw,BINS);
                S_count(j,:) = histc(S_raw,BINS);
            end
        end
        
        L_analysis = struct('name','L','count',L_count,'power',L_power,...
            'corr',L_corr);
        M_analysis = struct('name','M','count',M_count,'power',M_power,...
            'corr',M_corr);
        S_analysis = struct('name','S','count',S_count,'power',S_power,...
            'corr',S_corr);
end
end


