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

%% Plots

st = 2017;
start = 210900;
st = st + start;
nsamples = 2000; 
f = st+nsamples;


titles = ["roll [º]","pitch [º]","yaw [º]","gyrX [º/s]","gyrY [º/s]","gyrZ [º/s]"];

figure(1)

ax1 = subplot(3,2,1);
plot(0:0.02:(f-st)/50,roll(st:f))
title(titles(1))
xlabel('Time [s]')

ax2 = subplot(3,2,2);
plot(0:0.02:(f-st)/50,pitch(st:f))
title(titles(2))
xlabel('Time [s]')

ax3 = subplot(3,2,3);
plot(0:0.02:(f-st)/50,yaw(st:f))
title(titles(3))
xlabel('Time [s]')


%dRoll/dt
fs = 50;
fc = 5;
[br2,ar2] = butter(2,fc/(fs/2));

ax4 = subplot(3,2,4);
plot(0:0.02:(f-st)/50-0.02,diff(roll(st:f))/0.02)
hold on
plot(0:0.02:(f-st)/50-0.02,filter(br2,ar2,diff(roll(st:f))/0.02))
hold off
title(titles(4))
legend('Raw','Lowpass')
xlabel('Time [s]')

%dPitch/dt
fs = 50;
fc = 3;
[bp2,ap2] = butter(2,fc/(fs/2));

ax5 = subplot(3,2,5);
plot(0:0.02:(f-st)/50-0.02,diff(pitch(st:f)/0.02))
hold on
plot(0:0.02:(f-st)/50-0.02,filter(bp2,ap2,diff(pitch(st:f)/0.02)))
hold off
title(titles(5))
legend('Raw','Lowpass')
xlabel('Time [s]')


%gyrZ
fs = 50;
fc = 3;
[by2,ay2] = butter(2,fc/(fs/2));

ax6 = subplot(3,2,6);
plot(0:0.02:(f-st)/50-0.02,diff(yaw(st:f))/0.02)
hold on
plot(0:0.02:(f-st)/50-0.02,filter(by2,ay2,diff(yaw(st:f))/0.02))
hold off
title(titles(6))
legend('Raw','Lowpass')
xlabel('Time [s]')

figure(2)
ax7 = plot(0:0.02:(f-st)/50,speed(st-2016:f-2016));
xlabel('Time [s]')
title('Speed')
hold off

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7],'x')

%% Fourrier Transform 

%%dPitch/dt
Fs = 50; %Hz

L = length(roll(st:f));

Y = fft(filter(bp2,ap2,diff(pitch(st:f))/0.02));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure(3)
subplot(2,2,1)
ff = Fs*(0:(L/2))/L;
plot(ff,P1) 

hold on

Y = fft(diff(pitch(st:f))/0.02);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
ff = Fs*(0:(L/2))/L;
plot(ff,P1) 

title('Single-Sided Amplitude Spectrum of dPitch/dt')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Filtered','Raw')
hold off

%%dRoll/dt
Fs = 50; %Hz

L = length(roll(st:f));

Y = fft(filter(br2,ar2,diff(roll(st:f))/0.02));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ff = Fs*(0:(L/2))/L;
subplot(2,2,2)
plot(ff,P1) 

hold on
Y = fft(diff(roll(st:f))/0.02);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ff = Fs*(0:(L/2))/L;
plot(ff,P1) 


title('Single-Sided Amplitude Spectrum of dRoll/dt')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Filtered','Raw')
hold off

%%dYaw/dt
Fs = 50; %Hz

L = length(roll(st:f));

Y = fft(filter(by2,ay2,diff(yaw(st:f))/0.02));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
ff = Fs*(0:(L/2))/L;
subplot(2,2,3)
plot(ff,P1) 
hold on

Y = fft(diff(yaw(st:f))/0.02);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ff = Fs*(0:(L/2))/L;
plot(ff,P1) 

title('Single-Sided Amplitude Spectrum of dYaw/dt')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Filtered','Raw')
hold off



