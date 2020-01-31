options=optimset('MaxIter',10^6,'TolFun',10^(-16),'TolX',10^(-16),'display','off');
[gp]=fmincon(@(x)((gaminv(0.025,x(1),5.2./x(1))-4.1).^2+(gaminv(0.975,x(1),5.2./x(1))-7).^2),100,[],[],[],[],0,1000,[],options);
gaminv(0.025,gp,5.2./gp)
gaminv(0.975,gp,5.2./gp)
NS=10^4;
mun=gamrnd(gp,5.2/gp,NS,1);
UIpdf=zeros(NS,length(Ipdf));
for ii=1:NS
    [,~] = IncubationDist(mun(ii),0);
end



UxT=repmat([min(T):max(T)],NS1,1);
UxTN=repmat([min(T):max(T)],NS1,1);
UxTNS=repmat([min(T):max(T)],NS1,1);
UP=zeros(NS1,1);
UPN=zeros(NS1,1);
UPNS=zeros(NS1,1);
for nn=1:NS1    
    G1=R(nn);
    G2=Pr(nn);
    IP=nbinrnd(G1,G2,NS2,length(T));
    E=repmat(T,NS2,1)-IP; 
    TimeA=zeros(size(E));
    rt=rand(NS2,length(T));
    for ii=1:NS2 
        for jj=1:length(T)
           ff=find(rt(ii,jj)<=CDFP);
           ff=ff(end)-1;
           TimeA(ii,jj)=T(jj)+ff;
        end
    end
    
    PI=zeros(NS2,length(T));
    PIN=zeros(NS2,length(T));
    PINS=zeros(NS2,length(T));
    PINSTr=zeros(NS2,length(T));
    SimC=zeros(NS2,length([min(T):max(T)]));
    
    for ii=1:NS2
        for jj=1:length(T)
            if(E(ii,jj)<=(T(jj)-1)) % Subtract one as T indicates the time of symptoms. Thus for an incubation period of one day [E(ii,jj):(T(jj)-1)] needs to be length 1
                pt=0.005.*TA([E(ii,jj):(T(jj)-1)]-minE+1);
                PI(ii,jj)=LikelihoodMissed(pt);
                pt=0.005.*TAN([E(ii,jj):(T(jj)-1)]-minE+1);
                PIN(ii,jj)=LikelihoodMissed(pt);      
                PINSTr(ii,jj)=LikelihoodMissed(pt); % Used in the temporal examination
                pt=0.005.*TAN([E(ii,jj):min([(TimeA(ii,jj)-1) maxE])]-minE+1);
                PINS(ii,jj)=LikelihoodMissed(pt);
            end
            
            if(T(jj)<TimeA(ii,jj))
                d=length([E(ii,jj):(T(jj)-1)]);
                pt=0.005.*TAN([T(jj):min([(TimeA(ii,jj)-1) maxE])]-minE+1);
                temp=(1-PINSTr(ii,jj)).*pt; % Probability not traveled during symptomatic period time probability of travel each day during syptoms
                for tt=2:length(temp)
                   temp(tt)=temp(tt).*(1-LikelihoodMissed(pt(1:(tt-1))));
                end
                SimC(ii,T(jj):min([(TimeA(ii,jj)-1) maxE]))=SimC(ii,T(jj):min([(TimeA(ii,jj)-1) maxE]))+temp;
            end
        end
    end
    parfor ii=1:length(UxT(nn,:))
       f=find(T==UxT(nn,ii));
       if(~isempty(f))
            UxT(nn,ii)=sum(sum(PI(:,f)))./NS2;
            UxTN(nn,ii)=sum(sum(PIN(:,f)))./NS2;
            UxTNS(nn,ii)=sum(sum(PINSTr(:,f),2)+SimC(:,ii))./NS2;
       else
           UxT(nn,ii)=0; 
           UxTN(nn,ii)=0;
           UxTNS(nn,ii)=sum(SimC(:,ii))./NS2;
       end
    end    
    UP(nn)=mean(sum(PI,2));
    UPN(nn)=mean(sum(PIN,2));
    UPNS(nn)=mean(sum(PINS,2));
end