from neuron import h
class BallAndStick:
    # @TODO: docstring
    def _setup_morphology(self):
        self.soma = h.Section(name='soma', cell=self)
        self.dend = h.Section(name='dend', cell=self)
        self.all = [self.soma, self.dend]
        self.dend.connect(self.soma)
        self.soma.L = self.soma.diam = 12.6157
        self.dend.L = 200
        self.dend.diam = 1
    def _setup_biophysics(self,kind):
        for sec in self.all:
            sec.Ra = 100    # Axial resistance in Ohm * cm
            sec.cm = 1      # Membrane capacitance in micro Farads / cm^2
        if(kind=='adex'):
            self.soma.insert(h.AdEx)
        if(kind=='hh'):
            self.soma.insert('hh')                                          
            for seg in self.soma:
                seg.hh.gnabar = 0.12  # Sodium conductance in S/cm2
                seg.hh.gkbar = 0.036  # Potassium conductance in S/cm2
                seg.hh.gl = 0.0003    # Leak conductance in S/cm2
                seg.hh.el = -54.3     # Reversal potential in mV
            # Insert passive current in the dendrite                       # <-- NEW
            self.dend.insert('pas')                                        # <-- NEW
            for seg in self.dend:                                          # <-- NEW
                seg.pas.g = 0.001  # Passive conductance in S/cm2          # <-- NEW
                seg.pas.e = -65    # Leak reversal potential mV            # <-- NEW 
    def __repr__(self):
        return 'BallAndStick[{}]'.format(self._gid)
    def __init__(self, gid,kind):
        self._gid = gid
        self._setup_morphology()
        self._setup_biophysics(kind)
