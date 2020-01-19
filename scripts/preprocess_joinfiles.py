from balsam.launcher.dag import BalsamJob, current_job
import subprocess

# Get the argument for merging
args = dag.current_job.args

container = "/lus/theta-fs0/projects/uboone/containers/join_art_rootfiles.sh"

command = container+" "+args

# Execute the merge call
process = subprocess.Popen(command, stdin= subprocess.PIPE, stdout=subprocess.PIPE, shell=True)
call = process.communicate()

# Now update the job to complete
dag.current_job.update(state="RUN_DONE")
