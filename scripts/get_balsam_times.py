from balsam.launcher.dag import BalsamJob
import datetime

    
job_id_str="ab4e3218-5e7c-4f2a-b55e-a7f369434641"

jobs = BalsamJob.objects.filter(job_id=job_id_str)

time_dict = jobs[0].get_state_times()
t0 = time_dict["RUNNING"]
t1 = time_dict["RUN_DONE"]


t_epoch = datetime.datetime.utcfromtimestamp(0)
t0_sec = (t0 - t_epoch).total_seconds()
t1_sec = (t1 - t_epoch).total_seconds()

print("t0: ", t0_sec,"s")
print("t1: ", t1_sec,"s")

