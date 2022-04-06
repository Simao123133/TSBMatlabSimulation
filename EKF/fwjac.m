function Afw = fwjac(xk,uk)
h = 0.001;
ffw = zeros(10,10);
fbw = zeros(10,10);
for i=1:10
    xkf = xk;
    xkb = xk;
    xkf(i) = xk(i)+h;
    xkb(i) = xk(i)-h;
    ffw(:,i) = Theoretical_model_EKF(xkf,uk);
    fbw(:,i) = Theoretical_model_EKF(xkb,uk);
end
Afw = (ffw-fbw)/(2*h);
end