# transitions.py
from balsam.core.transitions import TransitionProcessPool
import time

pool = TransitionProcessPool(num_threads=5, wf_name=None)
# sleep for 24 hours
time.sleep(600000)

pool.terminate()
