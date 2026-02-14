= Parallel Architectures
<parallel-architectures>
Parallel architectures can be characterized by two main aspects:

- #strong[Single Node];: vector registers, multi-threading and
  multi-processing.
- #strong[Multiple Nodes];: interconnection network of multiple nodes,
  forming the parallel architecture.

There are multiple criteria to classify the type of architecture and
parallelism the given system has to offer.

- #strong[Flynn’s Taxonomy];.
- #strong[Memory layout];: based on memory organization and hierarchy.
- #strong[Cores and node number];.
- #strong[Interconnection networks];.

each focusing on a different aspect.

== Flynn’s Taxonomy
<flynns-taxonomy>
The #strong[Flynn’s Taxonomy] is based on the instruction type and data
stream:

- #strong[SISD (Single Instruction Single Data)];: classic Von Neumann
  model where a single instruction is applied on a single stream of
  data.
- #strong[SIMD (Single Instruction Multiple Data)];: a single
  instruction is applied on multiple items simultaneously.
- #strong[MISD (Multiple Instruction Single Data)];: multiple
  instruction are applied on a single item, producing multiple outputs.
- #strong[MIMD (Multiple Instruction Multiple Data)];: multiple
  instructions are applied to multiple data.

A paranthesis for GPU is #strong[SIMT];, that stands for #strong[single
instruction multiple threads];, due to the different GPU model of
computation, that supports #emph[divergence] of threads and different
paths of execution.

== Memory Layout
<memory-layout>
The other possible classification method is about memory organization
and hierarchy in #emph[shared memory] systems like:

- #strong[SMP (Symmetric Multi-Processor)];: all processors or cores
  have roughly equal access time to memory. Also called #strong[UMA
  (Uniform Memory Access)];.
- #strong[NUMA (Non-Uniform Memory Access)];: layout where all
  processors has access to a local private memory and to a global shared
  memory. In this case the time access is asymmetric based on which
  memory is accessed.

In the case of NUMA multicores, with multiple sockets and single socket
with multiple chiplets architectures, each CPU has its local memory and
controller. To maintain a single, shared address space, the nodes are
connected by an high speed #strong[network on chip (NoC)] and the OS
tries to allocate memory #emph[close] to the allocating thread in order
to reduce memory access cost.

Inherently, distributed systems are NUMA, because of their strongly
asymmetric access to their private local memory.

In general, parallel systems goals and chellenges are to optimize the
cache usage and minimize the Von Neumann bottleneck; for distributed
systems the main goal is a fast communication protocol via fast
messaging libraries, routing and flow control.

== Distributed vs Shared Memory Systems
<distributed-vs-shared-memory-systems>
In a #emph[distributed memory system] each node is a complete computer
system (SMP or NUMA) multiprocessor and processes on different nodes
communicate #emph[explicitly] by sending messages across a network.
Tipically for high-performance computing the aim is on homogeneous nodes
and fast network topologies.

On the other side #emph[shared memory systems] comprise a (modest)
number of cores, all with direct hardware access to a shared memory
space. Modern architectures all have 2 or 3 levels of cache to mitigate
the expensive access to the main memory.

In general we can say that distributed memory systems are more scalable,
costly and less energy efficient. From the standpoint point of the
programmer

- In #strong[shared memory systems] have faster communication between
  threads or processes; however the efficient management of
  synchronization and locking is generally a critical point of paying
  attention.
- For #strong[distributed memory systems];, the most important aspect is
  to reduce the cost of communication as much as possible.

== References
<references>
- \[\[parallel\_computing\]\]
- \[\[shared\_memory\_systems\]\]
- \[\[distributed\_memory\_systems\]\]
