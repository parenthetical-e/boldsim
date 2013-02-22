""" A top-level experimental script that run 100 iterations (on 2 cores) of 
the RW example (see simfMRI.exp_examples.RW()). """
import functools
from simfMRI.analysis.plot import hist_t_all_models
from simfMRI.runclass import Run
from boldsim.expclass.rwfit import RWlowfreq


class RunRWlowfreq(Run):
    """ An example of a 100 iteration RW experimental Run(). """
    
    def __init__(self):
        try: 
            Run.__init__(self)
        except AttributeError: 
            pass
        
        # ----
        # An instance of simfMRI.examples.* Class (or similar) 
        # should go here.
        self.BaseClass = functools.partial(RWlowfreq, behave="learn")  
            ## Nornalize the signature of BaseClass with 
            ## functools.partial
            ## Expects:
            ## BaseClass(self.ntrial, TR=self.TR, ISI=self.ISI, prng=prng)
        
        # ----
        # User Globals
        self.nrun = 5000
        self.TR = 2
        self.ISI = 2
        self.model_conf = "rw_orth.ini"
        self.savedir = "data"
        self.ntrial = 60
        
        # --
        # Optional Globals
        self.ncore = 10
    
        # ----
        # Misc
        self.prngs = None   ## A list of RandomState() instances
                            ## setup by the go() attr


if __name__ == "__main__":
    sim = RunRWlowfreq()
    sim.go(parallel=True)
        ## Results get stored internally.

    # Writing the results to a hdf5    
    results_name = "rw_{0}_learn_lowfreq".format(sim.nrun)
    sim.save_results(results_name)

    # And plot all the models 
    # (each is autosaved).
    hist_t_all_models(sim.savedir, results_name+".hdf5", results_name)
    
