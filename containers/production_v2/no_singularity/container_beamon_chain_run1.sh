#!/bin/bash

# USAGE: ./container_beamon_chain_run1.sh <input file> <event num>

echo "First Statement"
date
echo "TIMESTAMP_T7 $(date +%s)"
  
# Check if files exist, if it does then we skip this process to run
export SINGULARITYENV_check_reco1=$(ls | grep reco1.root)
export SINGULARITYENV_check_cell=$(ls | grep postwcct.root)
export SINGULARITYENV_check_larcv=$(ls | grep postdl.root)
export SINGULARITYENV_check_bnm=$(ls | grep BNMS.root)
export SINGULARITYENV_check_r1a=$(ls | grep r1a.root)
export SINGULARITYENV_check_reco2=$(ls | grep reco2.root) 
export SINGULARITYENV_check_postreco2=$(ls | grep good.root)

# For some reason sinularity container doesnt work well with empty vars, so set to FileNotFound instead of checking empty (ugly, I know)
if [ -z $SINGULARITYENV_check_reco1 ]; then SINGULARITYENV_check_reco1="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_cell ]; then SINGULARITYENV_check_cell="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_larcv ]; then SINGULARITYENV_check_larcv="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_bnm ]; then SINGULARITYENV_check_bnm="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_r1a ]; then SINGULARITYENV_check_r1a="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_reco2 ]; then SINGULARITYENV_check_reco2="FileNotFound"; fi

# This is the last file, so if this exists, then we can exit the job without running anything
if [ -z $SINGULARITYENV_check_postreco2 ]; then 
  SINGULARITYENV_check_postreco2="FileNotFound";
else
  echo "The reco2 fcl file exists, so this job must have finished fine..."
  echo "exit 0"
  exit 0
fi

# Print the status of the files
echo
echo "Seeing which files exist in the directory, any files not found are listed as FileNotFound"
echo "Reco1 file: $SINGULARITYENV_check_reco1"
echo "Cell Tree file: $SINGULARITYENV_check_cell"
echo "BNM file: $SINGULARITYENV_check_bnm"
echo "Reco1a file: $SINGULARITYENV_check_r1a"
echo "Reco2 file: $SINGULARITYENV_check_reco2"
echo "LArCV file: $SINGULARITYENV_check_larcv"
echo "Post Reco2 file: $SINGULARITYENV_check_postreco2"

# This checks if we need to first setup uboonecode v01b, otherwise we skip to v27
export SINGULARITYENV_v01b="false"
if [ $SINGULARITYENV_check_reco1 == "FileNotFound" ] || [ $SINGULARITYENV_check_cell == "FileNotFound" ]; then
  SINGULARITYENV_v01b="true"
fi

echo
echo "Making custom fcl files with overrides"
# makes fcl file with _url_override.fcl extension

# reco1
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage1.fcl" mylist_v01b_timestamps.txt 

# celltree
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/run_celltreeub_prod.fcl" mylist_v01b_timestamps.txt 

# larcv
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/standard_larcv_uboone_data2d_prod.fcl" mylist_v27_timestamps.txt

# reco1a
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_mcc9_8_driver_data_numi_optical.fcl" mylist_v27_timestamps.txt

# reco2
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage2_beamOn_numi.fcl" mylist_v27_timestamps.txt

# postreco2
source /lus/theta-fs0/projects/uboone/containers/timestamp_to_fcl_v2.sh $2 "/lus/theta-fs0/projects/uboone/kmistry/fcl/postreco2/reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOn_run1_numi.fcl" mylist_v27_timestamps.txt

export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s

echo 
echo "Entered Container"
date
echo "TIMESTAMP_T7 $(date +%s)"
  
if [ $SINGULARITYENV_v01b == "true" ]; then
  source /lus/theta-fs0/projects/uboone/uboonecode/setup
  setup uboonecode v08_00_00_01b -q e17:prof
  unsetup libwda
  setup libwda v2_27_1
  echo "Starting LArSoft Job"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
fi
  
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_reco1 == "FileNotFound" ]; then 
  echo "lar -c reco_uboone_data_mcc9_8_driver_stage1_url_override.fcl -s $1 -n1 --nskip $2 -o %ifb_event$2_reco1.root"
  lar -c reco_uboone_data_mcc9_8_driver_stage1_url_override.fcl -s $1 -n1 --nskip $2 -o %ifb_event$2_reco1.root; 
fi
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_cell == "FileNotFound" ]; then
  echo "lar -c run_celltreeub_prod_url_override.fcl -s *reco1.root"
  lar -c run_celltreeub_prod_url_override.fcl -s *reco1.root
fi
echo "------------------------------------------------------------------------"
echo "Finished 01b, unsetting up v01b and setting up v27"
date
echo "TIMESTAMP_T7 $(date +%s)"
if [ $SINGULARITYENV_v01b == "true" ]; then unsetup_all; fi
source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
setup uboonecode v08_00_00_27 -q e17:prof
unsetup libwda
setup libwda v2_27_1
echo "Starting LArSoft Job part 2"
date
echo "TIMESTAMP_T7 $(date +%s)"
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_bnm == "FileNotFound" ]; then  
  echo "lar -c run_BurstNoiseMetricsFilter.fcl -s *postwcct.root"
  lar -c run_BurstNoiseMetricsFilter.fcl -s *postwcct.root
fi
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_r1a == "FileNotFound" ]; then  
  echo "lar -c reco_uboone_mcc9_8_driver_data_numi_optical_url_override.fcl -s *BNMS.root"
  lar -c reco_uboone_mcc9_8_driver_data_numi_optical_url_override.fcl -s *BNMS.root
fi
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_reco2 == "FileNotFound" ]; then
  echo "lar -c reco_uboone_data_mcc9_8_driver_stage2_beamOn_numi_url_override.fcl -s *r1a.root"
  lar -c reco_uboone_data_mcc9_8_driver_stage2_beamOn_numi_url_override.fcl -s *r1a.root
fi  
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_larcv == "FileNotFound" ]; then
  echo "lar -c standard_larcv_uboone_data2d_prod_url_override.fcl -s *reco2.root"  
  lar -c standard_larcv_uboone_data2d_prod_url_override.fcl -s *reco2.root
fi
echo "------------------------------------------------------------------------"
if [ $SINGULARITYENV_check_postreco2 == "FileNotFound" ]; then
  echo "lar -c reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOn_run1_numi_url_override.fcl  -s *postdl.root"
  lar -c reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOn_run1_numi_url_override.fcl  -s *postdl.root
fi
echo "------------------------------------------------------------------------"
echo "Finished Executing"
date
echo "TIMESTAMP_T7 $(date +%s)"

echo "Exited Container"
date
echo "TIMESTAMP_T7 $(date +%s)"

# See if the container finished with appropriate exit status
# Existance of a file ending in all.root means post reco2 ran properly
exit_status=$(ls | grep "good.root")

if [[ -z "$exit_status" ]]; then
  echo "The post reco2 file doesn't exit, so this job has FAILED..."
  echo "exit 1"
  exit 1
elif [[ -n "$exit_status" ]]; then
  echo "Found the post reco2 file, so this job has SUCCEEDED..."
  echo "Removing previous successful files from directory"
  echo "rm *reco2.root *r1a.root *BNMS.root *postdl.root *postwcct.root *reco1.root Pandora_Events.pndr"
  rm *reco2.root *r1a.root *BNMS.root *postdl.root *reco1.root *postwcct.root Pandora_Events.pndr
  echo "exit 0"
  exit 0
else
  echo "Eh?! Whats this exit status?"
  exit 2
fi

# -------------------------------------------------------------
# ------------------------ DONE! ------------------------------
# -------------------------------------------------------------
