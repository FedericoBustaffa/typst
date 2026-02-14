= Map
<map>
A #strong[map] is a pattern in which a single function $F$ can be
applied independently to each element of a collection, producing an
output collection of the same cardinality.

The parallelism is exploited by using a pool of workers, each working
independently on a partition of the input. This paradigm decreases the
latency to compute one input collection and if there is a stream of
collection, it lowers the service time and increases the throughput.

== Implementation
<implementation>
The implementation can use a #emph[farm] skeleton, for example with a
simple schema where an emitter dispatch tasks to workers and then a
collector catch the results.

The main issue with this pattern is the workload balancing but, in case
the input the workload associated with the collection is balanced, the
emitter may #strong[scatter] the collection in a #emph[block-based]
distribution.

If the workload is unbalanced, a dynamic approach can be used, like
#emph[work-sharing] or #emph[work-stealing];, if a passive approach is
preferred, or an #emph[on-demand] distribution can be chosen for an
active approach.

== Cost Model
<cost-model>
Given a collection of $n$ elements, $k$ workers, one emitter and one
collector we have that the completion time can be obtained with the
following formula:

$ T_c^(upright("map")) (n , k) = T_(upright("scatter")) + T_(upright("worker")) + T_(upright("gather")) $

where

$ T_(upright("scatter")) = T_(upright("split") (n , k)) + k dot.op T_(upright("comm")) (n / k)\
T_(upright("worker")) = n / k dot.op T_F + T_(upright("comm")) (n / k)\
T_(upright("gather")) = T_(upright("gather")) (n / k) $

Also notice that between the workers stage and the two communication
stages, there is a partial overlap between computation and
communication, unless a #emph["lockstep"] behavior is enforced.

=== Optimal Number of Workers
<optimal-number-of-workers>
It is also possible to find a nice number of workers by finding the
value $k$ that minimizes the completion time. Considering the linear
communication cost model we have that

$ T_(upright("comm")) (n) = t_0 + n dot.op s $

where $t_0$ is the setup time, $n$ is the number of elements or their
dimension in byte and $s$ can be seen as the latency of sending one
element. Assuming that

$ T_(upright("split") (n , k)) = T_(upright("gather")) (n / k) approx 0 $

we have that the completion time can be computed as

$ T_c (n , k) & = k dot.op T_(upright("comm")) (n / k) + n / k dot.op T_F + T_(upright("comm")) (n / k)\
 & = (k + 1) dot.op T_(upright("comm")) (n / k) + n / k dot.op T_F\
 & = (k + 1) dot.op (t_0 + n / k dot.op s) + n / k dot.op T_F $

So from this last equation is possible to compute the derivative and see
where it is equal to zero.

$ k_(upright("opt")) = ⌈sqrt(n / t_0 dot.op (T_F + s))⌉ $

Usually $k_(upright("opt"))$ is a very large number because $n$ is large
and $t_0$ is low.

=== Binary Tree Scatter and Gather
<binary-tree-scatter-and-gather>
In order to reduce the service time of the emitter and the overall
latency of the map to complete the scatter distribution, a binary tree
scatter distribution can be employed.

#figure(image("/files/map_tree_scatter.png"),
  caption: [
    Map Tree Scatter|400
  ]
)

In this way the emitter service time becomes

$ T_s^e = 2 dot.op T_(upright("comm")) (n / 2) $

and the scatter latency becomes

$ T_(upright("scatter")) = 2 dot.op sum_(i = 1)^(⌈ log_2 k ⌉) T_(upright("comm")) (n / 2^i) $

Similarly, the same patter can be used to reduce the collector’s service
time and the end-to-end latency.

#figure(image("/files/map_tree_gather.png"),
  caption: [
    Map Tree|400
  ]
)

In this way the collector service time becomes

$ T_s^c = 2 dot.op T_(upright("comm")) (n / 2) $

and the gather latency becomes

$ T_(upright("scatter")) = 2 dot.op sum_(i = 1)^(⌈ log_2 k ⌉) T_(upright("comm")) (n / 2^i) $

Typically a real skeleton does not provide explicit implementations for
emitters and collectors, that are usually implemented within the worker.

== Parallel Filesystems
<parallel-filesystems>
There are cases where we can even avoid the scatter and gather stages,
or to be more precise, they are logical operations. A #strong[parallel
filesystem] let the workers to read and write the same file in different
locations (no race conditions) at the same time.

Advantages of this type of filesystem are that

- If the data is already distributed, the splitting overhead is minimal.
- Splitting and merging are logical operations that do not actually move
  data.
- In this scenario
  $T_c^(upright("map")) (n , p) approx n / k dot.op T_(F + G)$, which
  can be significantly lower than that obtained from centralized I/O.

The #emph[Hadoop’s DFS] is an example of parallel filesystem, but is
quite old; #emph[Apache] instead it is more recent and can be more
common on HPC architectures.

== Reference
<reference>
- \[\[structured\_parallel\_programming\]\]
- \[\[map\_reduce\]\]
