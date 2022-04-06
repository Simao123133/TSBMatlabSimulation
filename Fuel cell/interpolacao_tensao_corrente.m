I = [0 10 40 80 120 150 180 200 230];
V_stack = [38.7 34.3 31.6 29.3 27.5 26.2 24.8 23.8 22.1];

%interpolation - Stack Voltage (V_stack) depending on the Current (I)

I_new = linspace(max (I), min(I), 500);

V_stack_new = interp1(I, V_stack, I_new, 'linear');

plot(I_new, V_stack_new, 'lineWidth', 1);
