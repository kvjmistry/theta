#!/bin/bash
source /lus/theta-fs0/projects/uboone/uboonecode_avx512/setup
setup uboonecode v08_00_00_01b -q e17:prof
unsetup libwda
setup libwda v2_27_1

lar -c /lus/theta-fs0/projects/uboone/kmistry/workdirs/multifile/reco_uboone_data_mcc9_8_driver_stage1_url_override.fcl -s /lus/theta-fs0/projects/uboone/kmistry/workdirs/multifile/PhysicsRun-2016_5_6_22_34_29-0006198-00096_20160507T093603_ext_numi_20160507T101557_merged.root -n3 
