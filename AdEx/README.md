# Notes on AdEx implementation for Netpyne

## 1. Previous work. 
[The Kerr Lab](https://github.com/thekerrlab/netpyne/blob/add-adexp-example/doc/source/code/adExp.py) implemented a previous version of the AdEx model.  The basic idea here was to implement an AdEx Class.  However, in a netpyne tutorial using izhikevic neurons, they implemented by compiling an izhikevic mod file.

   __Should netpyne provide a basic NEURON models, such as AdEx, izhikevic, integrate and fire?__

   __Do NEURON provide those models?__


## 2. What I am going to do?
 Apparently, there is no current [AdEx.mod implemented in NEURON](https://senselab.med.yale.edu/modeldb/ShowModel?model=147141). I will first replicate the AdEx.mod file/model based on what Kerr Lab did previously.
To achieve this goal, the tasks will be:
- ~~[ ] Implement and analyze AdEx model implemented in neuron (.mod) (Sprint 1)~~
- [ ] Analyze AdEx model implemented in neuron (.mod) (Sprint 1)
- [ ] Re-Implement AdEx model in NEURON (Adex.mod) (Sprint 2)
- [ ] Replicate the Izhikevic tutorial, but now incorporating the AdEx model ~~(Sprint 2)~~(Sprint 3).
- [ ] Replicate figures from [Naud et al. ](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2798047/) ~~(Sprint 3)~~(Sprint 4).
- [ ] Write AdEx tutorial and test it for publication on the website ~~(Sprint 4)~~(Sprint 5).

**KPI: AdEx working on Netpyne**        

## Update Jun 7th, 2021     
 I was able to run the [izhikevic tutorial](http://www.netpyne.org/tutorial.html#tutorial-4-using-a-simplified-cell-model-izhikevich).  Also, I wrote the Adex.mod file, by replicating what was done with [izhi2007b.mod](http://www.netpyne.org/_downloads/803a7312bae028b7a24ba7f3e28de705/izhi2007b.mod).  However, I am still not able to produce a spike in the Adex model.  The izhikevic one has some strange way of calculating the derivative states.  What is the difference between those two forms of calculation?  Also, how can I incorporate the synapses in the Adex neuron?      
   
The izhikevic (and adex) is implemented as a POINT PROCESS (see also [NEURON documentation](https://www.neuron.yale.edu/neuron/static/py_doc/modelspec/programmatic/mechanisms/nmodl.html)), contrary to the HH model.     

## Update Jun 30th, 2021    
I was on halt because I had to deal with my master thesis. I am now a Master of Science :D.     

Because the previous implementation wasn't sucessful, I asked wheter AdEx should be defined as a mechanism or a point neuron (see De Schutter book, Ch. 7).
The way that NEURON is implemented, makes logical to define AdEx as a point process and define it as ARTIFICIAL_CELL.  To do this, I have to understand how ```NET_RECEIVE(w)``` process works.      

This code block is better defined in the Neuron Book (Ch. 10)  

## Update Jul 6th, 2021  
I only read a couple of documents from [Neuron tutorial](https://www.neuron.yale.edu/neuron/static/new_doc/modelspec/programmatic/mechanisms/nmodl2.html) and from a [MIT tutorial on Neuron](http://web.mit.edu/neuron_v7.4/nrntuthtml/tutorial/tutD.html). The important part here was to examinate how to properly define the puntual neuron AdEx.  It seems that my model needs to considerate an external current _FROM_ an external point mechanism.  For this, I will need to re-study the [integrate and fire model](https://github.com/neuronsimulator/nrn/blob/master/src/nrnoc/intfire2.mod) that is proposed in the [Neuron Github page](https://github.com/neuronsimulator)