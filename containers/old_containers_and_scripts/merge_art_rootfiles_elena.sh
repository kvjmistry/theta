#!/bin/bash

# This script will merge the art root files which have been split up for processing

export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s
singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  export http_proxy=http://10.236.1.189:3128
  export HTTP_PROXY=http://10.236.1.189:3128
  source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
  setup uboonecode v08_00_00_27 -q e17:prof
  echo $1 
  export sub_string=".root"
  echo ${sub_string}
  #echo ${string}
  #sub_string=".root"
  #string=${string##sub_string}
  #echo "string is: $string"
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *antibdt*   -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_antibdt.root
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *beam_bad*  -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_beam_bad.root
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *beam_good* -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_beam_good.root
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *ncpi0*     -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_ncpi0.root
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *NuCC*      -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_NuCC.root
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *pi0*       -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_pi0.root
  #lar -c /lus/theta-fs0/projects/uboone/custom_fcls/empty.fcl *reco2.root -o ${string}_tmnt_mergebeam_reco1_postwcct_postdl_reco1a_reco2_reco2.root
EOF
