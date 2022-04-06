clear
%% Load Linearized Model

%Uncomment to linearize
%run('../../NonlinearBoatModel/linearize_boat');
load('../../NonlinearBoatModel/MatFiles/linear_model.mat')

%% Split model between longitudinal and lateral

Al = lin_model.A([7 9],[7 9]);
Bl = 2*lin_model.B([7 9],1);
Cl = [0 1];
Dl = 0;

% and consider only 1 output (commun mode)
Ah = lin_model.A(1:5,1:5);
Bh = 2*lin_model.B(1:5,1);
Ch = [0 0 0 0 1];
Dh = 0;

%% Check Controlability: rank must be equal to dim of model
lin_model_h = ss(Ah,Bh,Ch,Dh);
Co = ctrb(lin_model_h);
Co_rank = rank(Co);
if Co_rank < size(lin_model_h.A,1)
    error("Longitudinal model is not controllable");
end
lin_model_l = ss(Al,Bl,Cl,Dl);
Co = ctrb(lin_model_l);
Co_rank = rank(Co);
if Co_rank < size(lin_model_l.A,1)
    error("Lateral model is not controllable");
end

%% LQI's algorithm

% New matrices to calculate LQI
% longitudinal

Aih=[Ah   , zeros(size(Ah,1),1);
    Ch   ,        zeros(1,1)      ];
Bih=[ Bh; 
     0];    
Cih=[Ch, zeros(1,1)];
Dih=Dh;

% lateral

Ail=[Al   , zeros(size(Al,1),1);
    Cl   ,        0      ];
Bil=[ Bl(:,1); 
     0]; 
Cil=[Cl, zeros(size(Cl,1),1)];
Dil=0;

%% Set weights manually - longitudinal

theta_range = 5;
thetadot_range = 20; 
u_range = 10;
w_range = 4;
z_range = 0.5;

integral = 10;
foil_range = 4;

weights = [1 1 1 1 1 1];

Qih = diag([weights(1)/u_range^2 weights(2)/w_range^2 weights(3)/thetadot_range^2 ...
       weights(4)/theta_range^2 weights(5)/z_range^2 integral]); 
Rih = weights(6)/foil_range^2;

%% Load predefined matrices
load('QR_lon.mat')
[Kih,~,~]=lqr(Aih,Bih,Qih,Rih);

%% Set weights manually - lateral

rolldot_range = 3; 
roll_range = 1;

integral = 1;
foil_range = 8.5;

weights = [1 1 100];

Qil = diag([weights(1)/rolldot_range^2 weights(2)/roll_range^2 integral]);
        
Ril = weights(3)/foil_range^2;
   
%% Load predefined matrices
%load('QR_lat.mat')

[Kil,~,~]=lqr(Ail,Bil,Qil,Ril);

fprintf('Kil\n') 
display(Kil)

save('controller.mat','Kih','Kil')


 
