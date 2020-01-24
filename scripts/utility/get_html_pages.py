import datetime
import glob
from datetime import timezone
import subprocess
import sys
from datetime import timedelta  
import os
import time

# This script will locally get a the html pages for each IOV for use at argonne

# Now we have time stamp, we want to find the interval of validity this time fall in.
files_IOV = glob.glob("/uboone/data/users/kmistry/work/MCC9/argonne/time_stamps/IOV/*.txt")

# Now loop over the IOV file(s) 
for i, file_IOV in enumerate(files_IOV):
    f = open(file_IOV, "r")

    output_filename = os.path.basename(file_IOV) 
    output_filename = output_filename[:-4]

    print(output_filename)

    # define counter for defining start and end
    counter = 0
    in_IOV_range = 0
    start_IOV = ""
    end_IOV = ""

    for j, line in enumerate(f):

        # Remove newline charcter at end of string
        line = line[:-1]
        
        # This sets the first start value (should be some time in the distant past)
        if (counter == 0):
            start_IOV = line
            start_IOV = datetime.datetime.strptime(start_IOV, '%d-%b-%Y %H:%M')
            counter = counter + 1 
        
        # get the average timestamp page
        elif (counter >= 1):
            end_IOV = line
            end_IOV = datetime.datetime.strptime(end_IOV, '%d-%b-%Y %H:%M')

            average_timestamp = start_IOV + (end_IOV - start_IOV)/2
            print (start_IOV, " ", end_IOV, " ", average_timestamp)

            # Convert timestamp to time from epoch
            seconds_since_epoch = average_timestamp.replace(tzinfo=timezone.utc).timestamp()
            #seconds_since_epoch  = time.mktime(average_timestamp.timetuple()) + average_timestamp.microsecond/1e6 #python 2 fix

            outfile_string = "html_pages/" + output_filename + "/" + output_filename + "_" + str(seconds_since_epoch) + ".html"

            # Open a file, get the html page then close file
            f2 = open(outfile_string, "w")

            url = "http://dbdata0vm.fnal.gov:8186/uboonecon_prod/app/data?f=" + output_filename[:-5] + "&t=" + str(seconds_since_epoch) + "&tag=" + output_filename[-4:]
            print(url)

            # Curl the data from the webpage
            proc = subprocess.Popen(["curl", "-vS", url], stdout=subprocess.PIPE)
            (data, err) = proc.communicate()
            data  = data.decode("utf-8")
            f2.write(data)
            f2.close()

            # Now the start time of the next check is the current end time
            start_IOV = end_IOV

        else:
            print("Error did not reset the counter")

    f.close()

