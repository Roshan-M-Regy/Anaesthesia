%dydt = [dmNadt;dhNadt;dmKdt;dNadt;dATPdt;dxFSdt;dVdt;dmNaFSdt;dhNaFSdt;dmKFSdt;dVFSdt;dxdt;];
clear all
close all 
time = 0:.1:5000;
ini = zeros(14,1);
V = 0;
alphamNa = .32*(V+54)/(1-exp(-(V+54)/4));
betamNa = .28*(V+27)/(exp((V+27)/5)-1);
alphahNa = .128*(-(V+50)/18);
betahNa = 4/(1+exp(-(-V+27)/5));
alphamK = .032*(V+52)/(1-exp(-(V+52)/5));
betamK = .5*(-(V+57)/40)/40;
mNa = alphamNa/(alphamNa+betamNa);
hNa = alphahNa/(alphahNa+betahNa);
mK = alphamK/(betamK+alphamK);
VFS = 0;
alphamNaFS = .32*(VFS+54)/(1-exp(-(VFS+54)/4));
betamNaFS = .28*(VFS+27)/(exp((VFS+27)/5)-1);
alphahNaFS = .128*(-(VFS+50)/18);
betahNaFS = 4/(1+exp(-(-VFS+27)/5));
alphamKFS = .032*(VFS+52)/(1-exp(-(VFS+52)/5));
betamKFS = .5*(-(VFS+57)/40)/40;
mNaFS = alphamNaFS/(betamNaFS+alphamNaFS);
hNaFS = alphahNaFS/(betahNaFS+alphahNaFS);
mKFS = alphamKFS/(betamKFS+alphamKFS);

ini=[mNa;hNa;mK;0;0;0;0;V;mNaFS;hNaFS;mKFS;VFS;0;0];

[t,results]=ode45(@burst_supression,time,ini);
