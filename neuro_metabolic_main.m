clc
clear all


ini = zeros(15,1);
ini(8) = -70;
ini(14) = -70;


t= 0:.02:5500;
[time,results] = ode45(@neuro_metabolic,t,ini);