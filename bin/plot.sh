# Things to make plots for...
# This will eventually make a lot of plots

# [bar] For average (w/se) comparing to white=1, for each model, stat:
# 	set1: ar, ar4, ar8
# 	set2: white05 white20
# 	set3: physio
# 	set4: orth

# [bar] For criterion, comparing to white=1, for each model, stat:
# 	set1: ar, ar4, ar8
# 	set2: white05 white20
# 	set3: physio
# 	set4: orth

date > run.log
basedir=/home/epete/src/boldsim/bin
echo $basdir >> run.log
for f in $basedir/boldsim/bin/plot_rw*
	do
		python $f
		echo $f >> run.log
	done

echo "Done." >> run.log

date >> run.log

