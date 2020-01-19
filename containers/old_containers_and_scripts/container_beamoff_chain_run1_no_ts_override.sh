#!/bin/bash
echo "First Statement"
date
echo "TIMESTAMP_T7 $(date +%s)"
export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s
singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  echo "Entered Container"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  #export http_proxy=http://10.236.1.189:3128
  #export HTTP_PROXY=http://10.236.1.189:3128
  source /lus/theta-fs0/projects/uboone/uboonecode/setup
  setup uboonecode v08_00_00_01b -q e17:prof
  echo "Starting LArSoft Job"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  echo "------------------------------------------------------------------------"
  lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage1.fcl -s $1 -n1 --nskip $2 -o %ifb_event$2_reco1.root
  echo "------------------------------------------------------------------------"
  lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/run_celltreeub_prod.fcl -s *reco1.root
  echo "------------------------------------------------------------------------"
  lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/standard_larcv_uboone_data2d_prod.fcl -s *postwcct.root
  echo "------------------------------------------------------------------------"
  echo "Finished 01b, unsetting up v01b and setting up v27"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  unsetup_all
  source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
  setup uboonecode v08_00_00_27 -q e17:prof
  echo "Starting LArSoft Job part 2"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  echo "------------------------------------------------------------------------"
  lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_mcc9_8_driver_data_ext_numi_optical.fcl -s *postdl.root
  echo "------------------------------------------------------------------------"
  lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/reco_uboone_data_mcc9_8_driver_stage2_beamOff_numi.fcl -s *r1a.root
  echo "------------------------------------------------------------------------"
  lar -c /lus/theta-fs0/projects/uboone/kmistry/fcl/postreco2/reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff_run1_numi.fcl  -s *reco2.root
  echo "------------------------------------------------------------------------"
  echo "Finished Executing"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
EOF

echo "Exited Container"
date
echo "TIMESTAMP_T7 $(date +%s)"
