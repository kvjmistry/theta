#!/bin/bash

# This script will compare the files in a sam def and a directory and see what files are extra in the directory

path="/projects/uboone/NuMI_Data/run1/beamon/prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns/"
inlist="/projects/uboone/kmistry/filelists/prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns_mcc9_FileNames.list"

for file in $(ls $path)
do
	found=$(grep -i $file $inlist)
	#echo $file

	if [ -z $found ]; then
		found=""
	else
		echo $file
	fi
done
