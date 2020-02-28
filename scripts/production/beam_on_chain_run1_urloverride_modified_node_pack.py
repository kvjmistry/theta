from balsam.launcher import dag
import os
import subprocess
import glob
 
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
files = glob.glob("/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamon/prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns_beamdata/*.root")

# The input eventlist
input_event_list="/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamon/event_lists/event_list_prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns_FileNames_withPath.list"

join_fcl="/lus/theta-fs0/projects/uboone/kmistry/fcl/join_fcls/join_run1_beamon.fcl"

tot_events=0

# The total number of events to process, set this number to infinity to populate the db for all events
max_events=435

# The total number of files to process
max_files=30000000000000000

# Split the workflow into sets
Set=0

# Set the node_pack count
node_pack_count=64

# The total number of files to be processed
files_processed=0

for i, _file in enumerate(files):
   
    if i%100==0:
        print("On File number: ", i+1)
 
    # Check if the total number of events exceeds the number of events we want to process
    if tot_events >= max_events:
        break
    # Check if the max files is greater than threshold
    elif i >= max_files:
        break

    files_processed=i+1

    join_args_full=os.path.basename(_file)
    join_args=join_fcl+" "+join_args_full[:-5]
    
    # Get the number of events based on an input file
    nevents = getNumberEvents(join_args_full, input_event_list)

    # Increment the total num events 
    tot_events = tot_events + nevents

    print(join_args_full,"  ", nevents)
    #print(join_args)

    # increment the set counter every 1000
    if ((i+1)%1000 == 0):
        Set = Set+1

    workflow_timestamp   = f"beamon_chain_run1_timestamp_node_pack_{node_pack_count}"
    workflow_main_reco1  = f"beamon_chain_run1_set{Set}_reco1_node_pack_{node_pack_count}"
    workflow_main_reco2  = f"beamon_chain_run1_set{Set}_reco2_node_pack_{node_pack_count}"
    workflow_join        = f"beamon_chain_run1_join_node_pack_{node_pack_count}"

    timestamp_args  = f"{_file}"

    timestamp_job = dag.add_job(
        name = f"timestamp_{i}",
        workflow = workflow_timestamp,
        description = "Container that gets the timestamps for the event",
        num_nodes = 1,
        ranks_per_node = 1,
        node_packing_count = node_pack_count,
        args = timestamp_args,
        wall_time_minutes = 15,
        application= "GetTimestampFile"
    )

    mergeFinal_job = dag.add_job(
        name = f"joinedFinal_{i}",
        workflow = workflow_join,
        description = "joining final outputfiles",
        num_nodes = 1,
        ranks_per_node = 1,
        node_packing_count = node_pack_count,
        args = join_args,
        wall_time_minutes = 10,
        application= "join_art_rootfiles"
    )
    
    for ievent in range(nevents):
        beamon_reco1_args  = f"{_file} {ievent}"
        beamon_reco2_args  = f"{ievent}"

        beamon_reco1_job = dag.add_job(
            name = f"beamon_reco1_{i}_{ievent}",
            workflow = workflow_main_reco1,
            description = "uboone reco1 beam on chain",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = beamon_reco1_args,
            wall_time_minutes = 80,
            application= "beamon_chain_run1_reco1"
        )

        beamon_reco2_job = dag.add_job(
            name = f"beamon_reco2_{i}_{ievent}",
            workflow = workflow_main_reco2,
            description = "uboone reco2 beam on chain",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = beamon_reco2_args,
            wall_time_minutes = 80,
            application= "beamon_chain_run1_reco2"
        )

        # add_dependency(parent, child)
        dag.add_dependency(timestamp_job,beamon_reco1_job)
        dag.add_dependency(beamon_reco1_job, beamon_reco2_job)
        dag.add_dependency(beamon_reco2_job,mergeFinal_job)


print("Total number of events to be processed: ", tot_events)
print("Total number of files to be processed: ", files_processed)
print(workflow_timestamp)
print(workflow_main_reco1)
print(workflow_main_reco2)
print(workflow_join)
