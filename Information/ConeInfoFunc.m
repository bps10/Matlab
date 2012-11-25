function [XY_array] = ConeInfoFunc(X_analysis,Y_analysis,Cone_Spacing,...
    Number_Cones)
% function [XY_array] = ConeInfoFunc(X_analysis,Y_analysis,Cone_Spacing,...
%                                        Number_Cones)
% 
% Using the equations from Garrigan et al. for small arrays
% Computes: Info = Info_X + Info_Y - Info_XY  
%
% Input
% -----
% X_analysis: structure containing X_analysis files.
% Y_analysis: structure containing Y_analysis files.
% Number_Cones: number of cones in the array.
% Cones_Spacing: distance in pixels between cones in the array.
% Number_X: number of X type cones in the array.
%
%
% Output
% ------
% XY_array: outputs a structure with Information data and metadata.
%
%
% Options
% -------
% None right now.  Eventually want to derive Scale_Factor from newly
% collected data.
%
%
% Notes
% -----
% Called by ComputeInformation.m

%%
if nargin < 4
    Number_Cones = 6;
end
Num = 0:Number_Cones; % number of X cones in array.


% small 6 pixel arrays:
I_XY = zeros(length(X_analysis.count(:,1)),7);
Mutual_XY = zeros(1,7);

X_count = X_analysis.count;
Y_count = Y_analysis.count;
    
for i=1:7
    Number_X = Num(i);

    %% Set up scaling params

    Number_Y = Number_Cones-Number_X;

    Scale_Factor = [0.75 0.84 0.86 0.87 0.88 0.89 0.90 0.91]; % from Garrigan et al.

    Distance_X = sqrt(Number_Cones*Cone_Spacing/(Number_X));
    Distance_Y = sqrt(Number_Cones*Cone_Spacing/(Number_Y));

    % find distance with linear interpolation:
    if Number_X ~= 0
        if Distance_X - round(Distance_X) == 0;
            Delta_X = Scale_Factor(Distance_X);
        else 
            Delta_X = (((Distance_X - round(Distance_X))* ...
            (Scale_Factor(ceil(Distance_X)) - Scale_Factor(floor(Distance_X)))) + ...
            Scale_Factor(floor(Distance_X)));
        end
    end

    if Number_Y ~= 0
        if Distance_Y - round(Distance_Y) == 0;	
            Delta_Y = Scale_Factor(Distance_Y);
        else
            Delta_Y = (((Distance_Y - round(Distance_Y))* ...
            (Scale_Factor(ceil(Distance_Y)) - Scale_Factor(floor(Distance_Y)))) + ...
            Scale_Factor(floor(Distance_Y)));
        end
    end
    %% Information calculations:

    % compute the variance and information for each image serially
    Info_X = zeros(length(X_count(:,1)),1);
    Info_Y = zeros(length(Y_count(:,1)),1);

    for j=1:length(X_count(:,1))

       % Information in each array:
        if Number_X ~= 0
            signal_X = var(X_count(j,:));
            noise_X = mean(X_count(j,:));

            Info_X(j) = (0.5*(log2(1 + signal_X/noise_X)))*(Number_X)^Delta_X;
        elseif Number_X == 0
            Info_X(j) = 0;
        end

        if Number_Y ~= 0
            signal_Y = var(Y_count(j,:));
            noise_Y = mean(Y_count(j,:));

        Info_Y(j) = (0.5*(log2(1 + signal_Y/noise_Y)))*(Number_Y)^Delta_Y;
        elseif Number_Y == 0 
            Info_Y(j) = 0;
        end
    end

    % Setup for probability calculations
    if Number_X && Number_Y ~= 0
        n = 16;
        Pbins = linspace(min(min(Info_X),min(Info_Y)),max(max(Info_X),max(Info_Y)),n);
        xr = interp1(Pbins, 0.5:numel(Pbins)-0.5, Info_X, 'nearest');
        yr = interp1(Pbins, 0.5:numel(Pbins)-0.5, Info_Y, 'nearest');

        % Calculate joint distribution:
        JointProb = accumarray([yr xr] + 0.5, 1, [n n]); % count
        JointProb = (JointProb+1)./sum(sum(JointProb+1)); % prob distribution

        %Calculate marginal distribtions:
        Marg_X = sum(JointProb,2);
        Marg_Y = sum(JointProb,1);

        %Calculate mutual info between arrays:
        Info_XY = 0;
        for k=1:length(Marg_X)
            for l=1:length(Marg_Y)
            Info_XY = Info_XY + (JointProb(k,l).*log2(Marg_X(k)*Marg_Y(l)/JointProb(k,l)));
            end
        end
        Info_XY = -Info_XY;

        %Calculate info in the array:
        Info = Info_X + Info_Y - Info_XY;
    elseif Number_X == 0
        Info = Info_Y;
        Info_XY = 0;
    elseif Number_Y == 0
        Info = Info_X;
        Info_XY = 0;
    end
    
    I_XY(:,i) = Info;
    Mutual_XY(i) = Info_XY;
    
XY_array = struct('Info_XY',I_XY,'Mutual_XY',Mutual_XY,'P_ratio_XY',[],...
    'Numerator_XY',[],'Array_Info_XY',[],'Num',Num,'X_name',X_analysis.name,...
    'Y_name',Y_analysis.name);

end
