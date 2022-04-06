clear
%% Load Linearized Model

%Uncomment to linearize
%run('../../NonlinearBoatModel/linearize_boat');
load('../../NonlinearBoatModel/MatFiles/linear_model.mat')

var = [1 2 3 4 5 7 9];

A = lin_model.A(var,var);
B = [lin_model.B(var,1) lin_model.B(var,2) lin_model.B(var,3)];
C = [0 0 0 0 1 0 0];
D = 0;

%% Set weights manually 

% Heave and pitch
theta_range = 0.1;
thetadot_range = 20; 
u_range = 0.1;
w_range = 4;
z_range = 0.1;

foil_range = 8.5;

weights = [1 1 1 1 1 100 500];

Qh = [weights(1)/u_range^2 weights(2)/w_range^2 weights(3)/thetadot_range^2 ...
       weights(4)/theta_range^2 weights(5)/z_range^2]; 
Rh = weights(6)/foil_range^2;

Rp = weights(7)/foil_range^2;

%Roll

rolldot_range = 2; 
roll_range = 0.5;
foil_range = 8.5;

weights = [1 1 100];

Ql = [weights(1)/rolldot_range^2 weights(2)/roll_range^2];
        
Rl = weights(3)/foil_range^2;

%% Calculate gains
Q = diag([Qh Ql]);
R = diag([Rh Rl Rp]);

[K,~,~]=lqr(A,B,Q,R);

fprintf('K\n') 
display(K)

save('controller.mat','K')


 
