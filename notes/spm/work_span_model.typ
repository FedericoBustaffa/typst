= Work-Span Model
<work-span-model>
One of simplest model is the #strong[Work-Span] model, which gives us
more strict bounds to compared to Amdahl’s and Gustafson’s laws.

It represents the parallel program as a set of tasks that can be
dependencies of each other, organized as #strong[DAG] (Directed Acyclic
Graph).

#figure(image("/files/work_span_dag.png"),
  caption: [
    Work-Span DAG|600
  ]
)

Every task can be executed if and only if all its dependencies were
completed.

The model makes also some #strong[assumptions] on the architecture of
the system where the algorithm is executed:

- The machine has $p$ identical processors.
- The machine has a #strong[greedy scheduler] that basically execute any
  ready task without any overhead.

The greedy scheduler basically execute task whose dependencies have
already been satisfied as long as there is an available processor.

That been said, the completion time $T_p$ is defined as the time needed
to execute the algorithm with $p$ identical processors and a
#emph[greedy scheduler];. There are also two special values of $p$ that
give the name to the model:

- $T_1$ is the #strong[work] and is the time taken by the sequential
  version of the algorithm.
- $T_oo$ is the #strong[span] and is the theoretical time taken by the
  algorithm if executed with an infinite amount of processors.

The #emph[span] is also called #strong[critical path] because it
represents the DAG’s #emph[longest] path starting from the first to the
final level of the graph.

#figure(image("/files/work_span_critical_path.png"),
  caption: [
    Work-Span Critical Path|300
  ]
)

Note also that the #emph[work] is the sequential version of the
algorithm, not the parallel version with only one processor.

== Speedup Bounds
<speedup-bounds>
The speedup is computed as usual but we can make say, depending on the
level of parallelism reached, the speedup respects the following
inequality

$ S (p) = T_1 / T_p lt.eq frac(T_1, T_1 \/ p) = p $

that basically states that the maximum speedup achievable is
#emph[linear] in the number of processors $p$, assuming that

- the algorithm is perfectly parallelizable
- the greedy scheduler does not add any overhead

This also means that the completion time has a lower bound, directly
deduced by the formula above:

$ T_p gt.eq T_1 / p $

Another limit for the speedup is obviously that we cannot do better than
the version with $p = oo$ processors:

$ S (p) = T_1 / T_p lt.eq T_1 / T_oo $

which bring another lower bound on the completion time

$ T_p gt.eq T_oo $

that it is a little bit less interesting than the other because, with
$p$ fixed, it is generally true that

$ T_p gt.eq T_1 / p gt.eq T_oo $

However $T_oo$ is still an interesting measure to define the very edge
limits of the algorithm with this model.

#quote(block: true)[
\[!note\] Brent’s Theorem

Let’s assume

- that every task takes 1 time unit to complete
- a greedy scheduler
- to have a machine with enough processors that the algorithm finishes
  in $T_oo$ time step

A machine with fewer processors (let’s say $p$) has the following
completion time upper limit

$ T_p lt.eq frac(T_1 - T_oo, p) + T_oo $

#quote(block: true)[
\[!note\]- #emph[Proof] The proof is based on the fact that if the
#emph[DAG] has $n$ levels, at each level $i$ we have to compute $m_i$
operations. With $p = 1$ we have that the total time is

$ T_1 = sum_(i = 1)^n m_i $

and with $p = oo$ we have that

$ T_oo = sum_(i = 1)^n 1 = n $

So now we can say that with $p > 1$ processors we have

$ T_p = sum_(i = 1)^n #scale(x: 240%, y: 240%)[⌈] m_i / p #scale(x: 240%, y: 240%)[⌉] lt.eq sum_(i = 1)^n frac(m_i + p - 1, p) $

Let’s conclude the proof by some calculations like

$ sum_(i = 1)^n frac(m_i + p - 1, p) & = sum_(i = 1)^n m_i / p + sum_(i = 1)^n p / p - sum_(i = 1)^n 1 / p\
 & = 1 / p sum_(i = 1)^n m_i + n - n / p\
 & = T_1 / p + T_oo - T_oo / p = frac(T_1 - T_oo, p) + T_oo $

which concludes the proof.
]
]

The Brent’s theorem of course has some implications relative to
completion time and speedup. For example, if we consider the speedup we
have that

$ S (p) lt.eq min (p , T_1 / T_oo) $

and this is deduced by the previous lower bounds for the completion
time. Obviously if lower $T_oo$, the maximum achievable speedup will
become greater. This also mean that to have a good speedup $T_1$ must be
significantly larger than $T_oo$ so that

$ T_1 - T_oo approx T_1 $

and the Brent’s formula becomes

$ T_p approx T_1 / p + T_oo $

if $T_oo lt.double T_1$. So when designining an algorithm the focus must
be on reducing the #emph[span] because it is the fundamental asymptotic
limit on scalability. We can now deduce a lower bound for the speedup as
follows

$ S (p) gt.eq frac(T_1, T_1 / p + T_oo) = frac(p dot.op T_1, T_1 + p dot.op T_oo) = frac(p, 1 + p dot.op (T_oo \/ T_1)) $

Overall we have the following lower and upper bounds for time

$ T_1 / p lt.eq T_p lt.eq T_1 / p + T_oo $

and for speedup we have

$ frac(p, 1 + p dot.op (T_oo \/ T_1)) lt.eq S (p) lt.eq min (p , T_1 / T_oo) $

and can be proved that

$ S (p) = T_1 / T_p approx p $

if $T_1 \/ T_oo gt.double p$.

That been said, the greedy scheduler achieve (almost) linear speedup if
the problem is #strong[overdecomposed] to create much more parallelism
than the number of processors and this generally takes the name of
#strong[parallel slack] that is defined as $T_1 / T_oo$.

=== Limitations
<limitations>
We also have to remember that all the formulas seen before assume

- No parallel overhead.
- The memory bandwidth is not a limiting resource.
- The scheduler is greedy in scheduling tasks.

All assumptions that cannot be implemented in a real context.

== References
<references>
- \[\[parallel\_computing\]\]
