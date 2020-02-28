import samweb_cli
import extractor_dict
import os
import subprocess
import shlex
import argparse
import json
import sys
import time

# ------------------------------------------------------------------------------
# modify_metadata.py
# This script will take a file that has been processed at ANL, modify its parent
# to be the swizzled file, add in the swizzler version to the metadata and then
# create a json file for declaring to SAM
# To run do python modify_metadata.py <your files>
# ------------------------------------------------------------------------------

# Turn this on to print the metadata dict
# 0 = not much printed
# 1 = print input files
# 2 = print the meta data dictonaries
debug = 1

# Start time of script
start = time.time()

samweb = samweb_cli.SAMWebClient(experiment='uboone')

for infile in sys.argv[1:]:
    if (debug == 1):
        print infile

    # Get the file metadata
    mdgen = extractor_dict.expMetaData('uboone', infile)
    md = mdgen.getmetadata()

    # Modify the parent file to be the swizzled file
    parent = md['parents']
    parent_name=parent[0]['file_name'].split("_event",1)[0]+".root"
    md['parents'] = parent_name

    # Now we want to get the swizzle version and add this to the metadata
    # To do this we need the metadata from the parent file
    command = "samweb get-metadata "+parent_name
    command = shlex.split(command)
    magic_call = subprocess.Popen(command, stdin= subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    dimensions,error = magic_call.communicate()

    # Look for swizzle v4 version in the parent file metadata and add it in 
    if (dimensions.find('swizzle.v4: 0') != -1): 
        if (debug == 2):
            print ("swizzle v4 = 0") 
        md[u'swizzle.v4'] = 0
    elif (dimensions.find('swizzle.v4: 1') != -1): 
        if (debug == 2):
            print("swizzle v4 = 1")
        md[u'swizzle.v4'] = 1
    else:
        print("Could not get swizzled v4 information in the file")

    # Look for swizzle v5 version in the parent file metadata and add it in
    if (dimensions.find('swizzle.v5: 0') != -1):
        if (debug == 2):
            print("swizzle v5 = 0")
        md[u'swizzle.v5'] = 0
    elif (dimensions.find('swizzle.v5: 1') != -1):
        if (debug == 2):
            print("swizzle v5 = 1")
        md[u'swizzle.v5'] = 1
    else:
        print("Could not get swizzled v5 information in the file")

    # Now make the json file from the metadata dict
    mdtext = json.dumps(md, indent=2, sort_keys=True)
    json_file_str = infile+".json"
    json_file = open(json_file_str, 'w') 
    json_file.write(mdtext)
    json_file.close()

    if (debug == 2):
        print mdtext

    # Declare the file to sam
    # samweb.declareFile(md=md)

print "Metadata script took: ", time.time()-start, "seconds to run." 
print "Metadata script took: ", (time.time()-start)/60, "minutes to run."

