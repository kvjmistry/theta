import sys
from balsam.launcher.dag import BalsamJob

# Script to remove a workflow from the balsam database

# USAGE: python rm_workflow.py <workflow name>

wf = sys.argv[1]

print("The workflow to delete is:", wf, " would you like to delete it? [y/n]")

# raw_input returns the empty string for "enter"
yes = {'yes','y', 'ye', 'Y'}
no = {'no','n','N' , ''}

jobs = BalsamJob.objects.filter(workflow=wf)

choice = input().lower()
if choice in yes:
   print("The total number of jobs to be deleted: ", len(jobs))
   jobs.delete()
   jobs = BalsamJob.objects.filter(workflow=wf)
   print("The total number of jobs left with the workflow: ", len(jobs))
   print(wf, " deleted!")
elif choice in no:
    print("Not going to delete: ",wf )
else:
   sys.stdout.write("Please respond with 'yes' or 'no', not going to do anything")

