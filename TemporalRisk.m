%% Calcuates the probability that at least one case has been exported
[IncC,IncW,IncO]=IncidenceData;
load('Missed_Screening_TimetoIsolation.mat','L','MLE','LNSH','MLENSH');
close all;

figure('units','normalized','outerposition',[0 0 1 1]);
I=cumsum(IncC(:,2)+IncW(:,2)+IncO(:,2));

lb=prctile(L,2.5);
ub=prctile(L,97.5);
lP=1-(1-lb).^I;
uP=flip(1-(1-ub).^I);
subplot('Position',[0.065,0.648680167762309,0.283865546218487,0.341162790697676]); 
patch([0:52 52:-1:0],[lP' uP'],'k','LineStyle','none','Facealpha',0.3); hold on
plot([0:52],1-(1-MLE).^I,'k','LineWidth',2);
xlabel('Date','Fontsize',18);
ylabel({'Probability at least','one case exported'},'Fontsize',18);
XTL=datestr(datenum('12-06-2019'):4:(datenum('12-06-2019')+52),'mm-dd-yy');
box off;
set(gca,'LineWidth',2,'tickdir','out','Fontsize',16,'Xtick',[0:4:52],'XTicklabel',XTL,'Xminortick','on','YTick',[0:0.1:1],'Yminortick','on');
xtickangle(45);
xlim([0 52])

lP=1-(1-lb).^(0.2.*I);
uP=flip(1-(1-ub).^(0.2.*I));
patch([0:52 52:-1:0],[lP' uP'],'r','LineStyle','none','Facealpha',0.3); hold on
plot([0:52],1-(1-MLE).^(0.2.*I),'r','LineWidth',2);


lbA=prctile(LNSH,2.5);
ubA=prctile(LNSH,97.5);

lP=1-(1-lbA).^(0.5.*I);
uP=flip(1-(1-ubA).^(0.5.*I));
patch([0:52 52:-1:0],[lP' uP'],'b','LineStyle','none','Facealpha',0.3); hold on
plot([0:52],1-(1-MLENSH).^(0.5.*I),'b','LineWidth',2);

text(0.25,0.95,'Developing symptoms','color','k','Fontsize',16);
text(0.25,0.885,'Superspreader','color','r','Fontsize',16);
text(0.25,0.82,'Asymptomatic infection','color','b','Fontsize',16);





