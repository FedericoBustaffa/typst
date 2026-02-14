= Cache
<cache>
A common way to optimize code and reduce the impact of Von Neumann
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

== Locality
<locality>
The #strong[locality principle] is the core concept that makes the
memory hierarchy work properly. It increases the probability of reusing
data blocks that were previously moved from one level to the previous,
thus reducing the miss rate. There are two types of locality:

- #strong[Temporal];: refers to the tendency of a program to access the
  same memory location multiple times in a short period of time.
- #strong[Spatial];: refers to the tendency of a program to access
  memory locations that are spatially close to each other.

Other useful terminology to reason about cache locality are

- #strong[Cache hit];: the data is present in the cache.
- #strong[Cache miss];: the data is not present in the cache.
- #strong[Miss penalty];: the time spent transferring a cache line into
  the first level cache and the requested data to the processor.
- #strong[Miss rate];: the fraction of memory accesses not found in the
  cache, defined by
  $ upright("MR") = upright("#misses") / upright("#memory accesses") $
- #strong[Hit rate];: the fraction of memory accesses found in the
  cache: $ upright("HR") = 1 - M R $

So now it’s possible to measure CPU time by the following formula

$ upright("CPU")_(upright("time")) = upright("ClockCycles") dot.op upright("ClockCycleTime") $

where the number of clock cycles is defined as function of

- #strong[Instruction count (IC)];: the number of instructions executed,
  that can be further detailed as
  $ upright("IC")_(upright("CPU")) + upright("IC")_(upright("MEM")) $
- #strong[Clock cycles per instruction (CPI)];: average clock cycles per
  instruction, defined as
  $ upright("CPI") = upright("ClockCycles") / upright("IC") $ that again
  can be detailed as
  $ upright("CPI") = upright("IC")_(upright("CPU")) / upright("IC") dot.op upright("CPI")_(upright("CPU")) + upright("IC")_(upright("MEM")) / upright("IC") dot.op upright("CPI")_(upright("MEM")) $

so now the above formulation for the CPU time becomes

$ upright("CPU")_(upright("time")) = upright("IC") dot.op upright("CPI") dot.op upright("ClockCycleTime") $

Considering that each memory instruction may generate a cache hit or
miss with a given probability, and given the hit rate the probability of
a cache hit, we have

$ upright("CPI")_(upright("MEM")) = upright("CPI")_(upright("MEM-HIT")) + (1 - upright("HR")) dot.op upright("CPI")_(upright("MEM-MISS")) $

So now, knowing the clock frequency of the CPU, the clocks per
instruction etc. is possible to see how a decrease in hit rate can
worsen performance by a lot.

== Cache Algorithms
<cache-algorithms>
Typically the cache hierarchy is not directly managed by the user, but
by a set of #strong[caching policies] that determine

- which data is cached during program execution.
- where the data is stored.
- what cache line should be evicted if the cache is full.

Typically the data loaded from memory is a #strong[cache line];,
composed by several items stored contiguosly in memory, in order to
enforce #emph[spatial locality];.

So the cache is organized in a number of cache lines and the cache line
where the data is stored is decided by some #strong[cache mapping
strategy];:

- #strong[Direct mapping];: each memory block is restricted to exactly
  one cache line.
- #strong[N-way set associative];: each memory block can be placed in
  any of $N$ lines within a set.
- #strong[Fully associative cache];: any memory block can occupy any
  cache line.

In the end there is the need for a policy to replace cache lines when
the cache is full and a new line must by loaded:

- #strong[Last recently used (LRU)];: remove the least recently used
  cache line , accordingly to the temporale locality principle.
- #strong[Pseudo LRU];: approximation of LRU keeping a set of bits that
  tracks which ways of a set have been recently used.

Another important concept is the #strong[working set] of program,
defined as the collection of data the program actively accesses during a
specific time interval. If the working set entirely fits into the cache,
the risk of cache misses is minimized.

== Cache Coherence
<cache-coherence>
In order to understand the cache coherence problem is necessary to
understand the typical #strong[cache write policies];. In fact, when a
core modifies a memory location in the cache, the value is not
consistent anymore with the value stored in main memory. There are two
main ways of handling this situation:

- #strong[Write through];: the main memory is updated as soon as the
  cache value is modified.
- #strong[Write back];: caches mark data in the cache as #strong[dirty]
  and only when a new cache line replaces the dirty cache line, the
  value is updated in main memory.

One of the main problem with modern multi-cores is the #strong[cache
coherence] problem, originated by the fact that every core has its
private cache. This means that is possible to have several copies of
shared data in different caches, each possibly containing different
values.

This is handled by a #strong[cache coherence protocol];, that ensures
that multiple processors accessing the same memory location see a
consistent view of the data:

- #strong[Update based];: updates are propagated to all caches when a
  processor modifies a cached data.
- #strong[Invalidation based];: when a processor modifies a cached data,
  every other copy is #emph[invalidated];, forcing every core to refetch
  data from the main memory.

The first one is better for workloads with high read intensity, while
the second is better for high write intesity workloads.

=== False Sharing
<false-sharing>
While the cache coherence protocol ensures consistency among different
CPUs private caches, it also introduces a performance problem called
#strong[false sharing];.

This happens because the cache coherence protocol updates/invalidates an
entire cache line and not the single element. In particular if two
processors have the same cache line their private L1 cache, even if they
are modifying different items, the cache line is continuously
updated/invalidated causing a significant overhead.

The two main solutions to this problem are

- #strong[Data padding];: put some padding between items meant to be
  accessed by different threads, ensuring they will not end up in the
  same cache line.
- #strong[Temporary variables];: instead of continuously update the item
  shared among different CPUs caches, use a temporary private variable
  and only in the end write the result in the actual cached variable.

False sharing does not introduce any error but only a possibly big
overhead for multi-threaded programs.

== References
<references>
- \[\[shared\_memory\_systems\]\]
