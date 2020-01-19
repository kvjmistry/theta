import subprocess




def spitNumberOfEvents(fileName = "/lus/theta-fs0/projects/uboone/uBOONE_RUN3_DATA/PhysicsRun-2018_7_8_9_7_4-0017591-00137_20180714T041714_ext_numi_2.root"):
    command = ["/lus/theta-fs0/projects/uboone/containers/countEvt_in_container.sh", fileName]
    magick_call = subprocess.Popen(command, stdin= subprocess.PIPE, stdout=subprocess.PIPE)
    dimensions = magick_call.communicate()
    nEvents = int(dimensions[0].split()[3])
    print "Number of events in ", fileName, nEvents
    return nEvents


spitNumberOfEvents()
