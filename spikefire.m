function [firings]=spikefire(Wts,sp,nAfferents,ptnTime)
tau1 = 12;
tau2=tau1/4;
dt = tau1/100;
tau_m = 28;   
Rm = 1;       
Vr = 0;          
Vthr = 0.3;   
sp(sp<0) = 0;
Ins = 0;                             
spkPtn=[sp' (1:nAfferents)']; 

firings = [];     
%----- reset states --------
Sc1 = exp(-dt/tau1);
Sc2 = exp(-dt/tau2);
V0 = 1/max(exp(-(0:dt:5*tau1)/tau1)-exp(-(0:dt:5*tau1)/tau2)); 
K1 = zeros(size(Wts));
K2 = zeros(size(Wts));
PSC = K1-K2;   
Vm = 0.5*Vthr;
for t=dt:dt:ptnTime
    %--- caculate current states ---                        
    Isyn = Wts'*PSC;                              
    Vm = Vm + (dt/tau_m)*(Vr-Vm + Rm*(Ins+Isyn));
    SpkTimesIdx = abs(spkPtn(:,1)-t)<0.1*dt;     
    SpkAfrnt = spkPtn(SpkTimesIdx,2);              
    if ~isempty(SpkAfrnt)
        K1(SpkAfrnt) = K1(SpkAfrnt) + V0;
        K2(SpkAfrnt) = K2(SpkAfrnt) + V0;
    end
    PSC = K1-K2;
    if Vm>Vthr 
        Vm = Vr; 
        firings = [firings t]; 
    end  
    
    K1 = Sc1*K1;
    K2 = Sc2*K2;
end
if  isempty(firings)
    firings=0;
end

