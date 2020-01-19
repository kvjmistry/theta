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
max_events=200

for i, _file in enumerate(files):
    
    # Check if the total number of events exceeds the number of events we want to process
    if tot_events >= max_events:
        break


    join_args_full=os.path.basename(_file)
    join_args=join_args_full[:-5]

    # Get the number of events based on an input file
    nevents = getNumberEvents(join_args_full, input_event_list)

    # Increment the total num events 
    tot_events = tot_events + nevents

    print(join_args_full,"  ", nevents)

    workflow  = f"uboone_beamoff_run1_combined_container"

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
        v01b_args  = f"{_file} {ievent}"
        v27_args   = f" "

        v01b_job = dag.add_job(
            name = f"v01b_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing v08_00_00_01b chain",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = v01b_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_01b_combined"
        )

        v27_job = dag.add_job(
            name = f"v27_{i}_{ievent}",
            workflow = workflow,
            description = "uboone testing v08_00_00_27",
            num_nodes = 1,
            ranks_per_node = 1,
            node_packing_count = node_pack_count,
            args = v27_args,
            wall_time_minutes = 50,
            application= "uboonecode_v08_00_00_27_combined"
         )

        # add_dependency(parent, child)
        dag.add_dependency(v01b_job,     v27_job)
        dag.add_dependency(v27_job,mergeFinal_job)


print("Total number of events to be processed: ", tot_events)
