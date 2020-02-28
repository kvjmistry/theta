#!/bin/bash -x
#COBALT -A uboone
#COBALT -n 8
#COBALT -q debug-cache-quad
#COBALT -t 60
#COBALT --attrs ssds=required:ssd_size=128 
module unload trackdeps
module unload darshan
module unload xalt
# export MPICH_GNI_FORK_MODE=FULLCOPY # otherwise, fork() causes segfaults above 1024 nodes
export MPICH_GNI_FORK_MODE=PARTCOPY
export PMI_NO_FORK=1 # otherwise, mpi4py-enabled Python apps with custom signal handlers do not respond to sigterm
#export KMP_AFFINITY=disabled # this can affect on-node scaling (test this)
export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
module switch cray-mpich/7.7.10 cray-mpich-abi
# Not sure if this is needed:
module switch PrgEnv-intel/6.0.5 PrgEnv-cray
export LD_LIBRARY_PATH=/opt/cray/udreg/2.3.2-6.0.7.1_5.15__g5196236.ari/lib64/:/opt/cray/diag/lib/:/opt/cray/ugni/6.0.14.0-6.0.7.1_3.15__gea11d3d.ari/lib64/:/opt/cray/xpmem/2.2.15-6.0.7.1_5.13__g7549d06.ari/lib64/:/opt/cray/pe/mpt/7.7.10/gni/mpich-intel-abi/16.0/lib:/opt/cray/pe/perftools/7.0.5/lib64:/opt/cray/rca/2.2.18-6.0.7.1_5.52__g2aa4f39.ari/lib64:/opt/cray/pe/pmi/5.0.14/lib64:/opt/cray/pe/libsci/19.06.1/INTEL/16.0/x86_64/lib:/opt/cray/alps/6.6.43-6.0.7.1_5.51__ga796da32.ari/lib64:/opt/cray/pe/papi/5.6.0.5/lib64:/opt/cray/wlm_detect/1.3.3-6.0.7.1_5.6__g7109084.ari/lib64/
export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
RANKS_PER_NODE=1
#This is a variable set by the job launcher:
JOBSIZE=$COBALT_JOBSIZE
TOTAL_RANKS=$(( $JOBSIZE * $RANKS_PER_NODE ))
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE -cc none singularity run -B /opt:/opt/ -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/no_singularity/uboone_singularity_slf7-balsam.sif /lus/theta-fs0/projects/uboone/kmistry/scripts/launchers/node_pack/run1_beamon_container_wrapper_node_pack.sh
