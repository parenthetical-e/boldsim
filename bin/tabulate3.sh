# Run the tabulations for run1

# ----
# GLOBALS
BASEDIR=/home/epete/src
DATADIR=/data/data2/boldsim/data
## You will probably 
## need to change these


# ----
# Init logging
date > tabulate3.log
echo $BASEDIR >> tabulate3.log
echo $DATADIR >> tabulate3.log

echo "allnoise" >> tabulate3.log
python $BASEDIR/boldsim/bin/tabulate_compare.py t \
    $DATADIR/rw_5000_learn.hdf5 \
    $DATADIR/rw_5000_learn_white20.hdf5 \
    $DATADIR/rw_5000_learn_ar1.hdf5 \
    $DATADIR/rw_5000_learn_ar1a04.hdf5 \
    $DATADIR/rw_5000_learn_ar1a08.hdf5 \
    $DATADIR/rw_5000_learn_physio.hdf5 \
    $DATADIR/rw_5000_learn_lowfreq.hdf5 \
    allnoise

date >> tabulate3.log

