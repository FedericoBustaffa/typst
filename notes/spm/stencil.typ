= Stencil
<stencil>
Commonly used for scientific and engineering simulations, the
#strong[stencil] pattern is used to update points on a $n$-dimensional
grid. An example of stencil computation is given by the Jacobi
algorithm, where each element of a matrix is updated with the mean of
its four neighbors.

To parallelize this algorithm, is common to partition the input data
domain in subdomains (#strong[grids];) each processed by a worker. As
said before, each point is updated following a specific pattern that
uses its neighbors. This implies that the majority of points in each
subdomain, can be updated simultaneously; points on the border of a
subdomain may need gathering data from the neighbors.

Usually the computation goes on until a termination condition is reached
and logically the stencil is a #emph[map] and #emph[reduce] pattern.

== 5-Points
<points>
One of simplest stencils is the 2D-grid, that is also #emph[regular] and
#emph[symmetric] like a $n times n$ matrix. In this case the involved
points are 5, the main point and its four neighbors.

Another typical way of computing a stencil is by creating a copy of the
grid, in which the result will be stored. This easily prevents errors
because in a stencil computation every update is done considering the
initial grid values and not the updated one.

Also to simplify the logic of the computation, so called #strong[halo
cells] are added, in order to let the compute the border cells the same
way of the others without the need of any conditional statement.

#figure(image("stencil2D.png"),
  caption: [
    Stencil|300
  ]
)

The main challenge in this case is to partition data elements to the
processors, in order to reduce the communication overhead and balance
the workload. This is a $N P$-hard problem but there are two main
heuristics that can be employed: #strong[row] and #strong[tile]
paritioning.

Supposing to have $k$ workers, the first method produces $n \/ k$
partitions that are blocks of rows. In the second case, every tile is
formed by $sqrt(k) times sqrt(k)$ elements, for a total of $n^2 \/ k$
partitions.

=== Cost Model
<cost-model>
Considering that we can overlap the computation of internal elements
with the communication of the border elements, the stencil completion
time is

$ T_c^(upright("stencil")) (n^2 , k , F) = T_(upright("scatter")) (n^2 , k) + T_(upright("compute")) (n^2 , k , F) + T_(upright("gather")) (n^2 , k) $

where

$ T_(upright("compute")) (n^2 , k , F) = m dot.op [max (T_F dot.op (sqrt(k) - 2)^2 , 4 dot.op T_(upright("comm")) (sqrt(k))) + 4 dot.op T_F dot.op sqrt(k)] $

#figure(image("stencil2D_tile.png"),
  caption: [
    2D Tile Stencil|600
  ]
)

More complex stencils can be #strong[irregular] or #strong[dyanmic];,
for example unstructured grids or #emph[wavefront] that could add
dependencies and complexity to the computation, changing the actual cost
of the parallel computation.

== References
<references>
- \[\[structured\_parallel\_programming\]\]
