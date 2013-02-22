# Run all the run_rw* files in ./boldsim/bin/*
date > run1.log

echo "Doing the runs..." >> run.log

basedir=/home/epete/src
echo $basdir >> run1.log
for f in $basedir/boldsim/bin/run_rw*
	do
		python $f 
		echo $f >> run1.log
	done

echo "Done." >> run1.log
date >> run1.log

# ----
echo "Doing tabulations now..." >> run.log

echo "tabulate1" >> run.log
$basedir/boldsim/bin/tabulate1.sh

echo "tabulate2" >> run.log
$basedir/boldsim/bin/tabulate2.sh

echo "tabulate3" >> run.log
$basedir/boldsim/bin/tabulate3.sh

echo "Done." >> run1.log
date >> run1.log
