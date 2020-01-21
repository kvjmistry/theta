from balsam.launcher import dag
import os
import subprocess
import glob

node_pack_count=64
 
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

join_fcl="/lus/theta-fs0/projects/uboone/kmistry/fcl/join_fcls/join_run1_beamoff.fcl"

tot_events=0

# The total number of events to process, set this number to infinity to populate the db for all events
max_events=10000

for i, _file in enumerate(files):
    
    # Check if the total number of events exceeds the number of events we want to process
    if tot_events >= max_events:
        break
    
    join_args_full=os.path.basename(_file)
    join_args=join_fcl+" "+join_args_full[:-5]
    
    # Get the number of events based on an input file
    nevents = getNumberEvents(join_args_full, input_event_list)

    # Increment the total num events 
    tot_events = tot_events + nevents

    print(join_args_full,"  ", nevents)
    #print(join_args)

    workflow  = f"beamoff_chain_run1"

    timestamp_args  = f"{_file}"

    timestamp_job = dag.add_job(
        name = f"timestamp_{i}",
        workflow = workflow,
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
        workflow = workflow,
        description = "joining final outputfiles",
        num_nodes = 1,
        ranks_per_node = 1,
        node_packing_count = node_pack_count,
        args = join_args,
        wall_time_minutes = 1,
        application= "join_art_rootfiles_preproc"
    )
    
    for ievent in range(nevents):
        beamoff_args  = f"{_file} {ievent}"

        beamoff_job = dag.add_job(
            name = f"beamoff_{i}_{ievent}",
            workflow = workflow,
            description = "uboone full beam off chain",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = beamoff_args,
            wall_time_minutes = 60,
            application= "uboonecode_beamoff_chain_run1"
        )

        # add_dependency(parent, child)
        dag.add_dependency(timestamp_job,beamoff_job)
        dag.add_dependency(beamoff_job,mergeFinal_job)


print("Total number of events to be processed: ", tot_events)
print(workflow)
