from neuron import h, init, run
from BallAndStick import BallAndStick
import matplotlib.pyplot as plt

h.load_file('stdrun.hoc')

kind='adex'
my_cell = BallAndStick(0,kind)



h.PlotShape(False).plot(plt)