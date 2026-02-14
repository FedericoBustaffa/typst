= Divide And Conquer
<divide-and-conquer>
This pattern is commonly used to #emph[divide] problems in subproblems,
until the reach of a #emph[minimal] subproblem that is usually the base
case. Then the subproblem is #emph[solved] and #emph[merged] with the
result of another subproblem of the same size.

The #strong[divide and conquer] pattern is a bit different from the map
pattern in which the division is only on data. The main difference is
that, dividing data in more partitions let the computation to be faster
because each worker needs to compute less data. However the
computational cost of each data unit is the same.

In the divide and conquer approach, the computational cost of the base
case is often better than computing even a "#emph[little];" problem.
Also the merged subproblem created are usually less costly to solve.

So, even if the divide and conquer can be implemented like a map
skeleton, the concept is different and can lead to a more efficient
algorithm.

#figure(image("divide_conquer.png"),
  caption: [
    Divide and Conquer|400
  ]
)

Achieving efficient parallel DC requires addressing two challenges:

- Scheduling the subproblems across processors to have good load
  balancing. A dynamic scheduling strategy is usually employed.
- Combining results without creating bottlenecks.

To avoid excessive overhead, a threshold value in the #emph[divide]
phase is necessary. In other words a predefined problem size below which
the divide phase stops must be defined. Another crucial point is that
the overhead of recursive division and task distribution has to be
contained in order to do not outweight the benefits of a parallel
execution.

== Implementations
<implementations>
The are two primary options depending on if the workload is balanced or
unbalanced among workers:

- #strong[Balanced workload];: to have a balanced workload it means that
  subproblems all have almost the same computational cost and it is
  possible to split the initial collection in at least $k$ partitions.
  In this case the implementation is a simple #emph[map] pattern where
  we have a #emph[divide + scatter] phase, a #emph[conquer] phase and in
  the a #emph[gather + collect] phase.
- #strong[Unbalaced workload];: in this case a #emph[farm] skeleton with
  dynamic scheduling policy is preferred, with the three steps executed
  in pipeline. For example we can have a #emph[work-stealing]
  implementation with #emph[coarse-grain] divide, then each process keep
  dividing and storing in a local task queue. When the queue is empty
  some work stealing from other processes queues is attempted.

== Cost Model
<cost-model>
For the divide and conquer parallel pattern the completion time is

$ T_c^(upright("DC")) (C , k) = T_(upright("div")) + T_(upright("conq")) + T_(w s - t e r m) + T_(c o l l) $

where

$ T_(upright("div")) = 2 dot.op sum_(i = 1)^(⌈ log_2 k ⌉) T_(upright("comm")) (n / 2^i) + frac(T_(upright("divide")) (C), k) $

is the scatter and per-worker cost to divide the collection.

$ T_(upright("conq")) = beta dot.op D / k dot.op T_(upright("conquer")) $

is the time to #emph[conquer] the local subproblems and where $beta = 1$
assumes perfect load balancing among workers and $beta > 1$ means the
workload is unbalanced.

$ T_(upright("ws-term")) = c dot.op T_(upright("steal")) + ⌈ log_2 k ⌉ dot.op T_(upright("comm")) (1) $

is the cost of the steal attempt (without success) and barrier cost and
where $c$ is a constant number of attempts to steal work, after such
attempts there must be an assumption that the conquer phase is going to
finish.

$ T_(upright("coll")) = 2 dot.op sum_(i = 1)^(⌈ log_2 k ⌉) T_(upright("comm")) (n / 2^i) + ⌈ log_2 k ⌉ dot.op T_(upright("merge")) $

is the gather and merging cost for all $D$ subproblems, where the cost
of merging can be linear in $D$ or logaritmic for tree-like structures.

#horizontalrule

So in the end we can say that the divide and conquer is a naturally
parallelizable pattern that is also potentially scalable for systems
with many processors.

On the other hand there is a high communication overhead, also due to
the fact that the for some problems it is difficult to statically
partion subproblems, so a dynamic and more costly scheduling is needed.

It’s also not easy to to find the threshold under which not to go for
the #emph[divide] phase. Also the #emph[merge] phase can be complex and
challenging to do in parallel.

== References
<references>
- \[\[structured\_parallel\_programming\]\]
