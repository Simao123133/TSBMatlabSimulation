clear
load('../FlightData/montargil.mat')
rpms = Motor1_duty__44_M1_RPM_01.signals.values;
rpms_time = Motor1_duty__44_M1_RPM_01.time;
speed = Foils_setpoi_41_Speed_03.signals.values;
speed_time = Foils_setpoi_41_Speed_03.time;
save('RpmsSpeedData.mat','rpms','rpms_time','speed','speed_time');