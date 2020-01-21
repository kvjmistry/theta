from balsam.launcher.dag import BalsamJob

jobs = BalsamJob.objects.filter(state="FAILED")
print(len(jobs))

jobs.update(state="RESTART_READY")


