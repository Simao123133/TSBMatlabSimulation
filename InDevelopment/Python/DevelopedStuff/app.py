from tkinter import *
from tkinter import messagebox
from threading import Thread
from queue import Queue
from ReadData import get_data
from tkinter import ttk
from PyQt5 import QtGui
import pyqtgraph as pg
import numpy as np
from numpy import linspace
from pyqtgraph.Qt import QtGui, QtCore
import pyqtgraph as pg
from pyqtgraph import MultiPlotWidget
try:
    from pyqtgraph.metaarray import *
except:
    print("MultiPlot is only used with MetaArray for now (and you do not have the metaarray package)")
    exit()


def start_graph():  
    global start
    start = 999

def comboclick(event):
    myLabel = Label(tkWindow, text=myCombo.get()).pack()

def threaded_function(arg):
    global tkWindow, myCombo

    tkWindow = Tk()  
    tkWindow.geometry('500x350')  
    open = Button(tkWindow,
	text = 'Submit',
	command = start_graph)  
    open.pack()  
    variable = StringVar(tkWindow)
    variable.set("one") # default value

    names = []
    for i in range(0,len(dataset.signal)):
        names.append(dataset.signal[i].name)

    myCombo = ttk.Combobox(tkWindow, value=names, width=35)
    myCombo.current(0)
    myCombo.bind("<<ComboboxSelected>>", comboclick)
    myCombo.pack()

    tkWindow.mainloop()
    tkWindow.title('PythonExamples.org - Tkinter Example')


dataset = get_data()
thread = Thread(target = threaded_function, args = (10, ))
thread.start()

app = pg.mkQApp("MultiPlot Widget Example")
mw = QtGui.QMainWindow()
mw.resize(800,800)
pw = MultiPlotWidget()
mw.setCentralWidget(pw)
mw.show()

data = np.random.normal(size=(3, 1000)) * np.array([[0.1], [1e-5], [1]])
ma = MetaArray(data, info=[
    {'name': 'Signal', 'cols': [
        {'name': 'Col1', 'units': 'V'}, 
        {'name': 'Col2', 'units': 'A'}, 
        {'name': 'Col3'},
        ]}, 
    {'name': 'Time', 'values': linspace(0., 1., 1000), 'units': 's'}
    ])
pw.plot(ma, pen='y')

if __name__ == '__main__':
    pg.exec()



