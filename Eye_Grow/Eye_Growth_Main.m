clear all; close all;

% Plot Options:
VideoPlot = 0;

% Free parameters
NumberofNodes = 36;
age = 6; %years old at start.
LengthofTime = 14; % in years.
INTSTEP = 0.01; % in fraction of years. 
Pressure = 0.002; % eye pressure.

K_change = 0.15;
LocationOfLoosen = 1;
LengthofLoosen = 3;


Nodes = EyeGrowthFunc(NumberofNodes,age,LengthofTime,INTSTEP,Pressure,0 ,...
    K_change,LocationOfLoosen,LengthofLoosen,VideoPlot);
close;

MyopiaNodes = EyeGrowthFunc(NumberofNodes,age,LengthofTime,INTSTEP,Pressure,1,...
    K_change,LocationOfLoosen,LengthofLoosen,VideoPlot);
close;

%%
PaperEyeLength = zeros(length(Nodes.ModelEyeLength),1);
AGE = age:INTSTEP:(LengthofTime+(age-INTSTEP));
for i = 1:length(Nodes.ModelEyeLength)
    PaperEyeLength(i) = EyeLength(AGE(i));
end

figure(1); 
FONTSIZE = 20;

plot(AGE,MyopiaNodes.ModelEyeLength, '--b','linewidth',2.5);
hold on;
plot(AGE,Nodes.ModelEyeLength, '-b','linewidth',2.5);
hold on;
plot(AGE,PaperEyeLength,'k','linewidth',2.5);

set(gca,'fontsize',FONTSIZE);
xlabel('age','fontsize',FONTSIZE);
ylabel('axial length','fontsize',FONTSIZE);
xlim([age age+LengthofTime])
box off;
legend('Myopia','Emmetropia','Zadnik et al.','Location','SouthEast'); legend boxoff;

%%
ON = 0;
if ON == 1
figure(2);
FONTSIZE = 20;

plot(AGE,PaperEyeLength,'--k','linewidth',2);

set(gca,'fontsize',FONTSIZE);
xlabel('age','fontsize',FONTSIZE);
ylabel('axial length','fontsize',FONTSIZE);
xlim([age age+LengthofTime])
box off;

B = linspace(0.75,1,NumberofNodes/4);
for i = 1:NumberofNodes/4

    Nodes = EyeGrowthFunc(NumberofNodes,age,LengthofTime,INTSTEP,Pressure,1,...
    K_change,i,2,VideoPlot);

    hold on;
    plot(AGE,Nodes.ModelEyeLength, '-','Color',[0 0 B(i)],'linewidth',2);

end

end











