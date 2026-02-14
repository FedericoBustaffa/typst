= Shared Memory Systems
<shared-memory-systems>
The basic structure of a #strong[shared memory system] is represented by
the Von Neumann architecture, where an central processing unit takes an
input and produce an output, reading and writing from #strong[memory];.

#figure(image("/files/von_neumann.png"),
  caption: [
    Von Neumann Architecture|500
  ]
)

An important aspect of this architecture is the so called #strong[Von
Neumann bottleneck];, originated by the difference between computation
speed (typically high) of the central processing unit and the main
memory read and write speed (nowadays high but significantly lower than
computation speed).

== Optimizations and Parallelism
<optimizations-and-parallelism>
The first way to optimize code and reduce the impact of Von Neumann
bottleneck is writing cache aware programs. The #strong[cache] is a
smaller memory, much faster than RAM, capable of boosting performance
well used. Modern CPUs typically have a hierarchy composed by three
levels of cache:

- #strong[L1];: very small but very fast (0.5 - 1 ns).
- #strong[L2];: bigger but slower.
- #strong[L3];: bigger than L2 but the slowest among the three (15 - 40
  ns).
- #strong[RAM] very big but order of magnitude slower than cache
  memories (50 - 100 ns).

Depending on the architecture we can have some #strong[private] levels
of cache for each processor or core (typically L1 and L2), while L3
level is typically shared.

#horizontalrule

Another common way to optimize code that introduces a form of
synchronous parallelism, keeping the computation on a single core, is
through #strong[vector units];.

We are talking about actual hardware, capable of process multiple data
in parallel with one clock cycle; they are the basics of SIMD
parallelization, that works in locksteps with a combination of
#strong[multiple ALUs] and #strong[vector registers];.

#horizontalrule

The last way of improving performance on shared memory systems is
through #strong[threading];, exploited by multi-threads and multi-cores
processors.

This introduces an asynchronous parallelization where each thread/core
has its own set of registers and program counter, kept by the processor
in order to quickly switch between different contexts, mitigating
pipeline bottlenecks due to dependencies.

== Roofline Model
<roofline-model>
The #strong[roofline model] is a way to better understand performance
limits based on compute and memory constraints or capabilities. The
model gives a much more realistic view than the raw
$R_(upright("peak"))$ value, also identifying if the workload is compute
or memory bound, and so potential bottlenecks.

In other words the roofline model tries to show how far the application
is from the achievable performance on a given system. In order to make
this evaluation, the model considers the relationship between
#strong[operational intensity];, #strong[memory bandwidth] and
#strong[peak computational performance];, considering also #emph[loops]
as the main source of computational workload.

The first assumption the model does is a simplified view of the hardware
architecture:

- #strong[Execution units] operate at maximum speed
  $R_(upright("peak"))$ measured in FLOPS.
- #strong[Data store] is any source of data.
- #strong[Data channels] to and from the data store have and work at a
  peak bandwidth $B$.

The other set of assumptions is on the application:

- It is composed by a sequence of loops with a large amount of
  iterations $L$.
- At steady state the considered loop does $N$ FLOP using $D$ bytes of
  data transferred to or from the data store.

Considering that, the ratio

$ I = N / D $

is called #strong[computational intensity] measured in FLOP/byte.

With this model should be clear if our application’s bottleneck is the
computation or the memory channels’ bandwidth. Starting from the data
channels performance, which can be expressed in FLOPS with the factor

$ I dot.op B quad (upright("FLOP") / upright("byte") dot.op upright("byte") / upright("seconds") = upright("FLOPS")) $

Both $R_(upright("peak"))$ and $I dot.op B$ are upper limits, therefore,
the expected performance is

$ P = min (R_(upright("peak")) , I dot.op B) $

Wrapping up, considering that $R_(upright("peak"))$ and $B$ are
constant, the only thing the programmer can directly manage is the
computational intensity $I$, trying to either increase the number of
operations, or reducing the amount of transferred data.

#figure(image("/files/roofline_model.png"),
  caption: [
    Roofline Model|350
  ]
)

If $I$ is low, the performance is limited by the transfer $B$, if
instead $I$ is high, the performance is limited by the execution units
$R_(upright("peak"))$.

The best use of resources is the inflection point, called
#strong[machine balance];, that can change with different architectures.

#figure(image("/files/roofline_model2.png"),
  caption: [
    Roofline Model|350
  ]
)

The aim of the program is not always to reach peak performances, but to
stay out of the #emph[poor performance] zone, either performing good or
make a good usage of memory bandwidth.

To be more precise is also possible to define a #strong[cache-aware]
roofline model with various levels of cache to have a finer grain
estimation

#figure(image("/files/roofline_model_cache.png"),
  caption: [
    Cache-Aware Roofline Model|350
  ]
)

having now different levels of bandwidth to evaluate performances.

== References
<references>
- \[\[parallel\_architectures\]\]
- \[\[cache\]\]
- \[\[simd\]\]
- \[\[threading\]\]
