""" Base classes for model-based fMRI simulations. """
import numpy as np
import rl
import simfMRI
import simBehave
from simfMRI.template import Exp
from simBehave.trials import event_random


class RWfit(Exp):
    """
    Generate and fit behavioral data with a Rescorla-Wagner RL model.
    Use the RPE and values from these fits to run fMRI simulations with
    parameteric regressors.
    
    Input:
    ----
    n: number of trials
    behave: kind of behavior to simulate (random or learn).
    TR: the sampling rate
    ISI: inter-stimulus interval
    """
    
    def __init__(self, n, behave='learn', TR=2, ISI=2):
        Exp.__init__(self, TR=2, ISI=2)

        n_cond = 1
        n_trials_cond = n
        trials = []
        acc = []
        p = []
        if behave is 'learn':
    		trials, acc, p = simBehave.behave.learn(
    				n_cond, n_trials_cond, 3, True)
        elif behave is 'random':
    			trials,acc,p = simBehave.behave.random(
                        n_cond,n_trials_cond,3,True)
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
        self.data['rand'] = np.random.random(len(self.trials))


class RWset(Exp):
    """ Generate and fit behavioral data with a Rescorla-Wagner RL model,
    using a given learning rate. 
    
    Input:
    ----
    n: number of trials
    behave: kind of behavior to simulate (random or learn).
    TR: the sampling rate
    ISI: inter-stimulus interval
    alpha: the learning rate
    
    Use the RPE and values from these fits to run fMRI simulations with
    parametric regressors. """
    
    def __init__(self, n, behave='learn', TR=2, ISI=2, alpha=0.5):
        Exp.__init__(self, TR=2, ISI=2, alpha=0.5)

        n_cond = 1
        n_trials_cond = n
        trials = []
        acc = []
        p = []
        if behave is 'learn':
    		trials, acc, p = simBehave.behave.learn(
                        n_cond, n_trials_cond, 3, True)
        elif behave is 'random':
    			trials, acc, p = simBehave.behave.random(
                        n_cond,n_trials_cond, 3, True)
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
        self.durations = np.array([1, ] * len(self.trials)) ## Durations are 1
        self.data['acc'] = acc
        self.data['p'] = p
        self.data['best_rl_pars'] = (alpha, )
        self.data['value'] = values
        self.data['rpe'] = rpes
        self.data['rand'] = np.random.random(len(self.trials))

