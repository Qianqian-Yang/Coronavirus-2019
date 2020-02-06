clc;
clear;
%% Probabaility of Travel
load('Probability_Travel_Infection.mat')
fprintf('============================================================ \n');
fprintf('Probability of travel \n');
fprintf('============================================================ \n');
w=exp(F)./sum(exp(F));
wc=cumsum(w);
r=rand(10^4,1);
spc=zeros(10^4,1);
for ii=1:10^4
f=find(r(ii)<=wc);
f=f(1);
spc(ii)=pc(f);
end
fprintf('Probability of travel: %5.4f (95%% CI %5.4f - %5.4f0) \n',[pc(F==max(F)) prctile(spc,[2.5 97.5])]);
clear;
%% Probability travel periods
fprintf('============================================================ \n');
fprintf('General estimates \n');
fprintf('============================================================ \n');
load('TravelDuringInfection.mat')
fprintf('Probability of travel during incubation: %2.1f%% (95%% CI %2.1f%% - %2.1f%%) \n',100.*[MLE prctile(L,[2.5 97.5])]);
fprintf('Probability of travel during incubation and time to medical vist (before Jan 1): %2.1f%% (95%% CI %2.1f%% - %2.1f%%) \n',100.*[MLENS prctile(LNS,[2.5 97.5])]);
fprintf('Probability of travel during incubation and time to medical vist (after Jan 1): %2.1f%% (95%% CI %2.1f%% - %2.1f%%) \n',100.*[MLENSA prctile(LNSA,[2.5 97.5])]);
fprintf('Probability of travel during incubation and time to hospital vist (before Jan 1): %2.1f%% (95%% CI %2.1f%% - %2.1f%%) \n',100.*[MLENSH prctile(LNSH,[2.5 97.5])]);
fprintf('Probability of travel during incubation and time to hospital vist (after Jan 1): %2.1f%% (95%% CI %2.1f%% - %2.1f%%) \n',100.*[MLENSHA prctile(LNSHA,[2.5 97.5])]);
clear;
%% Temporal
fprintf('============================================================ \n');
fprintf('Epidemic \n');
fprintf('============================================================ \n');
startDateofSim = datenum('12-06-2019');% Start date
load('Daily_Prob_Expect.mat');
Temp=sum(UMLExTS,2);
Temp2=sum(UMLExTNS,2);
fprintf('Percentage of exported travel during incubation period (Travel Ban): %3.1f%% (95%% CI %3.1f%% - %3.1f%%) \n', round(100.*[sum(MLExTS)./sum(MLExTNS) prctile(Temp./Temp2,[2.5 97.5])],1));
Temp=sum(UMLExS,2);
Temp2=sum(UMLExNS,2);
fprintf('Percentage of exported travel during incubation period (No Travel Ban): %3.1f%% (95%% CI %3.1f%% - %3.1f%%) \n', round(100.*[sum(MLExS)./sum(MLExNS) prctile(Temp./Temp2,[2.5 97.5])],1));
Temp2=(sum(UMLExTNS,2));
fprintf('Cases exported (Travel Ban): %d (95%% CI %d - %d) \n', [round(sum(MLExTNS)) round(prctile(Temp2,[2.5 97.5]))]);
Temp2=(sum(UMLExNS,2));
fprintf('Cases exported (No travel Ban): %d (95%% CI %d - %d) \n', [round(sum(MLExNS)) round(prctile(Temp2,[2.5 97.5]))]);
Temp=round(sum(UMLExTNS,2));
Temp2=round(sum(UMLExNS,2));
fprintf('Cases averterd through travel ban: %d (95%% CI %d - %d) \n', [round(sum(MLExNS))-round(sum(MLExTNS)) round(prctile(Temp2-Temp,[2.5 97.5]))]);
Temp=round(sum(UMLExTS,2));
Temp2=round(sum(UMLExTNS,2));
fprintf('Cases averted through screening (Travel Ban): %d (95%% CI %d - %d) \n', [round(sum(MLExTNS))-round(sum(MLExTS)) prctile(Temp2-Temp,[2.5 97.5])]);
Temp=round(sum(UMLExS,2));
Temp2=round(sum(UMLExNS,2));
fprintf('Cases averted through screening (No travel Ban): %d (95%% CI %d - %d) \n', [round(sum(MLExNS))-round(sum(MLExS)) prctile(Temp2-Temp,[2.5 97.5])]);
tt=[minE:maxE];
f=find(MPTNS>0.95,1);
lb=prctile(UMPTNS,2.5);
ub=prctile(UMPTNS,97.5);
flb=find(lb>0.95,1);
fub=find(ub>0.95,1);
fprintf(['Daily probability freater than 95%%:' [datestr([startDateofSim+(tt(f)-1)],'mmm-dd-yy') ] '(' [[datestr([startDateofSim+(tt(fub)-1)],'mmm-dd-yy') ] ' to ' [datestr([startDateofSim+(tt(flb)-1)],'mmm-dd-yy') ] ') \n' ]]);

PP=MCPTNS(2:end)-MCPTNS(1:end-1);
T=[(minE+1):maxE]*PP';
V=sqrt([(minE+1):maxE].^2*PP'-T^2);
PPU=UMCPTNS(:,2:end)-UMCPTNS(:,1:end-1);
TU=[(minE+1):maxE]*PPU';
VU=sqrt([(minE+1):maxE].^2*PPU'-TU.^2);
fprintf(['Expected date of first exportation:' datestr(startDateofSim+(T-1),'yyyy-mm-dd') '(95%% CI ' datestr(startDateofSim+(prctile(TU,2.5)-1),'yyyy-mm-dd') ' to ' datestr(startDateofSim+(prctile(TU,97.5)-1),'yyyy-mm-dd') ') +/- %2.1f (95%% CI %2.1f - %2.1f) \n'],[V prctile(VU,[2.5 97.5])])

f=find(PP==max(PP));

lb=prctile(PPU,2.5);
ub=prctile(PPU,97.5);
flb=find(lb==max(lb),1);
fub=find(ub==max(ub),1);
fprintf(['Max. Likelihood date of first exportation:' [datestr([startDateofSim+(tt(f)-1)],'mmm-dd-yy') ] '(' [[datestr([startDateofSim+(tt(flb)-1)],'mmm-dd-yy') ] ' to ' [datestr([startDateofSim+(tt(fub)-1)],'mmm-dd-yy') ] ') \n' ]]);

NI=sum(IncC(:,2)+IncW(:,2)+IncH(:,2)+IncO(:,2));
Temp2=sum(UMLExTNS,2);
fprintf('Percentage of all infections travel over infectious period (Travel Ban): %3.1f%% (95%% CI %3.1f%% - %3.1f%%) \n', round(100.*[sum(MLExTNS)./NI prctile(Temp2./NI,[2.5 97.5])],1));
Temp2=sum(UMLExNS,2);
fprintf('Percentage of all infections travel during incubation period (No Travel Ban): %3.1f%% (95%% CI %3.1f%% - %3.1f%%) \n', round(100.*[sum(MLExNS)./NI prctile(Temp2./NI,[2.5 97.5])],1));
Temp2=sum(UMLExTS,2);
fprintf('Percentage of all infections travel over incubation period (Travel Ban): %3.1f%% (95%% CI %3.1f%% - %3.1f%%) \n', round(100.*[sum(MLExTS)./NI prctile(Temp2./NI,[2.5 97.5])],1));
Temp2=sum(UMLExS,2);
fprintf('Percentage of all infections travel during incubation period (No Travel Ban): %3.1f%% (95%% CI %3.1f%% - %3.1f%%) \n', round(100.*[sum(MLExS)./NI prctile(Temp2./NI,[2.5 97.5])],1));
clear;
%% Interventions
fprintf('============================================================ \n');
fprintf('Interventions \n');
fprintf('============================================================ \n');
load('Time_Screening.mat');
fprintf('Percentage of incubating cases missed with health quationare (14 Days): %3.2f %% (95%% CI  %3.2f %% - %3.2f %% ) \n',100.*[1-MLET(14) 1-prctile(UMLET(:,14),[97.5 2.5])]);
D=spline(MLET,[1:14],0.95);
DL=spline(prctile(UMLET,[2.5]),[1:14],0.95);
DU=spline(prctile(UMLET,[97.5]),[1:14],0.95);
fprintf('Days to attain 95%%: %2.1f  (95%% CI  %2.1f  - %2.1f  ) \n',[D DU DL]);
clear;
load('TravelDuringInfection.mat','MLECT','LCT','MLE','L');
pr=(MLE-MLECT(6))./MLE; % Use index 6 as the contact tracing started at zero
temp=(L-LCT(:,6))./L; % Use index 6 as the contact tracing started at zero
fprintf('Percentage reduction if isolated at five days: %3.1f %% (95%% CI  %3.1f %% - %3.1f %% ) \n',100.*[pr prctile(temp,[2.5 97.5])]);
clear;
load('Time_After_Arrival.mat');
fprintf('Average time from arrrival to symptom onset: %2.1f (95%% CI %2.1f - %2.1f) \n',[MLET prctile(UMLET,[2.5 97.5])]);
fprintf('Average time from symptom onset to first infection event: %2.1f (95%% CI %2.1f - %2.1f) \n',[MLE prctile(UMLE,[2.5 97.5])]);
fprintf('Average time from arrrival to first infection event: %2.1f (95%% CI %2.1f - %2.1f) \n',[MLE+MLET prctile(TtoT,[2.5 97.5])]);
clear;
load('ArrivalToSymptomOnset.mat')
n=length(ATtoSO(ATtoSO>0));
mue=mean(ATtoSO(ATtoSO>0));
strd=std(ATtoSO(ATtoSO>0));
fprintf('Average time from arrrival to symptom onset (Emperical): Mean = %2.1f, Stand. Dev.=%2.1f (N=%d) \n',[mue strd n]);
clear;

clear;
