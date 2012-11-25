clear all; 
% Garrigan et al. information calculations, in the tradition of Snyder et al. 1977

%% Set paramters
Number_Cones = 6; %1-6 cones, larger arrays scale differently
Cone_Spacing = 1; %In Pixels
Compute_Analyses = 1; % 1=R*, 2 = R*, & Power Spec, 3 = R*, PS, & Correlation
% note computing all 3 is very slow.


%% Call images and generate signals:

[L_analysis,M_analysis,S_analysis,BINS] = SignalGen('C:\Data\UPenn_Images\LMS_Images_Raw',...
    'C:\Data\UPenn_Images\AUX_Image_Files',Compute_Analyses);


%% Compute Information:

[LM_array] = ConeInfoFunc(L_analysis,M_analysis,Cone_Spacing);
[LS_array] = ConeInfoFunc(L_analysis,S_analysis,Cone_Spacing);

[LM_array] = ArrayInfoFunc(LM_array);
[LS_array] = ArrayInfoFunc(LS_array);

[LM_array] = OptPercentX(LM_array);
[LS_array] = OptPercentX(LS_array);

%% Plot average signal in R*/10ms for each cone type 

SignalPlots(L_analysis,M_analysis,S_analysis,BINS,Compute_Analyses)


%% Information Plots:

InfoPlots(LM_array,LS_array)