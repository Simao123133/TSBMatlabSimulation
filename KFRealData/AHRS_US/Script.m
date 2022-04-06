clear
ahrs_data = importdata('ahrs.txt');
US_data = importdata('US.csv');
i_time = 2;
i_filt = 4;
i_unfilt = 6;
US_time = US_data.data(:,i_time) + US_data.data(:,i_time+1)/1000;
z_filt = -US_data.data(:,i_filt) + US_data.data(:,i_filt+1)/100;
z_unfilt = -US_data.data(:,i_unfilt) + US_data.data(:,i_unfilt+1)/100;
i_acc = 9;
i_vz = 18;
i_gyrY = 11;
i_pitch = 14;

acc = ahrs_data.data(:,i_acc);
vz = ahrs_data.data(:,i_vz);
gyrY = ahrs_data.data(:,i_gyrY);
pitch = ahrs_data.data(:,i_pitch);
%plot(US_time(50:end)-US_time(50),z_filt(50:end)/100)
plot(US_time(50:end)-US_time(50),diff(z_filt(50-1:end)/100)*10)
hold on
%hold off
plot(0:0.02:length(vz)/50-0.02,vz)
hold off
legend('USdiff','vzAhrs')
xlabel('time [s]')
ylabel('z [m]')

figure(2)
plot(US_time(50:end)-US_time(50),z_filt(50:end)/100)
hold on
plot(0:0.02:length(vz)/50-0.02,z_filt(50)/100+cumtrapz(0:0.02:length(vz)/50-0.02,vz))
hold off
legend('USdiff','vzAhrs')
xlabel('time [s]')
ylabel('z [m]')

sys = ss([0 -1;0 0],[1;0],[1 0],zeros(1,1));
sys_d = c2d(sys,0.02);
A = sys_d.A;
B = sys_d.B;
C = sys_d.C;
Q = [0.01 0;0 0.1];
R = 1000;

[m,P,Z,E] = dlqe(sys_d.A,eye(2),sys_d.C,Q,R);
zsimu = [US_time(53:end)-US_time(53),z_filt(53:end)/100];
j = 1;
zsamp = zeros(length(pitch),1);
for i=1:length(pitch)
   znow = z_filt(52+j);
   if znow > -15
       zsamp(i) = zsamp(i-1);
   elseif znow < -170
       zsamp(i) = zsamp(i-1);
   else
       zsamp(i) = znow/100;
   end
   if rem(i-1,5) == 0 && i ~= 1
       j = j+1;
   end
end
vztime = 0:0.02:length(vz)/50-0.02;
zsimu = [vztime', zsamp.*cosd(pitch)];
vzsimu = [vztime',vz];
pitchsimu = [vztime' abs(pitch)/10+1];
gyrYsimu = [vztime(1:end-1)', diff(pitch)*50*pi/180];
bias_init = 0;
out = sim('KF2');

ax1 = subplot(2,1,1);
%plot(out.tout,out.zKF.Data,out.tout,out.zsimu.Data,out.tout,zsimu(1:40*50+1,2))
%legend('zKF','zUs','zUsReal')
plot(out.tout,out.zKF.Data,out.tout,out.zsimu.Data)
legend('zKF','zUs')

ax2 = subplot(2,1,2);
plot(out.tout,out.bias.Data)
title('vz bias')

linkaxes([ax1,ax2],'x')

