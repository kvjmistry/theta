#!/bin/bash
export MPICH_GNI_FORK_MODE=PARTCOPY
export PMI_NO_FORK=1
export BALSAM_DB_PATH=/lus/theta-fs0/projects/uboone/balsam_databases/test_database/
export BALSAM_HOME=/lus/theta-fs0/projects/uboone/.balsam/
umask g=rwx
echo "/bin/python3 /usr/local/lib64/python3.6/site-packages/balsam_flow-0.3.7-py3.6-linux-x86_64.egg/balsam/launcher/mpi_ensemble.py --wf-name=beamon_chain_run1 --time-limit-min=58"
/bin/python3 /usr/local/lib64/python3.6/site-packages/balsam_flow-0.3.7-py3.6-linux-x86_64.egg/balsam/launcher/mpi_ensemble.py --wf-name=beamon_chain_run1 --time-limit-min=58
