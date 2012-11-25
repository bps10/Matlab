clear all;
%%
DIRECTORY = '.\Images\Extra_LMS_Images\sequence, scale\cd05B';

files = getAllFiles(DIRECTORY);

%% add aux check for bad files:
%AUX_Files = getAllFiles(AUX_DIRECTORY);
%goodFiles = zeros(length(AUX_Files),1);
%for i=1:length(AUX_Files)
%    AUX_File = load(char(AUX_Files(i)));
%    if isempty(AUX_File.Image.warning)
%        goodFiles(i) = 1;
%    else 
%        goodFiles(i) = 0;
%    end
%end

%%
corL = zeros(length(files),257);
corM = zeros(length(files),257);
corS = zeros(length(files),257);

for i = 1:length(files)
    
    image =load(char(files(i)));
    
    SIZ = size(image.LMS_Image(:,:,1));
    SIZ = min(SIZ); CUT = floor(SIZ*0.75);
    
    L = image.LMS_Image(1:CUT,1:CUT,1);
    M = image.LMS_Image(1:CUT,1:CUT,2);
    S = image.LMS_Image(1:CUT,1:CUT,3);
    
    corL(i,:) = pxl_corr( L(100:356,100:356) - mean(mean(L)));
    corM(i,:) = pxl_corr( M(100:356,100:356) - mean(mean(M)));
    corS(i,:) = pxl_corr( S(100:356,100:356) - mean(mean(S)));
    

end
%% Plot
hFig = figure(1);
set(hFig, 'Position', [1.25 2.5 800.0 1100.0])
FONT = 18;

for i = 1:length(files)
    hold on;
    h = subplot(3,1,1);

    semilogx(corL(i,:), '.', 'Color',[i/length(files) 0 0],...
        'MarkerSize',10);
    xlim([1 300])
    ylim([-0.1 1.01])
    box off;
    set(gca, 'Fontsize',FONT,'XTickLabel', ' ');
    ylabel('correlation','FontSize',FONT)
    
    hold on;
    h = subplot(3,1,2);
    semilogx(corM(i,:), '.', 'Color',[0 i/length(files) 0],...
        'MarkerSize',10);
    xlim([1 300])
    ylim([-0.1 1.01])
    box off;
    set(gca, 'Fontsize',FONT,'XTickLabel', ' ');
    ylabel('correlation','FontSize',FONT)
    
    hold on;
    h = subplot(3,1,3);
    semilogx(corS(i,:), '.', 'Color',[0 0 i/length(files)],...
        'MarkerSize',10);
    xlim([1 300])
    ylim([-0.1 1.01])
    box off;
    set(gca, 'Fontsize',FONT);
    ylabel('correlation','FontSize',FONT)
    xlabel('distance (pixels)','FontSize',FONT)
end