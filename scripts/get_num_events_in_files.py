import glob
import os

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
files = glob.glob("/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamon/prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns/*.root")

# The input eventlist
input_event_list="/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamon/event_lists/event_list_prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns_FileNames_withPath.list"

total_events = 0

event_stop = 1000

for i, _file in enumerate(files):
    
    if total_events >= event_stop:
        break

    print("On file number: ", i)

    join_args_full=os.path.basename(_file)
    join_args=join_args_full[:-5]

    # Get the number of events based on an input file
    nevents = getNumberEvents(join_args_full, input_event_list)
 
    total_events = total_events + nevents

    print("Total events: ", total_events, "  Total files needed: ", i)


