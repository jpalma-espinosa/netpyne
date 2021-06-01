# Notes on AdEx implementation for Netpyne

## 1. Previous work. 
[The Kerr Lab](https://github.com/thekerrlab/netpyne/blob/add-adexp-example/doc/source/code/adExp.py) implemented a previous version.  The basic idea here was to implement an AdEx Class.  However, in a netpyne tutorial using izhikevic neurons, they implemented by compiling an izhikevic mod file.

   __Should netpyne provide a basic NEURON models, such as AdEx, izhikevic, integrate and fire?__

   __Do NEURON provide those models?__


## 2. What I am going to do?
Apparently, there is no current AdEx.mod implemented in NEURON (at least, forum does not show this). I will first replicate the AdEx.mod file/model
