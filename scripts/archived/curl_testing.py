from balsam.launcher import dag
import os
import subprocess
import glob

node_pack_count=64
 
# ---------------------------------------------------------------------------------------------
workflow  = f"curl_testing"

mergeFinal_job = dag.add_job(
    name = f"curl1",
    workflow = workflow,
    description = "curl test",
    num_nodes = 1,
    ranks_per_node = 1,
    node_packing_count = node_pack_count,
    args = "",
    wall_time_minutes = 50,
    application= "curl_test")
