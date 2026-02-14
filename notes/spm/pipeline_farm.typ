= Pipeline and Farm
<pipeline-and-farm>
If needed #strong[pipeline] and #strong[farm] can be merged together to
improve performance for computation or communication. The cooperation
between the two patterns can be used to balance or improve typical
bottlenecks.

For example, if a stage of pipeline is much slower than the others, the
pipeline completion time will be bounded to that stage completion time.
In order make that stage faster and similar to the others it’s possible
change it into a farm, so that the bottleneck effect is reduced.

The other way round, we can use a pipeline to parallelize and improve
the communication of a farm, which, for large values of $p$ might suffer
from a completely sequential communication.

In conclusion, adding more concurrency layers can improve throughput and
the parallelism degree, but could also lead to an higher synchronization
and communication cost, increasing the end-to-end latency.

== References
<references>
- \[\[pipeline\]\]
- \[\[farm\]\]
