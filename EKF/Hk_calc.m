syms z Pitch Roll dist_cm_Us_x
zus = (z*cos(Roll)-tan(Pitch)*dist_cm_Us_x)/cos(Pitch); 

jac = jacobian(zus,[Pitch,z,Roll]);
