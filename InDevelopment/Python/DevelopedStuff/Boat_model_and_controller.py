import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt
from scipy.optimize._trustregion_constr.equality_constrained_sqp import default_scaling
from Boat_Model import boat_update
import time 
from matplotlib.ticker import (AutoMinorLocator, MultipleLocator)
from calculate_constants3 import constants3
from func_newton import func_split
from Simplified_sys import get_aa
import random
import math as mt
from scipy import optimize
from Controllers import SMC_controller, PID_controller
from Filters import median_filter, states_filter


def plot1(t, trajectory, inputs):

    plt.rcParams['axes.grid'] = True
    fig, axs = plt.subplots(5,3)
    fig.suptitle('Trajectory')
    axs[0,0].plot(t, trajectory[:,0])
    axs[1,0].plot(t, trajectory[:,1])
    axs[2,0].plot(t, trajectory[:,2])
    axs[3,0].plot(t, trajectory[:,3])
    axs[4,0].plot(t, trajectory[:,4])
    axs[0,1].plot(t, trajectory[:,5])
    axs[1,1].plot(t, trajectory[:,6])
    axs[2,1].plot(t, trajectory[:,7])
    axs[3,1].plot(t, trajectory[:,8])
    axs[4,1].plot(t, trajectory[:,9])
    axs[0,2].plot(t, inputs[:,0])
    axs[1,2].plot(t, inputs[:,1])
    axs[2,2].plot(t, inputs[:,2])
    axs[3,2].plot(t, inputs[:,3])
    axs[4,2].plot(t, inputs[:,4])

    # Change major ticks to show every 20.
    axs[0,2].yaxis.set_major_locator(MultipleLocator(1))
    axs[1,2].yaxis.set_major_locator(MultipleLocator(1))
    axs[3,1].yaxis.set_major_locator(MultipleLocator(1))

    # Change minor ticks to show every 5. (20/4 = 5)
    axs[0,2].yaxis.set_minor_locator(MultipleLocator(0.2))
    axs[1,2].yaxis.set_minor_locator(MultipleLocator(0.2))
    axs[3,1].yaxis.set_minor_locator(MultipleLocator(0.2))

    # Turn grid on for both major and minor ticks and style minor slightly
    # differently.
    axs[0,2].grid(which='major', color='#CCCCCC', linestyle='--')
    axs[0,2].grid(which='minor', color='#CCCCCC', linestyle=':')
    axs[1,2].grid(which='major', color='#CCCCCC', linestyle='--')
    axs[1,2].grid(which='minor', color='#CCCCCC', linestyle=':')

    axs[0,0].title.set_text('u')
    axs[1,0].title.set_text('w')
    axs[2,0].title.set_text('q')
    axs[3,0].title.set_text('pitch')
    axs[4,0].title.set_text('heave')

    axs[0,1].title.set_text('v')
    axs[1,1].title.set_text('p')
    axs[2,1].title.set_text('r')
    axs[3,1].title.set_text('roll')
    axs[4,1].title.set_text('yaw')

    axs[0,2].title.set_text('Left foil')
    axs[1,2].title.set_text('Right foil')
    axs[2,2].title.set_text('Rear foil')
    axs[3,2].title.set_text('Rpms motor')
    axs[4,2].title.set_text('Rudder')

    plt.grid()
    plt.subplots_adjust(left=0.1,bottom=0.1, right=0.9, top=0.9, wspace=0.4, hspace=0.4)

    plt.show()


def plot2(t, trajectory, trajectory1, inputs, inputs1):

    plt.rcParams['axes.grid'] = True
    fig, axs = plt.subplots(5,3)
    fig.suptitle('Trajectory')
    axs[0,0].plot(t, trajectory[:,0], t ,trajectory1[:,0])
    axs[1,0].plot(t, trajectory[:,1], t ,trajectory1[:,1])
    axs[2,0].plot(t, trajectory[:,2], t ,trajectory1[:,2])
    axs[3,0].plot(t, trajectory[:,3], t ,trajectory1[:,3])
    axs[4,0].plot(t, trajectory[:,4], t ,trajectory1[:,4])
    axs[0,1].plot(t, trajectory[:,5], t ,trajectory1[:,5])
    axs[1,1].plot(t, trajectory[:,6], t ,trajectory1[:,6])
    axs[2,1].plot(t, trajectory[:,7], t ,trajectory1[:,7])
    axs[3,1].plot(t, trajectory[:,8], t ,trajectory1[:,8])
    axs[4,1].plot(t, trajectory[:,9], t ,trajectory1[:,9])
    axs[0,2].plot(t, inputs[:,0],t, inputs1[:,0])
    axs[1,2].plot(t, inputs[:,1],t, inputs1[:,1])
    axs[2,2].plot(t, inputs[:,2],t, inputs1[:,2])
    axs[3,2].plot(t, inputs[:,3],t, inputs1[:,3])
    axs[4,2].plot(t, inputs[:,4],t, inputs1[:,4])

    # Change major ticks to show every 20.
    axs[0,2].yaxis.set_major_locator(MultipleLocator(1))
    axs[1,2].yaxis.set_major_locator(MultipleLocator(1))
    axs[3,1].yaxis.set_major_locator(MultipleLocator(1))

    # Change minor ticks to show every 5. (20/4 = 5)
    axs[0,2].yaxis.set_minor_locator(MultipleLocator(0.2))
    axs[1,2].yaxis.set_minor_locator(MultipleLocator(0.2))
    axs[3,1].yaxis.set_minor_locator(MultipleLocator(0.2))

    # Turn grid on for both major and minor ticks and style minor slightly
    # differently.
    axs[0,2].grid(which='major', color='#CCCCCC', linestyle='--')
    axs[0,2].grid(which='minor', color='#CCCCCC', linestyle=':')
    axs[1,2].grid(which='major', color='#CCCCCC', linestyle='--')
    axs[1,2].grid(which='minor', color='#CCCCCC', linestyle=':')

    axs[0,0].title.set_text('u')
    axs[1,0].title.set_text('w')
    axs[2,0].title.set_text('q')
    axs[3,0].title.set_text('pitch')
    axs[4,0].title.set_text('heave')

    axs[0,1].title.set_text('v')
    axs[1,1].title.set_text('p')
    axs[2,1].title.set_text('r')
    axs[3,1].title.set_text('roll')
    axs[4,1].title.set_text('yaw')

    axs[0,2].title.set_text('Left foil')
    axs[1,2].title.set_text('Right foil')
    axs[2,2].title.set_text('Rear foil')
    axs[3,2].title.set_text('Rpms motor')
    axs[4,2].title.set_text('Rudder')

    plt.grid()
    plt.subplots_adjust(left=0.1,bottom=0.1, right=0.9, top=0.9, wspace=0.4, hspace=0.4)

    plt.show()

def cosd(ang):
    return np.cos(ang*np.pi/180)
def sind(ang):
    return np.sin(ang*np.pi/180)

def sensors(Y, noise):

    Y_sensor = np.zeros(11)
    Roll = Y[8]
    Pitch = Y[3]
    Yaw = Y[9]

    R = np.array([[cosd(Pitch)*cosd(Yaw), cosd(Pitch)*sind(Yaw), -sind(Pitch)],
        [sind(Roll)*sind(Pitch)*cosd(Yaw)-cosd(Roll)*sind(Yaw), sind(Roll)*sind(Pitch)*sind(Yaw)+cosd(Roll)*cosd(Yaw), sind(Roll)*cosd(Pitch)],
        [cosd(Roll)*sind(Pitch)*cosd(Yaw)+sind(Roll)*sind(Yaw), cosd(Roll)*sind(Pitch)*sind(Yaw)-sind(Roll)*cosd(Yaw), cosd(Roll)*cosd(Pitch)]])

    V = np.linalg.inv(R)@np.array([Y[0], Y[5], Y[1]])

    if(noise == 1):
        Y_sensor[0] = Y[0] + random.gauss(0,0.05)
        Y_sensor[1] = Y[1] + random.gauss(0,0.05)
        Y_sensor[2] = Y[2] + random.gauss(0,0.035)
        Y_sensor[3] = Y[3] + random.gauss(0,0.2)
        Y_sensor[4] = Y[4] + random.gauss(0,0.001)
        Y_sensor[5] = Y[5] + random.gauss(0,0.05)
        Y_sensor[6] = Y[6] + random.gauss(0,0.035)
        Y_sensor[7] = Y[7] + random.gauss(0,0.035)
        Y_sensor[8] = Y[8] + random.gauss(0,0.2)
        Y_sensor[9] = Y[9] + random.gauss(0,0.5)
        Y_sensor[10] = V[2] + random.gauss(0,0.05)
    else:
        Y_sensor[0:10] = Y
        Y_sensor[10] = V[2]

    return Y_sensor

def simulate(method, noise):

    Y = [7, 0, 0, 0, -0.5, 0, 0, 0, 0, 0]
    Y_sensor = np.array([7, 0, 0, 0, -0.5, 0, 0, 0, 0, 0, 0])
    Y_filtered = np.array([7, 0, 0, 0, -0.5, 0, 0, 0, 0, 0, 0])
    Roll_ref = 0*np.pi/180
    Z_ref = -0.5
    Act_rear = 2.02
    Rudder = 15
    Rpms_motor = 4780
    i = 0

    inputs = np.zeros((steps,5))
    trajectory = np.zeros((steps, 10))
    trajectory_sensor = np.zeros((steps, 10))
    t = np.arange(0, steps*dt, dt)
    trajectory[0] = Y
    Act_front_left = 1.55
    Act_front_right = 1.55
    Real_Act_front_right = Act_front_right
    Real_Act_front_left = Act_front_left
    inputs[0] = np.array([Act_front_left, Act_front_right, Act_rear, Rpms_motor, Rudder])
    p_prev = 0
    p_ref_prev = 0
    V_prev = 0
    V_ref_prev = 0

    SR = 10 #º/s
    timed = np.zeros(steps)

    while i <= steps-1:

        start = time.time()

        Roll = Y_sensor[8]*np.pi/180
        p = Y_sensor[6]*np.pi/180
        Z = Y_sensor[4]
        V = Y_sensor[10]
        
        if(method == 0):

            diff = PID_roll.compute(Roll_ref, Roll, p)
            com = PID_z.compute(Z_ref, Z, V)

            Act_front_left = com + diff 
            Act_front_right = com - diff 

        elif(method == 1):
    
            u_phi = SMC_roll.compute(Roll_ref, Roll, p)
            u_z = SMC_z.compute(Z_ref, Z, V)

            Act_front_left = -u_z + u_phi
            Act_front_right = -u_z - u_phi

            if(u_z > 14):
                u_z = 14
            elif u_z < -3:
                u_z = -3

            lower_lim = (-u_z) - (-3)
            upper_lim = 14 - (-u_z)

            lim = upper_lim
            if (lower_lim < upper_lim):
                lim = lower_lim

            if abs(u_phi) > lim:
                u_phi = lim*np.sign(u_phi)

            #Act_front_left = -u_z + u_phi
            #Act_front_right = -u_z - u_phi
       
        elif(method == 2):

            u_phi = SMC_roll.compute(Roll_ref, Roll, p)
            u_z = SMC_z.compute(Z_ref, Z, V)

            a47, a48, a49, a50, a51, a52, a54, a55, a56, a57, a58, a59, a77, a62, a63, a64, a65, a66, a67, a69, a70, a71, a72, a73, a74, a78, Re_LF, Re_RF, aa_LF, aa_RF = constants3(Y_sensor[0:10], np.array([Act_rear, Rudder, Rpms_motor]), u_z, u_phi)
            res = optimize.root(func_split, [1.55, 1.55], args=(a47, a48, a49, a50, a51, a52, a54, a55, a56, a57, a58, a59, a77, a62, a63, a64, a65, a66, a67, a69, a70, a71, a72, a73, a74, a78, Re_LF, Re_RF, aa_LF, aa_RF), method='hybr')
            Act_front_left = res.x[0]
            Act_front_right = res.x[1]

            #Act_front_left, Act_front_right = get_aa(Y, np.array([Act_rear, Rudder, Rpms_motor]), u_z, u_phi)
           
        elif(method == 3):
            p_ref = 2*mt.sqrt(abs(Roll_ref-Roll))*np.sign(Roll_ref-Roll)
            pdot_val = (p_ref - p_ref_prev)/0.02 - (p-p_prev)/0.02
            pdot = pderiv.update(pdot_val)
            p_prev = p
            p_ref_prev = p_ref
            diff = PID_inner_p.compute(p_ref, p, -pdot)

            V_ref = 0.5*(Z_ref - Z)
            Vdot_val = (V_ref - V_ref_prev)/0.02 - (V-V_prev)/0.02
            Vdot = Vderiv.update(Vdot_val)
            V_prev = V
            V_ref_prev = V_ref

            com = PID_inner_p.compute(V_ref, V, -Vdot)
            com = PID_z.compute(Z_ref, Z, V)

            Act_front_left = com + diff 
            Act_front_right = com - diff 

           

        timed[i] = time.time() - start
        
        if np.absolute((Act_front_left - Real_Act_front_left)) < SR*dt:
            Real_Act_front_left = Act_front_left
        elif Act_front_left - Real_Act_front_left > 0:
            Real_Act_front_left += SR*dt
        elif Act_front_left - Real_Act_front_left < 0:
            Real_Act_front_left -= SR*dt
        
        if np.absolute((Act_front_right - Real_Act_front_right)) < SR*dt:
            Real_Act_front_right = Act_front_right
        elif Act_front_right - Real_Act_front_right > 0:
            Real_Act_front_right += SR*dt
        elif Act_front_right - Real_Act_front_right < 0:
            Real_Act_front_right -= SR*dt

        if Real_Act_front_left > 14:
            Real_Act_front_left = 14
        elif Real_Act_front_left < -3:
            Real_Act_front_left = -3

        if Real_Act_front_right > 14:
            Real_Act_front_right = 14
        elif Real_Act_front_right < -3:
            Real_Act_front_right = -3

        
        fk_input = [Real_Act_front_left, Real_Act_front_right, Act_rear, Rpms_motor, Rudder]

        inputs[i] = [Real_Act_front_left, Real_Act_front_right, Act_rear, Rpms_motor, Rudder]

        all_states = odeint(boat_update, Y, [0, dt], args=(fk_input,))

        Y = all_states[1]
        Y_sensor = sensors(Y, noise)
        
        trajectory[i] = np.array(Y)
        trajectory_sensor[i] = np.array(Y_sensor[0:10])
        
        i = i + 1
        
    return t, trajectory, inputs, timed
    
dt = 0.02
steps = 500
inputs = np.zeros((steps,5))
trajectory = np.zeros((steps, 11))
t = np.arange(0, steps*dt, dt)
timed = np.zeros(steps)
inputs1 = np.zeros((steps,5))
trajectory1 = np.zeros((steps, 10))
t1 = np.arange(0, steps*dt, dt)
timed1 = np.zeros(steps)

c_roll = 2
d_roll = 80
rho_roll = 10
c_z = 2
d_z = 80
rho_z = 10

SMC_roll = SMC_controller(c_roll, d_roll, rho_roll, dt)
SMC_z = SMC_controller(c_z, d_z, rho_z, dt)

K_roll = 2*180/np.pi
Kp_roll = K_roll
Ki_roll = 0.05*K_roll
Kd_roll = 0.1*K_roll

K_z = -20
Kp_z = K_z
Ki_z = 0.05*K_z
Kd_z = 0.1*K_z

PID_roll = PID_controller(Kp_roll, Kd_roll, Ki_roll, 0, dt)
PID_z = PID_controller(Kp_z, Kd_z, Ki_z, 1.55, dt)

Kp_inner_p = 50
Kd_inner_p = Kp_inner_p*0.2
Ki_inner_p = Kp_inner_p*0.1

Kp_inner_V = -10
Kd_inner_V = Kp_inner_V*0.1
Ki_inner_V = Kp_inner_V*0.05

PID_inner_p = PID_controller(Kp_inner_p, Kd_inner_p, Ki_inner_p, 0, dt)
PID_inner_V = PID_controller(Kp_inner_V, Kd_inner_V, Ki_inner_V, 1.55, dt)
pderiv = median_filter(0, 10)
Vderiv = median_filter(0, 10)

t, trajectory, inputs, timed = simulate(0,1)
t, trajectory1, inputs1, timed1 = simulate(1,1)

print(sum(timed)/len(timed))
print(sum(timed1)/len(timed1))

#plot1(t, trajectory1, inputs1)
plot2(t, trajectory, trajectory1, inputs, inputs1)

