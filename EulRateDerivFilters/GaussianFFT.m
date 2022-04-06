clear
%r = normrnd(0,0.25^2,[1000,1]);
r = wgn(1000,1,0.25^2);

L = 1000;
Fs = 50;
Y = fft(r);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
ff = Fs*(0:(L/2))/L;
plot(ff,P1) 

title('Single-Sided Amplitude Spectrum of dPitch/dt')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Filtered','Raw')
hold off