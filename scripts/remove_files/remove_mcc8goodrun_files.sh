#!/bin/bash

# This script will remove the files that did not pass the mcc9 good runs but passed the mcc8 goodruns such that they were copied to theta.

# To run do source remove_mcc8goodrun_files.sh <the corresponding list>

filelist=$1
filepath="/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamoff/prod_extnumi_swizzle_inclusive_v3_tmnt_stride2_offset0_goodruns/"

# loop over filelist
for file in `cat $filelist` 
do
	command="rm $filepath$file"
	echo $command
	eval $command
done
