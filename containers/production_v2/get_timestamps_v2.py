import datetime
import glob
#from datetime import timezone
import subprocess
import sys
from datetime import timedelta
import time 
import os

# This script will get a time stamp corresponding to the average of the start and 
# end time of the minimum and maximum parent of a file. It will make a list with 
# the filename and timestamp in seconds from the unix epoch. 

# Usage: python /lus/theta-fs0/projects/uboone/containers/get_timestamps_v2.py mylist.txt v01b/v27

# In this v2 version, instead of using sam metadata, we use an input string from 
# a LArSoft Module

infile = open(sys.argv[1], "r")

version = sys.argv[2]

outname = sys.argv[1][:-4] + "_" + version  + "_timestamps.txt"

inIOV = "/lus/theta-fs0/projects/uboone/kmistry/IOV/" + version + "/*.txt"

print(inIOV)

outfile = open(outname, "w")

# Loop over the lines in the file
# Format is 0 17422 304 2018-06-27 00:07:05.000000000Z
for _file in infile:

    
    _file = _file.split()
    event_index = _file[0]
    run       = _file[1]
    subrun    = _file[2]
    timestamp = _file[3] + " " + _file[4]

    timestamp = datetime.datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S.000000000Z')

    # Now we have time stamp, we want to find the interval of validity this time fall in.
    files_IOV = glob.glob(inIOV)

    file_string ="event "+ str(event_index)

    # Now loop over the IOV file(s) 
    for i, file_IOV in enumerate(files_IOV):
        f = open(file_IOV, "r")

        print(file_IOV)

        # define counter for defining start and end
        counter = 0
        in_IOV_range = 0
        start_IOV = ""
        end_IOV = ""

        # Check timestamp > IOV start and < IOV end
        for j, line in enumerate(f):

            # Remove newline charcter at end of string
            line = line[:-1]
            
            # This sets the first start value (should be some time in the distant past)
            if (counter == 0):
                start_IOV = line
                start_IOV = datetime.datetime.strptime(start_IOV, '%d-%b-%Y %H:%M')
                counter = counter + 1 
            
            # Do the check
            elif (counter >= 1):
                end_IOV = line
                end_IOV = datetime.datetime.strptime(end_IOV, '%d-%b-%Y %H:%M')

                
                if (timestamp >= start_IOV and (timestamp <= end_IOV) ):
                    average_timestamp = start_IOV + (end_IOV - start_IOV)/2
                    print (start_IOV, " ", end_IOV, " ", average_timestamp)
                    in_IOV_range = in_IOV_range + 1

                    # Convert timestamp to time from epoch
                    #seconds_since_epoch = average_timestamp.timestamp() # This only works with python 3
                    seconds_since_epoch  = time.mktime(average_timestamp.timetuple()) + average_timestamp.microsecond/1e6  #python 2 fix

                    # Make string
                    file_part = os.path.basename(file_IOV)
                    file_string = file_string + "," + file_part[:-4] + "," + str(seconds_since_epoch)


                # Now the start time of the next check is the current end time
                start_IOV = end_IOV

            else:
                print("Error did not reset the counter")

        if (in_IOV_range == 0):
            print("Error, no values found in IOV range")
            sys.exit(0)
        elif (in_IOV_range == 1):
            print("Found 1 match of IOV")
        else:
            print("Error, more than one IOV range found: ", in_IOV_range)
            sys.exit(0)

        f.close()
    
    file_string = file_string + "\n"

    # Write the string to the file
    outfile.write(file_string)
    
    print(file_string)

outfile.close()
