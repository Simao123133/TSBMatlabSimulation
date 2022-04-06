import numpy as np
import scipy.io
from scipy.io import loadmat 
import matplotlib.pyplot as plt
import pprint   
from tabulate import tabulate
import pyqtgraph.examples
import pyqtgraph as pg

class time_value_pair(object):

    def __init__(self, name, info):

        self.name = name
        self.time = info[0][:]
        self.value = info[1][:]

    def update(self, info):

        self.time = info[0][:]
        self.value = info[1][:]

class all_data(object):

    def __init__(self, data):

        variables_raw = data.keys()
        variables = list(variables_raw)
        self.signal = []

        for i in range(0, len(variables)):
            if variables[i] != '__header__' and variables[i] != '__version__' and variables[i] != '__globals__' and variables[i] != 'header':
                self.signal.append(get_signal(variables[i], data))
        

def convert_signals(data):
    variables_raw = data.keys()
    variables = list(variables_raw)

def get_signal(signal, data):

    variables_raw = data.keys()
    variables = list(variables_raw)

    signal_list = list(filter(lambda x: signal in x, variables))

    if (len(signal_list) == 0):
        print("Signal named '", signal,"' not found")
        return 0
    elif (len(signal_list) > 1):
        print("More than one '",signal,"' found, choose one and repeat")
        pprint.pprint(signal_list)
        return 0

    time = data[signal_list[0]]['time'][0][0][:,0]
    value = data[signal_list[0]]['signals'][0][0][:,0][0][0][:,0]

    return time_value_pair(signal, [time, value])

def get_data(file):

    data = loadmat(file)
    dataset = all_data(data)
    
    return dataset

data = loadmat('/home/simao/Desktop/TSB/Python/DevelopedStuff/data.mat')

roll = get_signal('_roll_', data)
pitch = get_signal('_pitch', data)
yaw = get_signal('_yaw_', data)

gyrX = get_signal('_gyrX_', data)
gyrY = get_signal('_gyrY_', data)
gyrZ = get_signal('_gyrZ_', data)

velX = get_signal('_velX_', data)
velY = get_signal('_velY_', data)
velZ = get_signal('_velZ_', data)

dataset = all_data(data)






