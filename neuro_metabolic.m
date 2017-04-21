function dydt = neuro_metabolic(time,ini)
mna = ini(1);

hna = ini(2);
mk = ini(3);
na = ini(4);
atp = ini(5);
xgabaint = ini(6);
xampaint = ini(7);
Vpyr = ini(8);
mnaint = ini(9);
hnaint = ini(10);
mkint = ini(11);
xgabapyr = ini(12);
xampapyr = ini(13);
Vint = ini(14);
mlts = ini(15);
a = 0.999;


%% Pyramidal Cell 
% Sodium current 
alphamna = .32*(Vpyr + 54)/(1-exp(-(Vpyr+54)/4));
betamna = .28*(Vpyr+ 27)/(exp((Vpyr+27)/5)-1);

alphahna = .128*exp((-(Vpyr+50)/18));
betahna = 4/(1+exp(-(Vpyr+27)/5));

dmnadt =  alphamna*(1-mna)-betamna*(mna);
dhnadt = alphahna*(1-hna)-betahna*hna;

gna = 50;
Ena = 100;
Ina = gna*(mna^3)*hna*(Vpyr - Ena);


% Potassium current
alphamk = .032*(Vpyr + 52)/(1-exp(-(Vpyr + 52)/5));
betamk = .5*exp(((-(Vpyr+57)/40)));
gk = 80;
Ek = -100;

Ik = gk*mk^4*(Vpyr-Ek);

dmkdt = alphamk*(1-mk)-betamk*mk;

%Leak current
Il = 0.1*(Vpyr + 67);

%ATP current 
z = 1/(1+10*atp);
f = 8.8*10^-5;
Km = 6*10^-8;
jatp = 3*.5;% jatp = 8*10^-4
atpmax = 2;
gkatp = .15;
Ikatp = gkatp*z*(Vpyr + 100);

dnadt = f*Ina- 3*Km*na^3*atp;
datpdt = jatp*(atpmax - atp)-Km*na^3*atp;

%applied current



%applied current
Iapppyr = 1.8+normrnd(0,0.1);

% synaptic current 
Igabaint = 3*1*xgabaint*(Vint + 80);
%Iampaint = 2*xampaint*(Vint);
Isynpyr = Igabaint; 
%Iampaint;
%dxgabaintdt = 2*(1+tanh(Vint/4))*(1-xgabaint)-xgabaint/20%5;
dxampaintdt = 5*(1+tanh(Vint/4))*(1-xampaint)-xampaint/2;

Imembint = Ina + Ik + Il + (1-a)*Ikatp;

dvpyrdt = -Imembint - Isynpyr + Iapppyr;


%% Interneuron


% Sodium current 
alphamnaint = .32*(Vint + 54)/(1-exp(-(Vint+54)/4));
betamnaint = .28*(Vint + 27)/(exp((Vint+27)/5)-1);

alphahnaint = .128*exp((-(Vint+50)/18));
betahnaint = 4/(1+exp(-(Vint+27)/5));

dmnaintdt =  alphamnaint*(1-mnaint)-betamnaint*(mnaint);
dhnaintdt = alphahnaint*(1-hnaint)-betahnaint*hnaint;
gna = 50;
Ena = 100;

Inaint = gna*(mnaint^3)*hnaint*(Vint - Ena);

% Potassium current
alphamkint = .032*(Vint + 52)/(1-exp(-(Vint + 52)/5));
betamkint = .5*exp((-(Vint+57)/40));
gk = 80;
Ek = -100;

Ikint = gk*mkint^4*(Vint-Ek);

dmkintdt = alphamkint*(1-mkint)-betamkint*mkint;

%M current
gmlts = 4;%%% the paper has gmlts as 2 
EMlts = -100;

IMlts = gmlts*mlts*(Vint-EMlts);
alpha_m_lts = .0001*3.209*(Vint+30)/(1-exp(-(Vint+30)/9));
beta_m_lts = -0.0001*3.209*(Vint+30)/(1-exp((Vint+30)/9));

%Leak current
Ilint = 0.1*(Vint + 67);

% synaptic current 
Igabapyr =  3*.64*xgabapyr*(Vpyr + 80);%.64
%Iampapyr = .1*xampapyr*(Vpyr);
Isynint = Igabapyr + Iampapyr;

dxgabapyrdt = 2*(1+tanh(Vpyr/4))*(1-xgabapyr)-xgabapyr/20%5;
%dxampapyrdt = 5*(1+tanh(Vpyr/4))*(1-xampapyr)-xampapyr/2;

%applied current
Iappint = .5 + normrnd(0,.1);

 Imembint= Inaint + Ikint + Ilint+a*IMlts;
 dvintdt = -Imembint - Isynint + Iappint;
 dmltsdt = alpha_m_lts*(1-mlts)-beta_m_lts*(mlts);
 
 dydt = [ dmnadt;dhnadt;dmkdt;dnadt;datpdt;dxampaintdt;dvpyrdt;dmnaintdt;dhnaintdt;dmkintdt;dxgabapyrdt;dxampapyrdt;dvintdt;dmltsdt];
%  dydt = [ dmnadt;dhnadt;dmkdt;dnadt;datpdt;dxgabaintdt;dxampaintdt;dvpyrdt;dmnaintdt;dhnaintdt;dmkintdt;dxgabapyrdt;dxampapyrdt;dvintdt;dmltsdt];

