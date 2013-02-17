# Run all the run_rw* files in ./boldsim/bin/*
date > run.log

basedir=/home/epete/src
echo $basdir >> run.log
for f in $basedir/boldsim/bin/run_rw*
	do
		python $f 
		echo $f >> run.log
	done

echo "Done." >> run.log

date >> run.log

