function xk_minus = RKM_EKF(xk_previous_plus,uk,ts)
k1 = Theoretical_model_EKF(xk_previous_plus,uk);
k2 = Theoretical_model_EKF(xk_previous_plus + 1/3*k1*ts,uk);
k3 = Theoretical_model_EKF(xk_previous_plus + 1/6*k1*ts + 1/6*k2*ts,uk);
k4 = Theoretical_model_EKF(xk_previous_plus + 1/8*k1*ts + 3/8*k3*ts,uk);
k5 = Theoretical_model_EKF(xk_previous_plus + 1/2*k1*ts - 3/2*k3*ts + 2*k4*ts,uk);
xk_minus = xk_previous_plus + ts/6*(k1 + 4*k4 + k5);
end