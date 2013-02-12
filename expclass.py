""" Model-based Exp classes used 'A precise problem with model-based fMRI.' """
import numpy as np
import rl
import simfMRI
import simBehave
from simfMRI.expclass import Exp
from simBehave.trials import event_random
from simfMRI.misc import process_prng


class RWfit(Exp):
    """
    Generate and fit behavioral data with a Rescorla-Wagner RL model.
    Use the RPE and values from these fits to run fMRI simulations with
    parameteric regressors.
    """
    def __init__(self, n, behave='learn', TR=2, ISI=2, prng=None):
        try: 
            Exp.__init__(self, TR=2, ISI=2, prng=None)
        except AttributeError: 
            pass
        
        self.prng = process_prng(prng)
        
        n_cond = 1
        n_trials_cond = n
        trials = []
        acc = []
        p = []
        if behave == 'learn':
    		trials, acc, p, self.prng = simBehave.behave.learn(
    				n_cond, n_trials_cond, 3, True, self.prng)
        elif behave == 'random':
    			trials, acc, p, self.prng = simBehave.behave.random(
                        n_cond,n_trials_cond, 3, self.prng)
        else:
            raise ValueError(
                    '{0} is not known.  Try learn or random.'.format(behave))
        
        # Find best RL learning parameters for the behavoiral data
        # then generate the final data and unpack it into a list.
        best_rl_pars, best_logL = rl.fit.ml_delta(acc, trials, 0.05)
        v_dict, rpe_dict = rl.reinforce.b_delta(acc, trials, best_rl_pars[0])
        values = rl.misc.unpack(v_dict, trials)
        rpes = rl.misc.unpack(rpe_dict, trials)
        
        # Store the results in appropriate places
        self.trials = np.array(trials)
        self.durations = np.array([1, ] * len(self.trials))
        self.data['acc'] = acc
        self.data['p'] = p
        self.data['best_logL'] = best_logL
        self.data['best_rl_pars'] = best_rl_pars
        self.data['value'] = values
        self.data['rpe'] = rpes
        self.data['rand'] = self.prng.rand(len(self.trials))


class RWset(Exp):
    """
    Generate and behavioral data then use <alpha> to create a Rescorla-Wagner
    model.  Use the RPE and values from these fits to run fMRI simulations 
    with parameteric regressors.
    """
    def __init__(self, n, alpha=0.5, behave='learn', TR=2, ISI=2, prng=None):
        try: 
            Exp.__init__(self, TR=2, ISI=2, prng=None)
        except AttributeError: 
            pass
        
        self.prng = process_prng(prng)
        
        n_cond = 1
        n_trials_cond = n
        trials = []
        acc = []
        p = []
        if behave == 'learn':
    		trials, acc, p, self.prng = simBehave.behave.learn(
    				n_cond, n_trials_cond, 3, True, self.prng)
        elif behave == 'random':
    			trials, acc, p, self.prng = simBehave.behave.random(
                        n_cond,n_trials_cond, 3, self.prng)
        else:
            raise ValueError(
                    '{0} is not known.  Try learn or random.'.format(behave))
        
        # Find best RL learning parameters for the behavoiral data
        # then generate the final data and unpack it into a list.
        v_dict, rpe_dict = rl.reinforce.b_delta(acc, trials, alpha)
        values = rl.misc.unpack(v_dict, trials)
        rpes = rl.misc.unpack(rpe_dict, trials)
        
        # Store the results in appropriate places
        self.trials = np.array(trials)
        self.durations = np.array([1, ] * len(self.trials))
        self.data['acc'] = acc
        self.data['p'] = p
        self.data['best_logL'] = best_logL
        self.data['best_rl_pars'] = (alpha, )
        self.data['value'] = values
        self.data['rpe'] = rpes
        self.data['rand'] = self.prng.rand(len(self.trials))

