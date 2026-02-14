= Reduce
<reduce>
A #strong[reduce] is a pattern used to aggregate or combine results from
multiple parallel computations into a single output. It operates on an
input collection and produces a single element in output.

Let $C$ be a collection and $xor$ be the #strong[aggregate operator];,
the result of a reduce computation is

$ x = upright("reduce") (C , xor) $

the aggregate operator is at least #strong[associative] but can also be
#strong[commutative];, giving more freedom to the runtime to reorder
operands freely.

The parallelism may be exploited by arranging the computation as a
balanced tree. The leaves combine pairs of inputs, then the internal
nodes apply $xor$ to the result of their subtrees, all the way up to the
root.

== Implementation
<implementation>
A possible implementation of the reduce pattern is done by partitioning
the input collection among all $k$ workers. Each worker computes the
reduce on its local partition and sends the result to its neighbor.

In the first iteration worker $i$ sends data to worker $(i + 1) % k$ and
receives data from worker $(i - 1) % k$. For other iterations worker $i$
sends the received data to worker $(i + 1) % k$. After $k - 1$
iterations, all the workers have the reduced value locally.

If $xor$ is both associative and commutative, a #strong[tree-based
reduce] can be better, but this time only one worker will have the
reduced value locally.

A possible variant of the tree-based implementation is the so called
#strong[all-reduce];, where in the end all workers have the reduced
value. This implementation involves the #strong[recursive doubling
algorithm];, computed in $log_2 k$ iterations.

== Cost Model
<cost-model>
Given a collection of $n$ elements, $k$ workers and the $xor$ reduce
operator, the completion time is

$ T_c^(upright("reduce")) (n , k) = T_(upright("scatter")) + T_(upright("local")) + T_(\* upright("-reduce")) $

where

$ T_(upright("scatter")) & = T_(upright("split") (n , k)) + k dot.op T_(upright("comm")) (n / k)\
T_(upright("local")) & = n / k dot.op T_xor\
T_(upright("tree-reduce")) & = log_2 (k) dot.op (T_xor + T_(upright("comm")) (1))\
T_(upright("all-reduce")) & = log_2 (k) dot.op (T_xor + 2 dot.op T_(upright("comm")) (1))\
 $

To find the optimal number $k$ of workers we can compute the derivative
of the function $T_c^(upright("reduce")) (n , k)$ and find its minimum.

== Reference
<reference>
- \[\[structured\_parallel\_programming\]\]
- \[\[map\_reduce\]\]
