from balsam.launcher import dag
import os
import subprocess
import glob

node_pack_count=64
 
# ---------------------------------------------------------------------------------------------
# Function to get number of events in a file
def spitNumberOfEvents(fileName):
    command = ["/lus/theta-fs0/projects/uboone/containers/countEvt_in_container.sh", fileName]
    magick_call = subprocess.Popen(command, stdin= subprocess.PIPE, stdout=subprocess.PIPE)
    dimensions = magick_call.communicate()
    nEvents = int(dimensions[0].split()[3])
    print ("Number of events in ", fileName, nEvents)
    return nEvents

# ---------------------------------------------------------------------------------------------
# Function that reads in a filelist with the file and eventcount and returns the event count
def getNumberEvents(filename, filelist):

    search_file = open(filelist, "r")

    event = 1 

    # Loop over the filelist and find the filename
    for line in search_file:
        # If we got a match then get the event 
        if line.strip().find(filename) != -1:
            events = line.split()
           
            # If there is an event then set the event, otherwise set to 1 so run over it
            # despite there being no events in the art-root file (can still run over it if no events)
            # we do this because of POT coutining 
            if (len(events) == 2 ):
                event = events[1]
                break
            else:
                event = 1
                break

    search_file.close()
    return int(event)

# ---------------------------------------------------------------------------------------------
# The files to run over
files = glob.glob("/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamoff/prod_extnumi_swizzle_inclusive_v3_tmnt_stride2_offset0_goodruns/*.root")

# The input eventlist
input_event_list="/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamoff/event_lists/event_list_prod_extnumi_swizzle_inclusive_v3_tmnt_stride2_offset0_goodruns_FileNames_withPath.list"

tot_events=0

# The total number of events to process, set this number to infinity to populate the db for all events
max_events=8100

for i, _file in enumerate(files):
    
    # Check if the total number of events exceeds the number of events we want to process
    if tot_events >= max_events:
        break


    # fcl files
    reco1_fcl       = "reco_uboone_data_mcc9_8_driver_stage1.fcl"
    celltree_fcl    = "run_celltreeub_prod.fcl"
    larcv_fcl       = "standard_larcv_uboone_data2d_prod.fcl"
    reco1a_fcl      = "reco_uboone_mcc9_8_driver_data_ext_numi_optical.fcl"
    reco2_fcl       = "reco_uboone_data_mcc9_8_driver_stage2_beamOff_numi.fcl"
    reco2_post_fcl  = "reco_uboone_data_mcc9_1_8_driver_poststage2_filters_beamOff.fcl"

    join_args_full=os.path.basename(_file)
    join_args=join_args_full[:-5]

    # Get the number of events based on an input file
    nevents = getNumberEvents(join_args_full, input_event_list)

    # Increment the total num events 
    tot_events = tot_events + nevents


    print(join_args_full,"  ", nevents)

    workflow  = f"uboone_beamoff_run1_midscale"

    mergeFinal_job = dag.add_job(
        name = f"joinedFinal_{i}",
        workflow = workflow,
        description = "joining final outputfiles",
        num_nodes = 1,
        ranks_per_node = 1,
        node_packing_count = node_pack_count,
        args = join_args,
        wall_time_minutes = 50,
        application= "join_art_rootfiles"
    )
    
    for ievent in range(nevents):
        reco1_args      = f"-c {reco1_fcl} -s {_file} -n1 --nskip {ievent} -o %ifb_event{ievent}_reco1.root"
        celltree_args   = f"-c {celltree_fcl} -s *reco1.root"
        larcv_args      = f"-c {larcv_fcl} -s *postwcct.root"
        reco1a_args     = f"-c {reco1a_fcl} -s *postdl.root"
        reco2_args      = f"-c {reco2_fcl} -s *r1a.root"
        reco2_post_args = f"-c {reco2_post_fcl} -s *reco2.root"

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
            application= "uboonecode_v08_00_00_27"
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
            application= "uboonecode_v08_00_00_27"
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
            application= "uboonecode_v08_00_00_27"
        )

        # add_dependency(parent, child)
        dag.add_dependency(reco1_job,     celltree_job)
        dag.add_dependency(celltree_job,  larcv_job)
        dag.add_dependency(larcv_job,     reco1a_job)
        dag.add_dependency(reco1a_job,    reco2_job)
        dag.add_dependency(reco2_job,     reco2_post_job)
        dag.add_dependency(reco2_post_job,mergeFinal_job)


print("Total number of events to be processed: ", tot_events)
