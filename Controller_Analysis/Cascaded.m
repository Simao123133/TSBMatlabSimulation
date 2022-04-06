%ioInput = linio('cascaded_model/Controller/Cascaded roll',1,'looptransfer');

%Li = linearize('cascaded_model',ioInput);   % SISO

%Si = allmargin(-Li)

st = [7 9];
A = lin_model.A(st,st);
B = lin_model.B(st,1) - lin_model.B(st,2);
C = eye(2);
D = zeros(2,1);

ioInput = linio('CascadedControllerOnly/Cascaded roll',1,'looptransfer');

Li = linearize('CascadedControllerOnly',ioInput);   % SISO

Si = allmargin(-Li)







