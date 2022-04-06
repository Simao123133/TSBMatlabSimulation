clear
load('RpmsSpeedData.mat')
I_speed = 23060;
speed_time_init = speed_time(I_speed);
[~,I_rpms] = min(abs(rpms_time - speed_time_init));

if abs(rpms_time(I_rpms) - speed_time_init) > 0.02
    fprintf("Try another I_speed so that the times can match");
end

I_speed_stop = 100/0.1; % 100 s = 1000 samples, 0.1 sample time;
I_rpms_stop = 100/0.02;

time = 700;
rpms_seg = zeros(time/0.1+1,1);
for i=0:time/0.1
    s_time = speed_time(I_speed+i);
    [time_dif,I_rpms] = min(abs(rpms_time - s_time));
    if time_dif > 0.02
        fprintf(time_dif);
    end
    rpms_seg(i+1) = rpms(I_rpms);
end
speed_seg = speed(I_speed:I_speed+time/0.1);

figure(1)
subplot(2,1,1)
plot(speed_seg)
subplot(2,1,2)
plot(rpms_seg);

Ts = 0.1;
data = iddata(speed_seg,rpms_seg,Ts);
na = 2;
nb = 2;
nc = 2;
nk = 1;
sys = armax(data,[na nb nc nk]);

figure(2)
compare(data,sys)
