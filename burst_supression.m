function dydt = burst_supression(time,ini)
%dydt = [dmNadt;dhNadt;dmKdt;dNadt;dATPdt;dxFSdt;dVdt;dmNaFSdt;dhNaFSdt;dmKFSdt;dVFSdt;dxdt;];
mNa = ini(1);
hNa = ini(2);
V = ini(8);
mK = ini(3);
Na = ini(4);
ATP = ini(5);
xAMPAFS = ini(6);
xGABAFS = ini(7);
mNaFS = ini(9);
hNaFS = ini(10);
mKFS = ini(11);
VFS = ini(12);
xAMPAPY = ini(13);
xGABAPY = ini(14);


Pyramidal Cell 
 Sodium current Pyramidal Cell 
gNa = 50;
ENa = 100;

INa = gNa*(mNa^3)*hNa*(V-ENa);
alphamNa = .32*(V+54)/(1-exp(-(V+54)/4));
betamNa = .28*(V+27)/(exp((V+27)/5)-1);
alphahNa = .128*exp(-(V+50)/18);
betahNa = 4/(1+exp(-(V+27)/5));

% Pottasium Current Pyramidal Cell 
gK = 80;
EK = -100;
IK = gK*(mK^4)*(V-EK);
alphamK = .032*(V+52)/(1-exp(-(V+52)/5));
betamK = .5*exp(-(V+57)/40);

% Leak current Pyramidal Cell  
Il = 0.1*(V+61);

% ATP current Pyramidal Cell 
gKATP = .15; % From PNAS-2006-Cunningham-5597-601
F = 8.8*(10^-5);
Km = 6*(10^-8);
z = 1/(1+(ATP/.06));% 10*ATP in actual paper 
IKATP = gKATP*z*(V-EK);

JATP = 8*(10^-4)*.5;% 2 in kopell paper, 8*(10^-4) in reference 
ATPmax = 2; % from reference, not mentioned in the paper
% Applied Current Pyramidal Cell
Iapp = 1.8 + normrnd(0,0.1);

% Synaptic Current into Pyramidal Cell 
gAMPAFS = 2;
IAMPAFS = gAMPAFS*xAMPAFS*(V);
gGABAFS = 1;
IGABAFS = gGABAFS*xGABAFS*(V+80);



% Differential equations for Pyramidal Cell 
dmNadt = alphamNa*(1-mNa)-betamNa*mNa;
dhNadt = alphahNa*(1-hNa)-betahNa*hNa;
dmKdt = alphamK*(1-mK)-betamK*mK;
dNadt = F*INa - 3*Km*(Na^3)*ATP;
dATPdt = JATP*(ATPmax - ATP)-Km*(Na^3)*ATP;
dxAMPAFSdt = 5*(1+tanh(V/4))*(1-xAMPAFS)-xAMPAFS/2;
dxGABAFSdt = 2*(1+tanh(V/4))*(1-xGABAFS)-xGABAFS/5;

dVdt = Iapp - INa - IK - IKATP - Il-IGABAFS-IAMPAFS;
%%
%% FS cell 

% Sodium Current FS cell  

gNa = 50;
ENa = 100;

INaFS = gNa*(mNaFS^3)*hNaFS*(VFS-ENa);
alphamNaFS = .32*(VFS+54)/(1-exp(-(VFS+54)/4));
betamNaFS = .28*(VFS+27)/(exp((VFS+27)/5)-1);
alphahNaFS = .128*exp(-(VFS+50)/18);
betahNaFS = 4/(1+exp(-(VFS+27)/5));


% Pottasium current FS Cell

gK = 80;
EK = -100;
IKFS = gK*(mKFS^4)*(VFS-EK);
alphamKFS = .032*(VFS+52)/(1-exp(-(VFS+52)/5));
betamKFS = .5*exp(-(VFS+57)/40);


% Leak Current FS Cell 

IlFS = 0.1*(VFS+61);

% Applied Current FS Cell 

IappFS = .5 + normrnd(0,.1);

% Synaptic Currents entering FS cell 
gAMPAPY = 0.1;
IAMPAPY = gAMPAPY*xAMPAPY*(VFS);
gGABAPY = .64;
IGABAPY = gGABAPY*xGABAPY*(VFS+80);
% Differential equations for FS cell 

dmNaFSdt = alphamNaFS*(1-mNaFS)-betamNaFS*mNaFS;
dhNaFSdt = alphahNaFS*(1-hNaFS)-betahNaFS*hNaFS;
dmKFSdt = alphamKFS*(1-mKFS)-betamKFS*mKFS;
dVFSdt = IappFS - INaFS - IKFS - IlFS-IAMPAPY-IGABAPY; 
dxAMPAPYdt = 5*(1+tanh(V/4))*(1-xAMPAPY)-xAMPAPY/2;
dxGABAPYdt = 2*(1+tanh(V/4))*(1-xGABAPY)-xGABAPY/5;


dydt = [dmNadt;dhNadt;dmKdt;dNadt;dATPdt;dxAMPAFSdt;dxGABAFSdt;dVdt;dmNaFSdt;dhNaFSdt;dmKFSdt;dVFSdt;dxAMPAPYdt;dxGABAPYdt];

