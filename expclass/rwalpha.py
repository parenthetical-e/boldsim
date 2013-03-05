""" Model-based Exp classes used "A precise problem with model-based fMRI." """
import numpy as np
import rl
import simfMRI
import simBehave
from functools import partial
from simBehave.trials import event_random
from simfMRI.expclass import Exp
from simfMRI.misc import process_prng
from simfMRI.noise import ar1, physio, shift


class RWalpha(Exp):
    """
    Generate and fit behavioral data with a Rescorla-Wagner RL model.
    Use the RPE and values from these fits to run fMRI simulations with
    parameteric regressors.
    """
    def __init__(self, n, alphas, TR=2, ISI=2, prng=None):
        try: 
            Exp.__init__(self, TR=2, ISI=2, prng=None)
        except AttributeError: 
            pass
        
        self.prng = process_prng(prng)
        
        # Simulate a learning task and acc.
        ncond = 1
        trials, acc, p, self.prng = simBehave.behave.learn(
                ncond, n, 3, True, self.prng)
        
        # And hand the results off of self
        self.trials = np.array(trials)
        self.durations = np.array([1, ] * n)
        
        # Or add them to the data attr
        self.data["ncond"] = ncond
        self.data["acc"] = acc
        self.data["p"] = p
        
        # Run the RL sim, and save the results keying (partly)
        # off of alpha an alpha counter
        for ii, alpha in enumerate(alphas):
            v_dict, rpe_dict = rl.reinforce.b_delta(acc, trials, alpha)
            values = rl.misc.unpack(v_dict, trials)
            rpes = rl.misc.unpack(rpe_dict, trials)
            
            self.data["value"+str(ii)] = values
            self.data["rpe"+str(ii)] = rpes

        self.data["alphas"] = alphas

        # Create random data too.
        self.data["rand"] = self.prng.rand(n)


