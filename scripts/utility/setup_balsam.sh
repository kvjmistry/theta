#!/bin/bash

echo "Setting up balsam database: $1"

module load cray-python/3.6.1.1
source /lus/theta-fs0/projects/uboone/env2/bin/activate
source balsamactivate /lus/theta-fs0/projects/uboone/balsam_databases/$1
umask g=rwx
export LC_ALL=en_US.UTF-8

echo "Creating aliases for balsam directory..."
echo "bdata =  /lus/theta-fs0/projects/uboone/balsam_databases/$1/data/"
alias bdata="cd /lus/theta-fs0/projects/uboone/balsam_databases/$1/data/; pwd"
