#!/bin/bash

export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s
singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  export http_proxy=http://10.236.1.189:3128
  export HTTP_PROXY=http://10.236.1.189:3128
  source /lus/theta-fs0/projects/uboone/uboonecode/setup
  setup uboonecode v08_00_00_01b -q e17:prof
  lar -c reco_uboone_data_mcc9_8_driver_stage1.fcl -s $1 -n1 --nskip $2 -o %ifb_event$2_reco1.root
  lar -c run_celltreeub_prod.fcl -s *reco1.root
  lar -c standard_larcv_uboone_data2d_prod.fcl -s *postwcct.root
EOF
