#!/bin/bash
echo "First Statement"
date
echo "TIMESTAMP_T7 $(date +%s)"
export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
  
# Check if files exist, if it does then we skip this process to run
export SINGULARITYENV_check_reco1=$(ls | grep reco1.root)
export SINGULARITYENV_check_cell=$(ls | grep postwcct.root)
export SINGULARITYENV_check_larcv=$(ls | grep postdl.root)
export SINGULARITYENV_check_bnm=$(ls | grep BNMS.root)
export SINGULARITYENV_check_r1a=$(ls | grep r1a.root)
export SINGULARITYENV_check_reco2=$(ls | grep reco2.root) 
export SINGULARITYENV_check_postreco2=$(ls | grep reco2_all.root)

# For some reason sinularity container doesnt work well with empty vars, so set to FileNotFound instead of checking empty (ugly, I know)
if [ -z $SINGULARITYENV_check_reco1 ]; then SINGULARITYENV_check_reco1="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_cell ]; then SINGULARITYENV_check_cell="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_larcv ]; then SINGULARITYENV_check_larcv="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_bnm ]; then SINGULARITYENV_check_bnm="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_r1a ]; then SINGULARITYENV_check_r1a="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_reco2 ]; then SINGULARITYENV_check_reco2="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_postreco2 ]; then SINGULARITYENV_check_postreco2="FileNotFound"; fi

# Print the status of the files
echo
echo "Seeing which files exist in the directory, any files not found are listed as FileNotFound"
echo "Reco1 file: $SINGULARITYENV_check_reco1"
echo "Cell Tree file: $SINGULARITYENV_check_cell"
echo "LArCV file: $SINGULARITYENV_check_larcv"
echo "BNM file: $SINGULARITYENV_check_bnm"
echo "Reco1a file: $SINGULARITYENV_check_r1a"
echo "Reco2 file: $SINGULARITYENV_check_reco2"
echo "Post Reco2 file: $SINGULARITYENV_check_postreco2"

# This checks if we need to first setup uboonecode v01b, otherwise we skip to v27
export SINGULARITYENV_v01b="false"
if [ $SINGULARITYENV_check_reco1 == "FileNotFound" ] || [ $SINGULARITYENV_check_cell == "FileNotFound" ] || [ $SINGULARITYENV_check_larcv == "FileNotFound" ]; then
  SINGULARITYENV_v01b="true"
fi

sleep $[ ( $RANDOM % 10 )  + 1 ]s

echo
echo "Making custom fcl files with overrides"
# makes fcl file with _ts_override.fcl extension

# reco1
source /lus/theta-fs0/projects/uboone/containers/timestamp_in_fcl.sh $3 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage1.fcl"

# celltree
source /lus/theta-fs0/projects/uboone/containers/timestamp_in_fcl.sh $3 "/lus/theta-fs0/projects/uboone/kmistry/fcl/run_celltreeub_prod.fcl"

# larcv
source /lus/theta-fs0/projects/uboone/containers/timestamp_in_fcl.sh $3 "/lus/theta-fs0/projects/uboone/kmistry/fcl/standard_larcv_uboone_data2d_prod.fcl"

# reco1a
source /lus/theta-fs0/projects/uboone/containers/timestamp_in_fcl.sh $3 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_mcc9_8_driver_data_ext_numi_optical.fcl"

# reco2
source /lus/theta-fs0/projects/uboone/containers/timestamp_in_fcl.sh $3 "/lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage2_beamOff_numi.fcl"

# postreco2
source /lus/theta-fs0/projects/uboone/containers/timestamp_in_fcl.sh $3 "/lus/theta-fs0/projects/uboone/kmistry/fcl/postreco2/reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff_run1_numi.fcl"

singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  echo 
  echo "Entered Container"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  #export http_proxy=http://10.236.1.189:3128
  #export HTTP_PROXY=http://10.236.1.189:3128
  
  if [ $SINGULARITYENV_v01b == "true" ]; then
    source /lus/theta-fs0/projects/uboone/uboonecode/setup
    setup uboonecode v08_00_00_01b -q e17:prof
    echo "Starting LArSoft Job"
    date
    echo "TIMESTAMP_T7 $(date +%s)"
  fi
  
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_reco1 == "FileNotFound" ]; then 
    echo "lar -c reco_uboone_data_mcc9_8_driver_stage1_ts_override.fcl -s $1 -n1 --nskip $2 -o %ifb_event$2_reco1.root"
    lar -c reco_uboone_data_mcc9_8_driver_stage1_ts_override.fcl -s $1 -n1 --nskip $2 -o %ifb_event$2_reco1.root;
  fi
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_cell == "FileNotFound" ]; then
    echo "lar -c run_celltreeub_prod_ts_override.fcl -s *reco1.root"
    lar -c run_celltreeub_prod_ts_override.fcl -s *reco1.root
  fi
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_larcv == "FileNotFound" ]; then
    echo "lar -c standard_larcv_uboone_data2d_prod_ts_override.fcl -s *postwcct.root"  
    lar -c standard_larcv_uboone_data2d_prod_ts_override.fcl -s *postwcct.root
  fi
  echo "------------------------------------------------------------------------"
  echo "Finished 01b, unsetting up v01b and setting up v27"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  if [ $SINGULARITYENV_v01b == "true" ]; then unsetup_all; fi
  source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
  setup uboonecode v08_00_00_27 -q e17:prof
  echo "Starting LArSoft Job part 2"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_bnm == "FileNotFound" ]; then  
    echo "lar -c run_BurstNoiseMetricsFilter.fcl -s *postdl.root"
    lar -c run_BurstNoiseMetricsFilter.fcl -s *postdl.root
  fi
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_r1a == "FileNotFound" ]; then  
    echo "lar -c reco_uboone_mcc9_8_driver_data_ext_numi_optical_ts_override.fcl -s *BNMS.root"
    lar -c reco_uboone_mcc9_8_driver_data_ext_numi_optical_ts_override.fcl -s *BNMS.root
  fi
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_reco2 == "FileNotFound" ]; then
    echo "lar -c reco_uboone_data_mcc9_8_driver_stage2_beamOff_numi_ts_override.fcl -s *r1a.root"
    lar -c reco_uboone_data_mcc9_8_driver_stage2_beamOff_numi_ts_override.fcl -s *r1a.root
  fi  
  echo "------------------------------------------------------------------------"
  if [ $SINGULARITYENV_check_postreco2 == "FileNotFound" ]; then
    echo "lar -c reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff_run1_numi_ts_override.fcl  -s *reco2.root"
    lar -c reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff_run1_numi_ts_override.fcl  -s *reco2.root
  fi
  echo "------------------------------------------------------------------------"
  echo "Finished Executing"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
EOF

echo "Exited Container"
date
echo "TIMESTAMP_T7 $(date +%s)"

# See if the container finished with appropriate exit status
# Existance of a file ending in all.root means post reco2 ran properly
exit_status=$(ls | grep "all.root")

if [[ -z "$exit_status" ]]; then
  echo "exit 1"
  exit 1
elif [[ -n "$exit_status" ]]; then
  #echo "Removing previous successful files from directory"
  #echo "rm *reco2.root *r1a.root *BNMS.root *postdl.root *reco1.root"
  #rm *reco2.root *r1a.root *BNMS.root *postdl.root *reco1.root
  echo "exit 0"
  exit 0
fi

# -------------------------------------------------------------
# ------------------------ DONE! ------------------------------
# -------------------------------------------------------------
