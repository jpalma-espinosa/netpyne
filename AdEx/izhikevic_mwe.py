from neuron import h
sec = h.Section(name='soma') # section will be used to calculate v
izh = h.Izhi2007b(0.5)
def initiz () : sec.v=-60
fih=h.FInitializeHandler(initz)
izh.Iin = 70  # current clamp