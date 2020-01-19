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
  export http_proxy=http://10.236.1.189:3128
  export HTTP_PROXY=http://10.236.1.189:3128
  source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
  setup uboonecode v08_00_00_27 -q e17:prof
  echo "Starting LArSoft Job"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
  lar $*
  echo "Finished Executing"
  date
  echo "TIMESTAMP_T7 $(date +%s)"
EOF
echo "Exited Container"
date
echo "TIMESTAMP_T7 $(date +%s)"
