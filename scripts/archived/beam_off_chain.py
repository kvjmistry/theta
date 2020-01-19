from balsam.launcher import dag

import os
node_pack_count=64

import glob

# ---------------------------------------------------------------------------------------------
# Function to get number of events in a file
def spitNumberOfEvents(fileName):
    command = ["/lus/theta-fs0/projects/uboone/containers/countEvt_in_container.sh", fileName]
    magick_call = subprocess.Popen(command, stdin= subprocess.PIPE, stdout=subprocess.PIPE)
    dimensions = magick_call.communicate()
    nEvents = int(dimensions[0].split()[3])
    print "Number of events in ", fileName, nEvents
    return nEvents

# ---------------------------------------------------------------------------------------------
files = glob.glob("/lus/theta-fs0/projects/uboone/uBOONE_RUN3_DATA/*.root")

for i, _file in enumerate(files):
      
    # fcl files
    reco1_fcl       = "reco_uboone_data_mcc9_8_driver_stage1.fcl"
    celltree_fcl    = "run_celltreeub_prod.fcl"
    larcv_fcl       = "standard_larcv_uboone_data2d_prod.fcl"
    reco1a_fcl      = "reco_uboone_mcc9_8_driver_data_ext_optical.fcl"
    reco2_fcl       = "reco_uboone_data_mcc9_8_driver_stage2_reduced_beamOff.fcl"
    reco2_post_fcl  = "reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff.fcl"

    nevents = spitNumberOfEvents(_file)

    workflow = f"uboone_testing"
  
    for ievent in range(nevents):
        reco1_args      = f"-c {reco1_fcl} -s {_file} -n1 --nskip {ievent} -o %ifb_reco1_event{ievent}.root"
        celltree_args   = f"-c {celltree_fcl} -s *reco1*.root"
        larcv_args      = f"-c {larcv_fcl} -s *postwcct*.root"
        reco1a_args     = f"-c {reco1a_fcl} -s *postdl*.root"
        reco2_args      = f"-c {reco2_fcl} -s *reco1a*.root"
        reco2_post_args = f"-c {reco2_post_fcl} -s *reco2*.root"

        reco1_job = dag.add_job(
            name = f"reco1_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing reco 1",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = reco1_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_01b"
        )

        celltree_job = dag.add_job(
            name = f"celltree_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing celltree",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = celltree_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_01b"
        )

        larcv_job = dag.add_job(
            name = f"larcv_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing larcv",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = larcv_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_01b"
         )

        reco1a_job = dag.add_job(
            name = f"reco1a_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing reco 1a",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = reco1a_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_24"
         )

        reco2_job = dag.add_job(
            name = f"reco2_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing reco2",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = reco2_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_24"
        )

        reco2_post_job = dag.add_job(
            name = f"reco2_post_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing reco2 post",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = reco2_post_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_24"
        )

        # add_dependency(parent, child)
        dag.add_dependency(reco1_job,    celltree_job)
        dag.add_dependency(celltree_job, larcv_job)
        dag.add_dependency(larcv_job,    reco1a_job)
        dag.add_dependency(reco1a_job,   reco2_job)
        dag.add_dependency(reco2_job,    reco2_post_job)


