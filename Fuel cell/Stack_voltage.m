function [V] = Stack_voltage(I)
I_stack = [0 10 40 80 120 150 180 200 230];
V_stack = [38.7 34.3 31.6 29.3 27.5 26.2 24.8 23.8 22.1];

I = linspace(max (I_stack), min(I_stack), 500)
V = interp1(I_stack, V_stack, I, 'linear')
end

