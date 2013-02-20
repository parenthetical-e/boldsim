# Run the tabulations for run1

# ----
# GLOBALS
BASEDIR=/home/epete/src
DATADIR=/data/data2/boldsim/data
	## You will probably 
	## need to change these


# ----
# Init logging
date > tabulate1.log
echo $BASEDIR >> tabulate1.log
echo $DATADIR >> tabulate1.log


# ----
# The precision analyses:
echo "rw_5000_learn.hdf5 t 2.6810" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn.hdf5 t 2.6810 rw_5000_learn
echo "rw_5000_learn.hdf5 t 4.317" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn.hdf5 t 4.317 rw_5000_learn

echo "rw_5000_random.hdf5 t 2.6810" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_random.hdf5 t 2.6810 rw_5000_random
echo "rw_5000_random.hdf5 t 4.317" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_random.hdf5 t 4.317 rw_5000_random

echo "rw_5000_learn_orth.hdf5 t 2.6810" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn_orth.hdf5 t 2.6810 rw_5000_learn_orth
echo "rw_5000_learn_orth.hdf5 t 4.317" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn_orth.hdf5 t 4.317 rw_5000_learn_orth

echo "rw_5000_learn_2alpha.hdf5 t 2.6810" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn_2alpha.hdf5 t 2.6810 rw_5000_learn_2alpha
echo "rw_5000_learn_2alpha.hdf5 t 4.317" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn_2alpha.hdf5 t 4.317 rw_5000_learn_2alpha


# ----
# The noise analyses
echo "ar1" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_compare.py t $DATADIR/rw_5000_learn.hdf5 $DATADIR/rw_5000_learn_ar1.hdf5 $DATADIR/rw_5000_learn_ar1a04.hdf5 $DATADIR/rw_5000_learn_ar1a08.hdf5 ar1

echo "physio" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_compare.py t $DATADIR/rw_5000_learn.hdf5 $DATADIR/rw_5000_learn_physio.hdf5 physio

echo "lowfreq" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_compare.py t $DATADIR/rw_5000_learn.hdf5 $DATADIR/rw_5000_learn_lowfreq.hdf5 lowfreq

echo "white" >> tabulate1.log
python $BASEDIR/boldsim/bin/tabulate_compare.py t $DATADIR/rw_5000_learn.hdf5 white $DATADIR/rw_5000_learn_white20.hdf5 white

# The end
date >> tabulate1.log
