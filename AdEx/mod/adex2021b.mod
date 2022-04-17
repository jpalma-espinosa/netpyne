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
    adex = h.Adex2021b(0.5)
    def initiz () : sec.v=-60
    fih=h.FInitializeHandler(initz)
    adex.I_ext = 70  # current clamp

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
    POINT_PROCESS Adex2021b
    RANGE gl, deltaT, tau_w, a, b, E_l, I_ext, C, V_reset, V_thre
    GLOBAL celltype,flag
    NONSPECIFIC_CURRENT i
}

UNITS {
	(mV) = (millivolt)
	(pA) = (picoamp)
	(uS) = (microsiemens)
    (nS) = (nanosiemens)
	(pS) = (picosiemens)
    (pF) = (picofarads)
}

:initializion and activation of the process
INITIAL { 
    k=0            (pA) : adaptation variable
    v=-60          (mV)
    flag = 1
    net_send(0,1)
}

: Parameters for tonic spiking cell. See cell types in the comments above
PARAMETER {
	cellid = -1  				:Cell ID
	V_reset = -58	(mV)		:reset potential after spike
	V_thre = -10	(mV)		:threshold for spike detection
	V_spike = 0  	(mV)	    :value of spike
	a = 2			(nS)		:coupling with adaptive variable
	b = 0   		(pA)		:adaptive increment
	tau_k = 30		(ms)		:adaptive time costant
	E_l = -70		(mV)		:resting potential for leak term
	gl  = 10		(nS)	    :leak conductance
	deltaT = 2		(mV)	    :speed of exp
    C = 200         (pF)        :cell Capacitance
    label=0                     :assign an arbitrary label to the cell
    celltype = 1                :A flag for indicating what kind of cell it is.
    flag = 0
    I_ext = 1 (nA)              :Current Clamp
}

ASSIGNED {
    v (mV)
    i (nA)
}

: state variables. w is the adaptation variable
STATE {
    k             (pA)
}

BREAKPOINT{ 
    SOLVE states METHOD cnexp
    i =(-gl*(v-E_l)+gl*deltaT*exp((v-V_thre)/deltaT)-I_ext - k)
    :printf("%f",i)
}

:solve the system
DERIVATIVE states { 
    k' = (1/tau_k)*(a*(v-E_l)-k)
}

: Input received
NET_RECEIVE (w) {
  : Check if spike occurred
  if (flag == 1){ 
      : Fake event from INITIAL block. 
      : If voltage crossed threshold, then flag ==2
      WATCH (v>V_thre) 2 
  }
  :v = V_reset  : initialization can be done here
  
  if (flag == 2){
    : Send spike event 
      net_event(t)
      v = V_spike : I have to "draw" the spike
      :now recovery
      v = V_reset
      k = k + b
  }
}