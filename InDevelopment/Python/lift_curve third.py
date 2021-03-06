import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt
from Boat_Model import boat_update
import time 
from matplotlib.ticker import (AutoMinorLocator, MultipleLocator)
from numpy.polynomial import Polynomial
from scipy.optimize import curve_fit

rho= 1025.00 # Water density(kg/m**3)   <-I
mu= 1.14E-3 # Coef. Viscosidade Dinâmica para calular Reynolds(Pa*s)   <-I
c_FF=0.08 # Corda foil frente(m)
max_angle = 17
min_angle = -5
angle_i = (max_angle - min_angle)*10 
max_speed = 18
min_speed = 0
speed_i = (max_speed - min_speed)*10

def cl(x,y): 
        #determining coefficient of lift of the foils for a set angle of attack
        p00 =     0.04647
        p10 =      0.1369
        p01 =    0.001502
        p20 =   0.0005872
        p11 =  -0.0001138
        p02 =  -2.794e-06
        p30 =  -0.0007229
        p21 =  -2.662e-07
        p12 =   1.545e-07
        p03 =   2.428e-09
        p40 =   1.647e-05
        p31 =   6.574e-07
        p22 =  -3.892e-09
        p13 =  -7.221e-11
        p04 =  -9.966e-13
        p50 =  -6.807e-08
        p41 =  -2.534e-09
        p32 =  -2.657e-10
        p23 =   2.267e-12
        p14 =   9.751e-15
        p05 =   1.555e-16
        
        return (p00 + p10*x + p01*y + p20*x**2 + p11*x*y + p02*y**2 + p30*x**3 + p21*x**2*y 
        + p12*x*y**2 + p03*y**3 + p40*x**4 + p31*x**3*y + p22*x**2*y**2 
        + p13*x*y**3 + p04*y**4 + p50*x**5 + p41*x**4*y + p32*x**3*y**2 
        + p23*x**2*y**3 + p14*x*y**4 + p05*y**5)

def f(x, p00,p10,p01,p20,p11,p02,p30,p21,p12,p03,p31,p22,p13,p04,p32,p23,p14,p05):
    aa = x[0]
    Re = x[1]
    x=aa
    y=Re
    
    return (p00 + p10*x + p01*y + p20*x**2 + p11*x*y + p02*y**2 + p30*x**3 + p21*x**2*y 
        + p12*x*y**2 + p03*y**3 + p31*x**3*y + p22*x**2*y**2 
        + p13*x*y**3 + p04*y**4 + p32*x**3*y**2 
        + p23*x**2*y**3 + p14*x*y**4 + p05*y**5)

g = 0
cl_v = np.zeros(angle_i*speed_i)
aa_v = np.zeros(angle_i*speed_i)
Re_v = np.zeros(angle_i*speed_i)

for i in range(0, angle_i):
    k = i/10 - 5
    for j in range(0, speed_i):
        l = j/10
        Re = (rho)*l*(c_FF)/(mu) 
        cl_v[g] = cl(k, Re/1000)
        aa_v[g] = k
        Re_v[g] = Re/1000
        g = g + 1

popt, pcov = curve_fit(f, (aa_v, Re_v), cl_v)

def f_aa(aa, speed, p00,p10,p01,p20,p11,p02,p30,p21,p12,p03,p31,p22,p13,p04,p32,p23,p14,p05):
    rho= 1025.00 
    mu= 1.14E-3 
    c_FF=0.08 
    Re = (rho)*speed*(c_FF)/(mu)/1000 
    x=aa
    y=Re

    return (p00 + p10*x + p01*y + p20*x**2 + p11*x*y + p02*y**2 + p30*x**3 + p21*x**2*y 
        + p12*x*y**2 + p03*y**3 + p31*x**3*y + p22*x**2*y**2 
        + p13*x*y**3 + p04*y**4 + p32*x**3*y**2 
        + p23*x**2*y**3 + p14*x*y**4 + p05*y**5)


aa = np.zeros(angle_i)
cl_v_aa = np.zeros(angle_i)
speed = 3
Re = (rho)*speed*(c_FF)/(mu) #Num Reynolds foil frente

for i in range(0, angle_i):
    k = i/10 - 5
    aa[i] = k
    cl_v_aa[i] = cl(k, Re/1000)

plt.plot(aa, f_aa(aa, speed, *popt), aa, cl_v_aa)
print(*popt)
print(max(cl_v_aa),np.argmax(cl_v_aa)/10+min_angle)
plt.legend(['3rd order','5th order'])
plt.show()