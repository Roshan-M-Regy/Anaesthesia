function dydt = pknmm(time,ini)
C1 = ini(1);
C2 = ini(2);
C3 = ini(3);
Ceff = ini(4);
g = ini(5);
weight = ini(6);
height= ini(7);
age = ini(8);

% concentration variance equations 
if g==2
    
    lbm = 1.1*(weight) - 128*(weight/height)^2;
else
    lbm = 1.07*weight - 148*(weight/height)^2;
end
V1 = 4.27;
V2 = 18.9-.391*(age-53);
V3 = 238;
C11 = 1.89 + .0456*(weight - 77) - .0681*(lbm - 59) + 0.0264*(height - 177);
C12 = 1.29 - .024*(age-53);
C13 = .836;
k10 = C11/V1;
k12 = C12/V1;
k13 = C13/V1;
k21 = C12/V2;
k31 = C13/V3;


dc1dt = -(k10+k12+k13)*C1 + k21*(V2/V1)*C2 + k31*(V3/V1)*C3 + (1/V1)*u;
dc2dt = k12*(V1/V2)*C1 - k21*C2;
dc3dt = k13*(V1/V3)*C1 - k31*C3;
dceffdt = ke0*(C1 - Ceff);



dydt = [ dc1dt;dc2dt;dc3dt;dceffdt];
