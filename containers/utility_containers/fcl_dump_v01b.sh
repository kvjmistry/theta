#!/bin/bash

# USAGE: ./fcl_dump_v01b.sh <fcl name>

export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s
singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  source /lus/theta-fs0/projects/uboone/uboonecode/setup
  setup uboonecode v08_00_00_01b -q e17:prof
  fhicl-dump $1 | grep http > dump.txt
EOF
