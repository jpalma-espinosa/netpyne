from neuron import h
sec = h.Section(name='soma') # section will be used to calculate v
adex = h.Adex2021b(0.5)
def initiz (): 
    sec.v=-60

fih=h.FInitializeHandler(initiz)
adex.I_ext = 70  # current clamp