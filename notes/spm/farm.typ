= Farm
<farm>
A #strong[farm] is a parallel pattern that improve efficiency by
#strong[replicating] the same (often #emph[stateless];) function $F$ $k$
times. Each function replica is executed by a #strong[worker];. The goal
is to improve the throughput of one single stage of the computation.

The most common pattern involves an initial phase of task distribution,
a computation phase and a final phase in which the results are gathered.

#figure(image("farm.png"),
  caption: [
    Farm|700
  ]
)

Often the notation to describe farms involve the definition of two
entities in addition to worker, #strong[emitters] and
#strong[collectors];.

In real implementations (farm skeletons) emitters and collectors usually
are not standalone implemented entities and it is the worker the does
the emmitter and collector job. In other cases can happen that emitters
and collectors are implemented to better overlap communication and
communication, for example in a multithreaded and distributed
application.

#figure(image("farm_skeletons.png"),
  caption: [
    Farm Skeletons
  ]
)

In order to reduce the cost of a sequential communication, the farm can
implemented with a tree of emitters and collectors, trying to achieve a
logarithmic communication time.

== Cost Model
<cost-model>
The cost model can vary a lot, depending on the implementation; for
simplicity let’s consider a skeleton with one emitter and one collector,
which take the same amount of time to distribute and collect tasks,
respectively.

$ T_s^e = T_s^c $

The farm has $k$ workers and the emitter’s service time is lower than
the inter-arrival time and workers’ service time

$ T_s^e < T_a quad and quad T_s^e < T_s^w $

If $n$ tasks are submitted, the #strong[completion time] is

$ T_c (n , k) = (k + 1) dot.op T_(upright("comm")) + n / k dot.op (T_s^w + T_(upright("comm"))) $

#figure(image("farm_time.png"),
  caption: [
    Farm Completion Time
  ]
)

A farm is a #emph[bottleneck] if the workers stage service time higher
than the inter-arrival time, so it must hold:

$ max (T_s^e , T_s^c) lt.eq frac(T_s^w (F), k) lt.eq T_a $

therefore

$ frac(T_s^w (F), T_a) lt.eq k lt.eq frac(T_s^w (F), max (T_s^e , T_s^c)) $

the minimal $k$ that ensures the stage not being a bottleneck is

$ k_(upright("opt")) = ⌈frac(T_s^w (F), T_a)⌉ $

In general, given a farm with $k$ workers, each with a service time of

$ T_s^w (F) = cases(delim: "{", T_s^(upright("seq")) + T_(upright("comm")) & upright("no communication overlap"), max (T_s^(upright("seq")) (F) , T_(upright("comm"))) & upright("otherwise")) $

The #strong[service time] is

$ T_s (F , k) = max (frac(T_s^w (F), k) , T_s^e , T_s^c) $

The task #strong[latency] is

$ L = T_s^w (F) + T_s^e + T_s^c $

The #strong[completion time] for $n$ tasks is

$ T_c (n , k) = (k + 1) dot.op T_(upright("comm")) + n / k dot.op T_s^w $

== Task Scheduling
<task-scheduling>
The emitter must assign input tasks to workers in order to ensure an
even workload balancing. In practice the right choice depends on the
problem and on the computational payload of each task.

Let’s suppose that the time needed to compute a task is more or less the
same for every tasks

$ F (x_i) approx F (x_j) $

then a #strong[round robin] task scheduling could be effective.
Otherwise, in case of heterogeneous tasks an #strong[on-demand] task
scheduling could be better so that each worker is feeded as soon as it
finish the previous computation.

The possible implementations can vary a lot and, based on the context a
#emph[work sharing] or a #emph[work stealing] approach can be a good
option.

== Preserve Ordering
<preserve-ordering>
A farm described as above does not ensure output ordering, and depending
on the problem is not even necessary. Order the output should not be
done (unless is necessary) to improve performance and reduce the logic
complexity of the algorithm.

Sometimes the order is important so it becomes necessary to add some
logic to ensure it. A common way is to bind every task with a numerical
and monotically increasing ID, that can be used in the end to find the
correct location for the computed result.

== Stateful Functions
<stateful-functions>
The most common scenario is that a task submitted to a farm is
#emph[stateless];, but there are cases where a state should be hold, and
that should be handled properly.

Holding a state and ensure consistence can be challenging in a
distributed system, not only for performance issues, but also for an
higher logic complexity.

The first scenario is the #strong[read-only state] where, in case of
distributed memory systems, each worker hold a replica of the state and
there is no need for a synchronization beyond the initial data
distribution. For shared memory systems a single shared copy of the
state is sufficient.

For #strong[read-write state] there are two main distinctions:

- #strong[Monolitich state] (non partitionable): the entire state must
  be updated for all workers whenever a write occurs.
- #strong[Partitionable state];: the state can be divided into disjoint
  segments so each worker handles a portion independetly.

In the first case the cost scales with the frequency of writes and the
portability of updates. For shared memory systems a usual implementation
involves a #emph[multiple reader single writer] approach, meanwhile for
distributed systems there are #emph[multicast] based approaches to
notify workers that a write occurred.

In the other case it is common to apply some kind of #emph[hashing] to
the task that in order to identify the right partition and send the task
to the proper worker.

== References
<references>
- \[\[structured\_parallel\_programming\]\]
- \[\[pipeline\_farm\]\]
