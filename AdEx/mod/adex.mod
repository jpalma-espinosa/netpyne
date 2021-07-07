COMMENT

Point process implementation of the AdEx neuron.
Equations and parameter values are taken from
Brette, R., & Gerstner, W. (2005). Adaptive exponential integrate-and-fire model 
as an effective description of neuronal activity. 
Journal of neurophysiology, 94(5), 3637-3642.


TODO: define this example usage
Example usage (in Python):
  from neuron import h
  sec = h.Section(name=sec) # section will be used to calculate v
  izh = h.Izhi2007b(0.5)
  def initiz () : sec.v=-60
  fih=h.FInitializeHandler(initz)
  izh.Iin = 70  # current clamp

Cell types available are based on Naud et al.,Biol Cybern(2008):
    1.
    2.
    3.
    4.
    5.
    6.
    7.
    8.
    9.
    10.
    11.

This model is an adaptation from the work done by Cliff Kerr (http://thekerrlab.com), June 2019.
Enhancement done by Javier Palma-Espinosa (https://github.com/jpalma-espinosa), June 2021.

ENDCOMMENT

: Declare name of object and variables
NEURON {
    ARTIFICIAL_CELL AdEx
    GLOBAL gl, deltaT, tau_w, a, b, E_l, I_ext, C, V_reset, V_thre
    GLOBAL celltype
    ELECTRODE_CURRENT i
}

UNITS {
	(mV) = (millivolt)
	(pA) = (picoamp)
	(uS) = (microsiemens)
    (nS) = (nanosiemens)
	(pS) = (picosiemens)
    (pF) = (picofarads)
}

: Parameters for tonic spiking cell. See cell types in the comments above
PARAMETER {
	cellid = -1  				:Cell ID
	V_reset = -58	(mV)		:reset potential after spike
	V_thre = -50	(mV)		:threshold for spike detection
	V_spike = 0  	(mV)	    :value of spike
	a = 2			(nS)		:coupling with adaptive variable
	b = 0   		(pA)		:adaptive increment
	tau_w = 30		(ms)		:adaptive time costant
	E_l = -70		(mV)		:resting potential for leak term
	gl  = 10		(nS)	    :leak conductance
	deltaT = 2		(mV)	    :speed of exp
    C = 200         (pF)        :cell Capacitance
    label=0                     : assign an arbitrary label to the cell
    celltype = 1                : A flag for indicating what kind of cell it is.
    
}


: state variables. vv is the voltage and ww is the adaptation variable
STATE {
    vv              (mV)
    ww              (pA)
}

:initializion and activation of the process
INITIAL { 
    ww=0            (pA)
    vv=-60          (mV)
}


:solve the system
DERIVATIVE states { 
    vv'=(1/C)*(-gl*(vv-E_l)+gl*deltaT*exp((vv-V_thre)/deltaT)-i - ww)
    ww' = (1/tau_w)*(a*(vv-E_l)-ww)
    :i = vv'
}
: Input received
:    NET_RECEIVE (w) {
:        : Check if spike occurred
:        if (flag == 1) { :wait for membrane potential to reach threshold
:            WATCH (vv > V_spike) 2
:        } else if (flag == 2) {:threshold reached, fire and reset the model
:            net_event(t)
:            vv = V_reset
:            ww = ww+b
:        }
:    }