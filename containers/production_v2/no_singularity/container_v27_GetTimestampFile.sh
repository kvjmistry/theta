#!/bin/bash

# Container to run the get timestamp module fir database queries
# USAGE: ./container_v27_GetTimestampFile.sh <input file> 

echo "First Statement"
date

# Check if files exist, if it does then we skip this process to run
export SINGULARITYENV_check_mylist=$(ls | grep analysisOutput.root) # This is the output from marina's Module
export SINGULARITYENV_check_timstampfile=$(ls | grep timestamps.txt)

# For some reason sinularity container doesnt work well with empty vars, so set to FileNotFound instead of checking empty (ugly, I know)
if [ -z $SINGULARITYENV_check_mylist ]; then SINGULARITYENV_check_mylist="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_timstampfile ]; then SINGULARITYENV_check_timstampfile="FileNotFound"; fi

# Print the status of the files
echo
echo "Seeing which files exist in the directory, any files not found are listed as FileNotFound"
echo "TimeStamp file: $SINGULARITYENV_check_mylist"
echo "Timestamp file: $SINGULARITYENV_check_timstampfile"

exit_status=$(ls | grep "v27_timestamps.txt")

if [[ -n "$exit_status" ]]; then
  echo "Time stamp file already exists, so finish!"
  echo "exit 0"
  exit 0
fi


echo 
date

start_time=`date +%s`
echo "lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/split_events.fcl -s $1"
lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/split_events.fcl -s $1
echo "Run time of splitting: $(expr `date +%s` - $start_time) s"

echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_mylist == "FileNotFound" ]; then
  start_time=`date +%s`
  echo "lar -c run_analyseEvents.fcl -s $1"
  lar -c run_analyseEvents.fcl -s $1
  echo "Run time of timestamp: $(expr `date +%s` - $start_time) s"
fi
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_timstampfile == "FileNotFound" ]; then 
  echo "Generating timestamp file"
  touch mylist.txt
  echo "Lets see whats in the timestamp list..."
  echo "cat mylist.txt"
  cat mylist.txt
  python /lus/theta-fs0/projects/uboone/containers/get_timestamps_v2.py mylist.txt v01b
  python /lus/theta-fs0/projects/uboone/containers/get_timestamps_v2.py mylist.txt v27
fi
echo "------------------------------------------------------------------------"
echo "Finished Executing"
date

# See if the container finished with appropriate exit status
# Existance of a file ending in all.root means post reco2 ran properly
exit_status=$(ls | grep "v27_timestamps.txt")

if [[ -z "$exit_status" ]]; then
  echo "exit 1"
  exit 1
elif [[ -n "$exit_status" ]]; then
  echo "exit 0"
  exit 0
fi


# -------------------------------------------------------------
# ------------------------ DONE! ------------------------------
# -------------------------------------------------------------
