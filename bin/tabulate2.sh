

BASEDIR=/home/epete/src
DATADIR=/data/data2/boldsim/data
    ## You will probably 
        ## need to change these


# ----
# Init logging
date > tabulate2.log
echo $BASEDIR >> tabulate2.log
echo $DATADIR >> tabulate2.log

echo "rw_5000_learn_nobox.hdf5 t 2.6810" >> tabulate2.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn_nobox.hdf5 t 2.6810 rw_5000_learn_nobox
echo "rw_5000_learn_nobox.hdf5 t 4.317" >> tabulate2.log
python $BASEDIR/boldsim/bin/tabulate_above.py $DATADIR/rw_5000_learn_nobox.hdf5 t 4.317 rw_5000_learn_nobox
