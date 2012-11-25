function dist = KL_Diverg(P,Q,BIN_RESOLUTION, INDEPENDENCE_TEST)
% dist = KLDiv(P,Q) 
% 
% Kullback-Leibler divergence of two discrete variables
% 
% Input
% -----
% P: Sample data in form; n x nbins
% Q: Model data in form; 1 x nbins or n x nbins(one to one)
%
% Output
% ------
% dist: KL_Divergence distance in form; n x 1
%
% Options
% -------
% BIN_RESOLUTION: number of bins used in histogram. Default = 20.
% INDEPENDENCE_TEST: if 1 test independence of two variables. Default = 0.
%
%
% Notes
% -----
% P and Q  are histogramed and normalised to have the sum of one on rows
% have the length of one at each.
%
%
% for more general info see: http://www.snl.salk.edu/~shlens/kl.pdf or 
% http://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence

if nargin < 3
    BIN_RESOLUTION = 20;
end

if nargin < 4
    INDEPENDENCE_TEST = 0;
end


if size(P,2)~=size(Q,2)
    error('the number of columns in P and Q should be the same');
end

% histogram data
BINS = linspace(min( min(P),min(Q) ),...
                    max (max(P),max(Q)),BIN_RESOLUTION);
                
P = hist(P,BINS);
Q = hist(Q,BINS);


% avoid divide by zeros
Q = Q + 1;
P = P + 1;

% normalizing the P and Qs    
Q = Q ./repmat(sum(Q,2),[1 size(Q,2)]);
P = P ./repmat(sum(P,2),[1 size(P,2)]);
        
% decide whether computing standard KL-diverg or KL-diverge to assess
% independence of two variable.
switch INDEPENDENCE_TEST
    case 0

        temp =  P.*log2(P./Q); 

        % decide if one or two dimensional case:
        if size(Q,1)==1
            dist = sum(temp,2);
        elseif size(Q,1) ==size(P,1)
            dist = sum(sum(temp));
        end

    case 1 % testing independence

        JointDist = Q'*P;
        MargQ = sum(JointDist,1);
        MargP = sum(JointDist,2);
        MargQP = MargP*MargQ;
        
        temp = JointDist.*log2(JointDist./MargQP);
        dist = sum(sum(temp));
end


 
        
