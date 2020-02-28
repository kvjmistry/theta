from balsam.launcher.dag import BalsamJob

jobs = BalsamJob.objects.filter(state="RUNNING")
print(len(jobs))
jobs.update(state="RESTART_READY")
