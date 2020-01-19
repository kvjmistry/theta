search_str = "PhysicsRun-2016_2_11_14_34_22-0004969-00079_20160212T091420_numi_20160213T072631_merged.root"

search_str="PhysicsRun-2016_2_11_20_4_20-0004971-00156_20160212T112610_numi_20160213T071834_merged.root"


import os
import glob

files = glob.glob("/lus/theta-fs0/projects/uboone/NuMI_Data/run1/beamon/prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns/*.root")

for i, _file in enumerate(files):
    
    search_file = open("event_list_prod_numi_swizzle_inclusive_v3_tmnt_stride2_offset0_run6748_goodruns_FileNames_withPath.list", "r")
    event = 1
    join_args_full=os.path.basename(_file)
    
    #print(join_args_full)
    for line in search_file:
        #print line
        if line.strip().find(join_args_full) != -1:
            events = line.split()
            
            if (len(events) == 2 ):
                event = events[1] 
                break
            else:
                event = 1
                break
 
    search_file.close() 
    print (event)

