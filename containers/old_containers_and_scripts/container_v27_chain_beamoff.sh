#!/bin/bash

# This script will merge the art root files which have been split up for processing

export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s
singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  export http_proxy=http://10.236.1.189:3128
  export HTTP_PROXY=http://10.236.1.189:3128
  source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
  setup uboonecode v08_00_00_27 -q e17:prof
  lar -c reco_uboone_mcc9_8_driver_data_ext_numi_optical.fcl -s *postdl.root
  lar -c reco_uboone_data_mcc9_8_driver_stage2_beamOff_numi.fcl -s *r1a.root
  lar -c reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff.fcl  -s *reco2.root
EOF
