function Hk = Hk_func(Pitch, z, Roll)
dist_cm_Us_x = 3.150;
dpitch = - (dist_cm_Us_x*(tand(Pitch)^2 + 1))/cosd(Pitch) - (sind(Pitch)*(dist_cm_Us_x*tand(Pitch) - z*cosd(Roll)))/cosd(Pitch)^2;
dz = cosd(Roll)/cosd(Pitch);
droll = -(z*sind(Roll))/cosd(Pitch);
Hk = [1 zeros(1,9);
      0 1 zeros(1,8);
      0 0 1 zeros(1,7);
      0 0 0 1 zeros(1,6);
      0 0 0 -dist_cm_Us_x*pi/180 1 0 0 0 0 0;
      0 0 0 0 0 1 zeros(1,4);
      0 0 0 0 0 0 1 zeros(1,3);
      0 0 0 0 0 0 0 1 zeros(1,2);
      0 0 0 0 0 0 0 0 1 0;
      0 0 0 0 0 0 0 0 0 1];
end