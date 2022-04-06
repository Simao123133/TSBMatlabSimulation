clc;
close all;
clear;

simulation_time=20; %seconds
step_time=1; %seconds
p_req=3000; %Watts
K_i=0;
K_p=10;
K_d=0;
n_cells=40;

sim('Sim_control_FC');

figure();
plot(ans.p_true.time,ans.p_true.signals.values)

open_system('Sim_control_FC/Scope1')
open_system('Sim_control_FC/Scope2')
