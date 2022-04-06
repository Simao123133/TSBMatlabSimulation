load('../NonlinearBoatModel/MatFiles/linear_model')
load('../Controllers/LQI_rear_fixed/Controller')

%% Get lateral model
Al = lin_model.A([7 9],[7 9]);
Bl = 2*lin_model.B([7 9],1);
Cl = [0 1];
Dl = 0;

%% Consider LQI structure
Ail=[Al   , zeros(size(Al,1),1);
    -Cl   ,        zeros(1,1) ];
Bil=[ Bl; 
     0];
Cil=[Cl, zeros(1,1)];
Dil=zeros(1,1);
Br_l = [zeros(size(Al,1),1);1];

%% Closed loop model and bandwidth
Cil_ol=eye(3);
Dil_ol = zeros(1,1);
model_l = ss(Ail-Bil*Kil,Br_l,Cil_ol,Dil_ol);
[num,den] = ss2tf(model_l.A,model_l.B,model_l.C,model_l.D,1);
pair1 = tf(num(2,:), den);
pair1_b = bandwidth(pair1);

%% Open loop model
model_l_ol = ss(Ail,Bil,Cil_ol,Dil_ol);
[mag,phase,w] = bode(model_l_ol);
magdb = 20*log10(mag);
%% Loop Gain
model_l_loop_gain = ss(Ail,Bil,Kil,Dil_ol);

%% Input - Output variation disk margins
MMIO = diskmargin(model_l_ol,Kil)


%% Output variation (in the feedback loop only)
[~,MMl_out] = diskmargin(model_l_ol*Kil);
[~,MMl_in] = diskmargin(Kil*model_l_ol);





