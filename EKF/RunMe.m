clear
load('raw_data.mat')

xk = [U.signals.values(1:end-1) W.signals.values(1:end-1) 50*diff(Pitch.signals.values) Pitch.signals.values(1:end-1) -Height.signals.values(1:end-1)/100 V.signals.values(1:end-1) 50*diff(Roll.signals.values) 50*diff(Yaw.signals.values) Roll.signals.values(1:end-1) Yaw.signals.values(1:end-1)]';
uk = [Left_foil.signals.values(1:end-1) Right_foil.signals.values(1:end-1) 1.91*ones(length(U.signals.values)-1,1) Motor.signals.values(1:end-1) 50*diff(Yaw.signals.values)]';

xk = [U.signals.values(1:end-1) W.signals.values(1:end-1) 50*diff(Pitch.signals.values) Pitch.signals.values(1:end-1) -Height.signals.values(1:end-1)/100 V.signals.values(1:end-1) 50*diff(Roll.signals.values) 50*diff(Yaw.signals.values) Roll.signals.values(1:end-1)  Yaw.signals.values(1:end-1)]';
uk = [Left_foil.signals.values(1:end-1) Right_foil.signals.values(1:end-1) 1.91*ones(length(U.signals.values)-1,1) Motor.signals.values(1:end-1) lowpass(15*diff(Yaw.signals.values),1,10)]';


xkload = timeseries(xk(:,250:350),0:0.1:10);
ukload = timeseries(uk(:,250:350),0:0.1:10);
    
%uk_gyr = [Left_foil.signals.values(1:end-1)-Right_foil.signals.values(1:end-1) Left_foil.signals.values(1:end-1)+Right_foil.signals.values(1:end-1) 50*diff(Yaw.signals.values)]';
%xk_gyr = [Roll.signals.values Pitch.signals.values Yaw.signals.values gyrX.signals.values gyrY.signals.values gyrZ.signals.values]';

%xkload_gyr = timeseries(xk_gyr(:,350:450),0:0.1:10);
%ukload_gyr = timeseries(uk_gyr(:,350:450),0:0.1:10);
%plot(out.tout,out.p.Data(:,1),out.tout,out.p.Data(:,2),out.tout,out.p.Data(:,3));

