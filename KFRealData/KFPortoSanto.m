clear
%% Load Data
load('../FlightData/PortoSanto.mat')

pitch = XCDI_EulerAn_74_pitch_00.signals.values;
roll = XCDI_EulerAn_74_roll_01.signals.values;
yaw = XCDI_EulerAn_74_yaw_02.signals.values;
gyrX = XCDI_RateOfT_77_gyrX_00.signals.values*180/pi;
gyrY =XCDI_RateOfT_77_gyrY_01.signals.values*180/pi;
gyrZ = XCDI_RateOfT_77_gyrZ_02.signals.values*180/pi;
time = XCDI_EulerAn_74_roll_01.time;
velX = XCDI_Velocit_80_velX_00.signals.values;
velY = XCDI_Velocit_80_velY_01.signals.values;
velZ = XCDI_Velocit_80_velZ_02.signals.values;
speed = sqrt(velX.^2+velY.^2+velZ.^2);
veltime = XCDI_Velocit_80_velX_00.time;
z = -Foils_US_ang_42_dist_01.signals.values/100;
time_z = Foils_US_ang_42_dist_01.time;

%% Plots
start = 173354;
%start = 172654;
nsamples = 2000; 
finish = start+nsamples;

[~,g_idx] = min(abs(time - veltime(start)));
[~,z_idx] = min(abs(time_z - veltime(start)));
stz = z_idx;
fz = z_idx + nsamples/5;
stg = g_idx;
fg = g_idx + + nsamples;

figure(1)

%dPitch/dt
fs = 50;
fc = 3;
[bp2,ap2] = butter(2,fc/(fs/2));

figure(2);

ax1 = subplot(3,3,1);
plot(time(stg:fg)-time(stg),filter(bp2,ap2,diff(pitch(stg:fg+1)/0.02)));
title('dPitch/dt [º/s]')
xlabel('Time [s]')

ax2 = subplot(3,3,2);
plot(time_z(stz:fz)-time_z(stz),z(stz:fz));
title('z [m]')
xlabel('Time [s]')

ax3 = subplot(3,3,3);
plot(veltime(start:finish)-veltime(start),velZ(start:finish));
title('dz/dt [m]')
xlabel('Time [s]')

ax4 = subplot(3,3,4);
plot(veltime(start:finish)-veltime(start),speed(start:finish));
xlabel('Time [s]')
title('Speed [m/s]')
hold off

ax5 = subplot(3,3,5);
plot(time(stg:fg)-time(stg),pitch(stg:fg));
title('Pitch [º]')
xlabel('Time [s]')

ax6 = subplot(3,3,6);
plot(time(stg:fg)-time(stg),roll(stg:fg));
title('Roll [º]')
xlabel('Time [s]')


timesimu = 0:0.02:length(velZ(start:finish))/50-0.02;
timesimuz = 0:0.1:length(z(stz:fz))/10-0.1;


dPitchdt = round([timesimu' filter(bp2,ap2,diff(pitch(stg:fg+1)/0.02))],4);
zsimu = [timesimuz' z(stz:fz)];
j = stz;
zsamp = zeros(length(roll(stg:fg)),1);
for i=1:length(roll(stg:fg))
   zsamp(i) = z(j);
   if rem(i-1,5) == 0 && i ~= 1
       j = j+1;
   end
end
zsimucorr = round([timesimu' zsamp.*cosd(pitch(stg:fg)).*cosd(roll(stg:fg))],4);
dZdt = round([timesimu' velZ(start:finish)],4);

sys = ss([0 -1;0 0],[1;0],[1 0],zeros(1,1));
sys_d = c2d(sys,0.02);
A = sys_d.A;
B = sys_d.B;
C = sys_d.C;
Q = [0.01 0;0 0.01];
R = 1000;
R_high = 1000;

[m,P,Z,E] = dlqe(sys_d.A,eye(2),sys_d.C,Q,R);



bias_init = 0.01;
out = sim('KF');

ax7 = subplot(3,3,7);
plot(out.tout,out.zKF.Data,out.tout,zsimucorr(1:length(out.tout),2))
legend('zKF','zUS')

ax8 = subplot(3,3,8);
plot(out.tout,out.bias.Data)

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8],'x')