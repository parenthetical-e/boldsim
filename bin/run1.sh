# Run all the run_rw* files in ./boldsim/bin/*
date > run1.log

basedir=/home/epete/src
echo $basdir >> run1.log
for f in $basedir/boldsim/bin/run_rw*
	do
		python $f 
		echo $f >> run1.log
	done

echo "Done." >> run1.log

date >> run1.log

