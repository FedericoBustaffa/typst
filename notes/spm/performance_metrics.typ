= Performance Metrics
<performance-metrics>
There are many metrics that can be evaluated to measure performances,
like:

- #strong[Latency] ($L$): the time from the input arrival to the end of
  computation, when the output is ready to be delivered.
- #strong[Completion Time] ($T_c$): The overall latency of an
  application, measured as the total time that an application takes to
  complete all tasks and deliver results. It could happen that
  $ L = T_c $ if there is only one task to compute for an application.
- #strong[Service Time] ($T_s$): the time interval between the delivery
  of two consecutive output tasks.
- #strong[Throughput];: the inverse of the #emph[service time]
  $(1 \/ T_s)$ and it represents the number of tasks computed per unit
  of time.
- #strong[Inter-arrival Time] ($T_a$): the average time between the
  arrival of two consecutive tasks.

We are not considering I/O operations because most of the time we use
synthetic data that is always in RAM, so there is no need to load or
store data from or to the disk.

To study scalability, speedup and efficiency of a parallel program we
mostly consider the #emph[completion time];, varying the number of
#emph[processors];.

The typical scenario is when we have a sequential version of an
application whose completion time is $T_(upright("seq"))$ and we want to
estimate the speedup when running with a parallel degree $p$.

== Speedup
<speedup>
The #strong[speedup] of a parallel program that uses $p$ processing
elements ($S (p)$) is defined as the ratio of the completion time of the
sequential program $T_(c_(upright("seq")))$ to the completion time
obtained running with $p$ processing elements $T_c (p)$

$ S (p) = frac(T_(c_(upright("seq"))), T_c (p)) $

and it measure how fast a program runs with $p$ processors. The best
speedup you can expect, varying the number of processors is a
#emph[linear speedup];:

- If there is #emph[no parallelization overhead];, the maximum speedup
  with $p$ processors is $S (p) = p$.
- There are exceptions referred as #emph[super-linear speedup]

In general, because of the overhead introduced by the parallelization,
the speedup is #emph[sub-linear] with the number of processors used.

== Efficiency
<efficiency>
The #strong[efficiency] of a parallel program parallelized using $p$
processors ($E (p)$) is defined as the ratio between the speedup
($S (p)$) and the number of processors used $p$

$ E (p) = frac(S (p), p) = frac(T_(c_(upright("seq"))), T_c (p) times p) $

The efficiency measures how effectively a parallel program utilizes the
$p$ resources used.

There is also another correlated metric called #strong[cost of
parallelization];, that can be obtained by multiply the completion time
of the parallel program by the number of processors used.

$ T_c (p) times p > T_(c_(upright("seq"))) $

This value is generally greater than the completion time of the
sequential version. The goal is to have something like

$ T_c (p) times p approx T_(c_(upright("seq"))) $

because it means that the overhead si low and the efficiency grows
higher.

== Scalability
<scalability>
The #strong[scalability] measures how well a parallel program utilizes a
increasing number of resources, indicating whether adding more
processors continues to yield performance gains. It is measured as:

$ S (p) = frac(T_c (1), T_c (p)) $

and as we can see is very similar to the speedup, with the the
difference that here we measure the ratio between the parallel version
using only one processor and the parallel version using $p$ processors.
In the speedup we use the the completion time of the sequential version
as numerator.

=== Strong and Weak Scaling
<strong-and-weak-scaling>
To measure if problem size affect scalability and speedup we can measure
the #strong[strong scaling];, where the problem size is #emph[fixed] and
number of processors varies. In this case the performances depend on the
amount of serial work.

We can also measure the #strong[weak scaling];, where the problem size
#emph[grows proportionally] with $p$ and it tries to consider a problem
whose size is $p$ times bigger in the same amount of time.

$ T_c (S , 1) approx T_c (p dot.op S , p) $

In this case the computational cost should remains (almost) constant per
processor. The #emph[weak scaling] metric assumes that, as the size of
the problem grows, the amount of serial work and
communication/synchronization remain constant.

#horizontalrule

When we want to measure the weak scaling we should be careful with the
scaling factor we use to increase the problem size.

For example if we want to calculate the #strong[problem size] $S$ for
computing the weak scaling of a given #strong[problem] $P (p , S)$ that
we can parallelize using $p$ processors and which has a
#strong[computational cost] $C (S)$.

== Computation to Communication Ratio
<computation-to-communication-ratio>
The last metric is the #strong[computation-to-communication ratio];,
that measures the balance between computational workload and the
parallelization overhead. It is defined as

$ gamma = alpha / beta $

where $alpha > 0$ and $beta > 0$ are the the #emph[amount of
computation] and the #emph[amount of communication/synchronization];,
respectively.

Obviously the higher this ratio is, the higher speedup and efficiency
will be. Note also that an high value of $gamma$ could mean that the
workload is very large, so we cannot imply anything on the completion
time.

#horizontalrule

So we can say that the #emph[speedup] depends on the both the processing
elements used and the #emph[computation-to-communication ratio];.
Generally speaking

- Speedup tends to increase with the number of processing elements $p$
  up to a local maximum, then it tends to decrease as $p$ increases due
  to parallelization overhead.
- Speedup is low if $gamma$ is low. Usually, the longer the
  communication takes, the fewer processing elements should be used.
- Efficiency is a monotonic function in $p$ and $gamma$:
  - Typically decreases as $p$ increases.
  - Typically increases as $gamma$ increases.

All these considerations are generally valid except when the workload is
so high that we can observe very small speedup and efficiency decrease.

== References
<references>
- \[\[parallel\_computing\]\]
