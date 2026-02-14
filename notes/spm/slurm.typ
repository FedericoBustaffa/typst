= SLURM
<slurm>
To handle the high number of jobs submitted to a cluster, a popular tool
is #strong[SLURM];, an open source job scheduler and resource management
for HPC cluster.

== Policies
<policies>
The #emph[SLURM] manager is designed to schedule all the jobs submitted
by users. Generally speaking we can say that the more resources a user
requests, the less priority will have.

Basically we can imagine a job queue, where all the job have the
resources they are asking for. So the scheduler see if the next job can
be executed, looking for the resources that it asks and the resources
that are available. If the requested resources are available, the job is
immediatly executed; otherwise the job will remain in the queue until
the requested resources are available.

So if a job cannot be executed and then arrives another job that can,
the second job is executed before. To prevent starvation of a job that
requests many resources, if it is waiting for too long will get
priority.

== Commands
<commands>
In the SPM cluster we have 1 front-end node for the login and 8 back-end
nodes for computation. To interact with the cluster there are some
commands to

- #strong[Fetch] informations
- #strong[Allocate] resources
- #strong[Submit] jobs

Lets see some of theme:

=== Submit Jobs
<submit-jobs>
To submit a job you can use `srun` like this

```bash
srun [options] [executable] [arguments]
```

some of the main options are

- `--nodes` or `-N`: the number of computational nodes to use.
- `--ntasks` or `-n`: the number of tasks spawned from the job.
- `--cpus-per-task` or `-c`: the number of cpu per task on the same node
  to use.
- `--ntasks-per-core`: the number of tasks per core to used.
- `--ntasks-per-socket`: the number of tasks per socket to used.
- `--ntasks-per-node`: the number of tasks per node to used.
- `--exclusive`: ensures allocated nodes are not shared with other jobs.

==== Batch Script
<batch-script>
We can also use a special bash script to say to #emph[SLURM] what to do

```bash
#!/bin/bash

#SBATCH --job-name=my_job
#SBATCH --output=output.log
#SBATCH --error=error.log
#SBATCH --time=01:00:00
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=2
#SBATCH --partition=normal
#SBATCH --mem=4G

echo $SLURM_JOB_NODELIST

srun make ./run.out param1 param2 ...
```

As we already saw, we can run this script with

```bash
sbatch script.sh
```

but outputs and errors will not be displayed on the console but only
inside the specified files.

=== Utility
<utility>
There are also a lot of useful other commands to interact with
#emph[SLURM];, for example:

- `sbatch`: submits a batch script to #emph[SLURM] for non-interactive
  executions.

  ```bash
  sbatch [options] [scripts]
  ```

- `salloc`: allocates compute nodes for an interactive session. like:

  ```bash
  salloc [options] [command] [arguments]
  ```

- `squeue`: displays the status of jobs currently in the SLURM queue. To
  display only your jobs, you can use `squeue --me`

- `scancel`: forces the termination of a job with a command like

  ```bash
  scancel -u $USER --state=PENDING
  ```

- `scontrol`: provides information on the system

- `scontrol show nodes`: available nodes.

- `scontrol show jobs`: running jobs.

=== Interactive Shell
<interactive-shell>
If we submit a command like

```bash
srun -n 1 --time=01:00:00 --pty bash -i
```

we have interactive access to a node for an hour.

== Usage Example
<usage-example>
A typical use case for #emph[SLURM] is to submit some job that can take
a while, so you may want to leave the ssh connection and resume later to
check the results.

The problem might be that if you close the ssh connection, the job you
submitted will be killed. To prevent this you can use `tmux` that is
pre-installed on the SPM cluster to keep your session alive.

== References
<references>
- \[\[parallel\_computing\]\]
- #link("%22https://slurm.schedmd.com/documentation.html%22")[SLURM documentation]
- #link("%22https://hpc.llnl.gov/banks-jobs/running-jobs/slurm%22")[SLURM tutorial]
- #link("%22https://github.com/tmux/tmux/wiki%22")[TMUX]
