load('../NonlinearBoatModel/MatFiles/linear_model')
load('../NonlinearBoatModel/MatFiles/Controller')


%% Consider LQI structure
Aih=[Ah   , zeros(size(Ah,1),1);
    -Ch   ,        zeros(1,1) ];

Bih=[ Bh; 
     0];
     
Cih=[Ch, zeros(1,1)];
Dih=zeros(1,1);

%% Closed loop model and bandwidth
model_h = ss(Aih-Bih*Kih_high,Br_h,Cih,Dih);
[num,den] = ss2tf(model_h.A,model_h.B,model_h.C,model_h.D,1);

pair1_b = bandwidth(pair1);
%% Open loop model
Cih_ol = eye(6);
Dih_ol = zeros(6,1);
model_h_ol = ss(Aih,Bih,Cih_ol,Dih_ol);
[mag,phase,w] = bode(model_h_ol);
magdb = 20*log10(mag);
%% Loop Gain
model_h_loop_gain = ss(Aih,Bih,Kih,Dih);

%% Input - Output variation disk margins
MMIO = diskmargin(model_h_ol,Kih_high);

%% Output variation (in the feedback loop only)
[DMl,MMl] = diskmargin(model_h_loop_gain);

%% Get loop gain from simulink
% mdl = 'boat_model_and_controller_Freq';
% open_system(mdl);
% sllin = slLinearizer(mdl);
% addPoint(sllin,'loopbreak');
% sys = getLoopTransfer(sllin,'loopbreak',-1);
% [DM,MM] = diskmargin(sys);

