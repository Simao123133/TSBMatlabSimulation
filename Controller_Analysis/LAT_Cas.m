clear
load('../NonlinearBoatModel/MatFiles/linear_model')

%% Get lateral model
Al = lin_model.A([6:9],[6:9]);
Bl = 2*lin_model.B([6:9],1);
Cl_roll = [0 1 0 0;
      0 0 0 1];
Cl = [0 1 0;
      0 0 1];  
Dl = [0;0];

model_ss = ss(Al, Bl, Cl_roll, Dl);
[num,den] = ss2tf(model_ss.A(1:3,1:3),model_ss.B(1:3),Cl,Dl);
inner_model = tf(num(1,:), den);
%% 
s = tf('s');
K_rolldot = 0.4 + 0.1/s;
inner_model_cl = feedback(K_rolldot*inner_model, 1);
inner_bd = bandwidth(inner_model_cl);
diskmargin(inner_model, K_rolldot);

outer_loop = inner_model_cl/s;

K_roll = 2;

outer_loop_cl = feedback(outer_loop*K_roll,1);
outer_loop_bd = bandwidth(outer_loop_cl);

%% Full model is a bit different -- checking
full_loop_inner = feedback(model_ss, [K_rolldot 0]);
full_loop_inner2 = ss(full_loop_inner.A, full_loop_inner.B,full_loop_inner.C(2,:),0);
full_loop = feedback(full_loop_inner2*K_rolldot*K_roll, 1);

step(outer_loop_cl) 
hold on 
step(full_loop)
hold off

K = [K_rolldot K_roll*K_rolldot];

diskmargin(model_ss,K)




