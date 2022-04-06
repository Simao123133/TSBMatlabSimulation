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
sti = st + start;
nsamples = 2000; 

%{
for i=1:1:nsamples
    %dRoll/dt
    st = sti + i - 26;
    f = sti + i - 1;    
    
    Fs = 50;
    L = length(roll(st:f));
    Y = fft(diff(roll(st:f+1))/0.02);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    ff = Fs*(0:(L/2))/L;

    [~,ffi] = min(abs(10-ff));

    [~,ffi2] = min(abs(15-ff));

    [~,imax] = max(P1(ffi:ffi2));
    ffmax = ff(ffi-1+imax);

    ffminr = ffmax - ffmax*0.2;
    ffmaxr = ffmax + ffmax*0.2;

    if ffmaxr > 25
        ffmaxr = 24.9;
    end
    [brn,arn] = butter(2,[ffminr/(Fs/2) ffmaxr/(Fs/2)],'stop');
    fftres = filter(brn,arn,diff(roll(st:f))/0.02);
    rolldif(i) = fftres(end);
    
    %dPitch/dt
    st = sti + i - 26;
    f = sti + i - 1; 
    Fs = 50;
    L = length(roll(st:f));
    Y = fft(diff(pitch(st:f+1))/0.02);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    ff = Fs*(0:(L/2))/L;
    
    [~,ffi] = min(abs(5-ff));

    [~,ffi2] = min(abs(15-ff));

    [~,imax] = max(P1(ffi:ffi2));
    ffmax = ff(ffi-1+imax);

    ffminp = ffmax - ffmax*0.2;
    ffmaxp = ffmax + ffmax*0.2;

    if ffmaxp > 25
        ffmaxp = 24.9;
    end
    [bpn,apn] = butter(2,[ffminp/(Fs/2) ffmaxp/(Fs/2)],'stop');
    fftres = filter(bpn,apn,diff(pitch(st:f))/0.02);
    pitchdif(i) = fftres(end);
    
    %dYaw/dt
    st = sti + i - 26;
     f = sti + i - 1;
    Fs = 50;
    L = length(roll(st:f));
    Y = fft(diff(yaw(st:f+1))/0.02);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    ff = Fs*(0:(L/2))/L;
    
    [~,ffi] = min(abs(5-ff));

    [~,ffi2] = min(abs(15-ff));

    [~,imax] = max(P1(ffi:ffi2));
    ffmax = ff(ffi-1+imax);

    ffminy = ffmax - ffmax*0.3;
    ffmaxy = ffmax + ffmax*0.3;

    if ffmaxy > 25
        ffmaxy = 24.9;
    end
    [byn,ayn] = butter(2,[ffminy/(Fs/2) ffmaxy/(Fs/2)],'stop');
    fftres = filter(byn,ayn,diff(yaw(st:f))/0.02);
    yawdif(i) = fftres(end);
     
end
%}
st = sti;
f = sti+nsamples;


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
fc = 15;
[br,ar] = butter(2,fc/(fs/2));
[br2,ar2] = butter(2,8/(fs/2));

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
fc = 8;
[bp,ap] = butter(2,fc/(fs/2));
[bp2,ap2] = butter(2,3/(fs/2));

ax5 = subplot(3,2,5);
plot(0:0.02:(f-st)/50-0.02,diff(pitch(st:f)/0.02))
hold on
%plot(0:0.02:(f-st)/50-0.02,filter(bp,ap,pitchdif))
%hold on
plot(0:0.02:(f-st)/50-0.02,filter(bp2,ap2,diff(pitch(st:f)/0.02)))
hold off
title(titles(5))
legend('Raw','Lowpass')
xlabel('Time [s]')


%gyrZ
fs = 50;
fc = 8;
[by,ay] = butter(2,fc/(fs/2));
[by2,ay2] = butter(2,3/(fs/2));

ax6 = subplot(3,2,6);
plot(0:0.02:(f-st)/50-0.02,diff(yaw(st:f))/0.02)
%hold on
%plot(0:0.02:(f-st)/50-0.02,filter(by,ay,yawdif))
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

%% Fourrier Transform Pitch

Fs = 50; %Hz

L = length(roll(st:f));
%windowSize = 7;
%b = (1/windowSize)*ones(1,windowSize);
%a = 1;

Y = fft(filter(bp2,ap2,diff(pitch(st:f))/0.02));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure(3)
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

%% Fourrier Transform Roll
Fs = 50; %Hz

L = length(roll(st:f));

Y = fft(filter(br2,ar2,diff(roll(st:f))/0.02));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ff = Fs*(0:(L/2))/L;
figure(4)
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

%% Fourrier Transform Yaw
Fs = 50; %Hz

L = length(roll(st:f));

Y = fft(filter(by2,ay2,diff(yaw(st:f))/0.02));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ff = Fs*(0:(L/2))/L;
figure(5)
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







