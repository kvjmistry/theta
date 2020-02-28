#!/bin/bash

# USAGE: ./container_beamon_chain_run1_reco1.sh <input file> <event num>

echo "First Statement"
date
  
# Check if files exist, if it does then we skip this process to run
export SINGULARITYENV_check_reco1=$(ls | grep reco1.root)
export SINGULARITYENV_check_cell=$(ls | grep postwcct.root)

# For some reason sinularity container doesnt work well with empty vars, so set to FileNotFound instead of checking empty (ugly, I know)
if [ -z $SINGULARITYENV_check_reco1 ]; then SINGULARITYENV_check_reco1="FileNotFound"; fi

# This is the last file, so if this exists, then we can exit the job without running anything
if [ -z $SINGULARITYENV_check_cell ]; then
  SINGULARITYENV_check_cell="FileNotFound";
else
  echo "The celltree fcl file exists, so this job must have finished fine..."
  echo "exit 0"
  exit 0
fi

# Print the status of the files
echo
echo "Seeing which files exist in the directory, any files not found are listed as FileNotFound"
echo "Reco1 file: $SINGULARITYENV_check_reco1"
echo "Cell Tree file: $SINGULARITYENV_check_cell"

echo
echo "Making custom fcl files with overrides"


# reco1
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage1.fcl" mylist_v01b_timestamps.txt 

# celltree
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/run_celltreeub_prod.fcl" mylist_v01b_timestamps.txt 

echo 
date

# Add 1 to the event since the file names are shifted
event=$(($2+1))

# Change the input file name to the event in question
inputfile=$1
inputfile=${inputfile%.root}
inputfile=${inputfile}_event${event}.root

echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_reco1 == "FileNotFound" ]; then 
  echo "lar -c reco_uboone_data_mcc9_8_driver_stage1_url_override.fcl -s $inputfile -o %ifb_reco1.root"
  lar -c reco_uboone_data_mcc9_8_driver_stage1_url_override.fcl -s $inputfile -o %ifb_reco1.root
fi
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_cell == "FileNotFound" ]; then
  echo "lar -c run_celltreeub_prod_url_override.fcl -s *reco1.root"
  lar -c run_celltreeub_prod_url_override.fcl -s *reco1.root
fi
echo "------------------------------------------------------------------------"
echo "Finished 01b chain"
date

# See if the container finished with appropriate exit status
# Existance of a file ending in all.root means post reco2 ran properly
exit_status=$(ls | grep "postwcct.root")

if [[ -z "$exit_status" ]]; then
  echo "The celltree file doesn't exit, so this job has FAILED..."
  echo "exit 1"
  exit 1
elif [[ -n "$exit_status" ]]; then
  echo "Found the celtree file, so this job has SUCCEEDED..."
  echo "Removing previous successful files from directory"
  echo "rm $(realpath $inputfile)"
  rm $(realpath $inputfile)
  echo "rm *reco1.root TFile* RootOutput*"
  rm *reco1.root TFile* RootOutput*
  echo "exit 0"
  exit 0
else
  echo "Eh?! Whats this exit status?"
  exit 2
fi

# -------------------------------------------------------------
# ------------------------ DONE! ------------------------------
# -------------------------------------------------------------
