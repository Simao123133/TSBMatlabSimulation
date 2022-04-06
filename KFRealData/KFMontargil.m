clear
%% Load Data
load('../FlightData/montargil.mat')

pitch = XCDI_EulerAn_58_pitch_00.signals.values;
roll = XCDI_EulerAn_58_roll_01.signals.values;
yaw = XCDI_EulerAn_58_yaw_02.signals.values;
gyrX = XCDI_RateOfT_61_gyrX_00.signals.values*180/pi;
gyrY =XCDI_RateOfT_61_gyrY_01.signals.values*180/pi;
gyrZ = XCDI_RateOfT_61_gyrZ_02.signals.values*180/pi;
time = XCDI_EulerAn_58_roll_01.time;
velX = XCDI_Velocit_64_velX_00.signals.values;
velY = XCDI_Velocit_64_velY_01.signals.values;
velZ = XCDI_Velocit_64_velZ_02.signals.values;
speed = sqrt(velX.^2+velY.^2+velZ.^2);
veltime = XCDI_Velocit_64_velX_00.time;
z = -Foils_US_ang_42_dist_01.signals.values/100;
time_z = Foils_US_ang_42_dist_01.time;
%% Plots
start = 210900;
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

ax1 = subplot(2,2,1);
plot(time(stg:fg),filter(bp2,ap2,diff(pitch(stg:fg+1)/0.02)));
title('dPitch/dt [º/s]')
xlabel('Time [s]')

ax2 = subplot(2,2,2);
plot(time_z(stz:fz),z(stz:fz));
title('z [m]')
xlabel('Time [s]')

ax3 = subplot(2,2,3);
plot(veltime(start:finish),velZ(start:finish));
title('dz/dt [m]')
xlabel('Time [s]')

ax4 = subplot(2,2,4);
plot(veltime(start:finish),speed(start:finish));
xlabel('Time [s]')
title('Speed [m/s]')
hold off

timesimu = 0:0.02:length(velZ(start:finish))/50-0.02;
timesimuz = 0:0.1:length(z(stz:fz))/10-0.1;


dPitchdt = [timesimu' filter(bp2,ap2,diff(pitch(stg:fg+1)/0.02))];
zsimu = [timesimuz' z(stz:fz)];
j = stz;
zsamp = zeros(length(roll(stg:fg)),1);
for i=1:length(roll(stg:fg))
   zsamp(i) = z(j);
   if rem(i-1,5) == 0 && i ~= 1
       j = j+1;
   end
end
zsimucorr = [timesimu' zsamp.*cosd(pitch(stg:fg)).*cosd(roll(stg:fg))];
dZdt = [timesimu' velZ(start:finish)];

linkaxes([ax1,ax2,ax3,ax4],'x')

%sys = ss(0,1,1,0);
%sys_d = c2d(sys,0.02);

figure(2)
plot(out.tout,out.zKF.Data)
%plot(zsimucorr(1:501,1), zsimucorr(1:501,2))
hold on
plot(out.tout,zsimucorr(1:length(out.tout),2))
%plot(zsimu(1:101,1),zsimu(1:101,2))
hold off
legend('zKF','zUS')


