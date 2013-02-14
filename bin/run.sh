# Run (nearly) all the run_* files in ./boldsim/bin/*
basedir=/Users/type/Code
echo $basdir > run.log
for f in $basedir/boldsim/bin/run_rw*
	do
		python $f 
		echo $f >> run.log
	done

echo "Done." >> run.log
