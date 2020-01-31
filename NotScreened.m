%% Use of the serial interval for non-screening
[~,Ipdf] = IncubationDist(5.2,1);

options=optimset('MaxIter',10^6,'TolFun',10^(-16),'TolX',10^(-16),'display','off');
[gp]=fmincon(@(x)((gaminv(0.025,x(1),5.2./x(1))-4.1).^2+(gaminv(0.975,x(1),5.2./x(1))-7).^2),100,[],[],[],[],0,1000,[],options);
gaminv(0.025,gp,5.2./gp)
gaminv(0.975,gp,5.2./gp)
NS=10^4;
mun=gamrnd(gp,5.2/gp,NS,1);
UIpdf=zeros(NS,length(Ipdf));
for ii=1:NS
    [~,UIpdf(ii,:)] = IncubationDist(mun(ii),0);
end
load('TimetoMedVisituptoDec31.mat','D')
MP=D(:,2)./sum(D(:,2));
load('TimetoMedVisitJan1onward.mat','D')
MPA=D(:,2)./sum(D(:,2));
load('TimetoHospitaluptoDec31.mat','D')
HP=D(:,2)./sum(D(:,2));
load('TimetoHospitalJan1onward.mat','D')
HPA=D(:,2)./sum(D(:,2));
DI=42;
L=zeros(NS,1);
LNS=zeros(NS,1);
LNSA=zeros(NS,1);
LNSH=zeros(NS,1);
LNSHA=zeros(NS,1);
LCT=zeros(NS,36);
tempL=zeros(DI+1,1);
tempNS=zeros(DI+1,DI+1);
tempNSA=zeros(DI+1,DI+1);
tempNSH=zeros(DI+1,DI+1);
tempNSHA=zeros(DI+1,DI+1);
MLECT=zeros(1,36);
for s=0:DI    
   pt=0.005.*ones(s,1);
   tempL(s+1)=Ipdf(s+1).*LikelihoodMissed(pt);
   for ti=0:(length(MP)-1)
        pt=0.005.*ones(s+ti,1);
        tempNS(s+1,ti+1)=Ipdf(s+1).*MP(ti+1).*LikelihoodMissed(pt);
        tempNSA(s+1,ti+1)=Ipdf(s+1).*MPA(ti+1).*LikelihoodMissed(pt);
   end
   for ti=0:(length(HP)-1)
        pt=0.005.*ones(s+ti,1);
        tempNSH(s+1,ti+1)=Ipdf(s+1).*HP(ti+1).*LikelihoodMissed(pt);
        tempNSHA(s+1,ti+1)=Ipdf(s+1).*HPA(ti+1).*LikelihoodMissed(pt);
   end
   for cc=0:35
       pt=0.005.*ones(min([s cc]),1);       
       MLECT(cc+1)=MLECT(cc+1)+Ipdf(s+1).*LikelihoodMissed(pt);   
   end
end

MLE=sum(tempL);
MLENS=sum(tempNS(:));
MLENSA=sum(tempNSA(:));
MLENSH=sum(tempNSH(:));
MLENSHA=sum(tempNSHA(:));


for ii=1:NS
    IP=UIpdf(ii,:);
    for s=0:DI    
       pt=0.005.*ones(s,1);
       tempL(s+1)=IP(s+1).*LikelihoodMissed(pt);       
       for ti=0:(length(MP)-1)
            pt=0.005.*ones(s+ti,1);
            tempNS(s+1,ti+1)=IP(s+1).*MP(ti+1).*LikelihoodMissed(pt);
            tempNSA(s+1,ti+1)=IP(s+1).*MPA(ti+1).*LikelihoodMissed(pt);
       end
       for ti=0:(length(HP)-1)
            pt=0.005.*ones(s+ti,1);
            tempNSH(s+1,ti+1)=IP(s+1).*HP(ti+1).*LikelihoodMissed(pt);
            tempNSHA(s+1,ti+1)=IP(s+1).*HPA(ti+1).*LikelihoodMissed(pt);
       end
        for cc=0:35
            pt=0.005.*ones(min([cc s]),1);
            LCT(ii,cc+1)=LCT(ii,cc+1)+IP(s+1).*LikelihoodMissed(pt); 
        end
    end
    L(ii)=sum(tempL);
    LNS(ii)=sum(tempNS(:));
    LNSA(ii)=sum(tempNSA(:));
    LNSH(ii)=sum(tempNSH(:));
    LNSHA(ii)=sum(tempNSHA(:));
end
save('Missed_Screening_TimetoIsolation.mat','L','LNS','LNSA','LNSH','LNSHA','LCT','MLE','MLENS','MLENSA','MLENSH','MLENSHA','MLECT');
