= PRAM Model
<pram-model>
The #strong[PRAM] (Parallel Access Random Machine) model is shared
memory platform which make the following #strong[assumptions];:

- No caching mechanism
- No NUMA organization
- No synchronization overhead

The PRAM machine is composed by $n$ #emph[identical] processors
connected to a global shared memory $M$ and any memory location is
accessible from any processor in #strong[constant time];.

#figure(image("/files/pram_model.png"),
  caption: [
    Pram Model|500
  ]
)

The communication between processors can be implemented by reading and
writing to the global memory $M$.

The PRAM model is a #emph[synchronous] parallel machine, that means that
the $n$ processors operate in #emph[locksteps] composed by three main
phases:

+ #strong[Read];: each processor can read from $M$ at the same time and
  store the data in their local memory.
+ #strong[Compute];: each processor can perform an operation and store
  the result in a register.
+ #strong[Write];: each processor can write data item to a shared memory
  cell.

Each of these steps takes constant time and the last can be done in some
sort of exclusive way to avoid race conditions, depending on the PRAM
#emph[variant] adopted.

== Complexity
<complexity>
Complexity analysis for PRAM involves two measures:

- #strong[Time complexity] $T (n)$: number of synchronous steps needed
  to complete the algorithm.
- #strong[Processors complexity] $P (n)$: number of processors used to
  execute the algorithm.

These two metrics combined give the formula for the parallel algorithm
cost

$ C (n) = T (n) times P (n) $

In general, a #strong[cost optimal] algorithm aim for a cost
proportional to the best known sequential algorithm.

=== Prefix Computation
<prefix-computation>
A #strong[prefix] is a general binary associative operation

$ circle.stroked.tiny : X times X arrow.r X $

for which is valid the following property

$ (x_i circle.stroked.tiny x_j) circle.stroked.tiny x_k = x_i circle.stroked.tiny (x_j circle.stroked.tiny x_k) $

and it could be addition, multiplication, maximum, minimum and so on.
Given a set

$ X = { x_0 , dots.h , x_(n - 1) } $

the #strong[prefix computation] aim to obtain the set

$ S = { s_0 , dots.h , s_(n - 1) } $

where

$ s_0 & = x_0\
s_i & = s_(i - 1) circle.stroked.tiny x_i $

A possible algorithm is called #strong[recursive doubling algorithm]
which consider $n = lr(|X|)$ and $p = n$:

#figure(image("/files/prefix1.png"),
  caption: [
    Prefix Computation|400
  ]
)

But for the PRAM model it is not cost optimal because we have to
consider that every processor executes $log (n)$ operations that gives
us a total cost of

$ C (n) = T (N) times P (N) = n dot.op log (n) $

that is worse than the serial version of the algorithm that have $O (n)$
complexity.

Actually, in the PRAM model, lowering the number of processors can
improve performance and lead to a cost optimal algorithm for the prefix
computation. Instead of using $p = n$ processors lets use
$p = frac(n, log (n))$ processors so that we can have a cost of

$ C (n) = T (n) times P (n) = log (n) dot.op frac(n, log (n)) = n $

We also need to slightly change the previous algorithm in a way that it
works with a partitioned input instead of #emph[unit level] input per
processor.

== Limitations
<limitations>
The PRAM model is ideal but unrealistic in many aspects as

- Uniform memory access: in real systems we have caches and memory
  hierarchies that can vary the overall speed for a read or write
  operation.
- The synchronization between processors to execute the algorithm is not
  accounted.
- Communication cost not accounted
- Cost optimal algorithms in PRAM might not scale well in real systems
  with limited resources.

In conclusion, PRAM model gives a very clean and simple framework to
design parallel algorithms; however it does not account a lot of real
world parameters, that actually have a huge impact on performance.

== References
<references>
- \[\[parallel\_computing\]\]
