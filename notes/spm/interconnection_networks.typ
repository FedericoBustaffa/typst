= Interconnection Networks
<interconnection-networks>
In the field of distributed parallel computing, #strong[interconnection
networks] are a main topic to ensure high performance. We go from raw
hardware to routing algorithms, ending up in high level graph theory.

The main metrics involved are

- #strong[Latency];: time from the start of a package transmission to
  its complete reception.
- #strong[Throughput];: amount of data sent per unit of time.
- #strong[Bandwidth];: theoretical maximum data transfer rate.

When the throughput reaches the bandwidth value, we talk about
#strong[saturation throughput];, defined as the amount of data per unit
of time, that can sustain the network. Above that throughput the latency
grows fast due to contention of communication resources.

== Network Topologies
<network-topologies>
In network topologies, the main components are three:

- #strong[Endpoints];: sources and destinations of messages, typically
  the computing nodes of a cluster.
- #strong[Switches];: intermediate device that receives and sends
  packages accordingly to routing algorithms. It helps for example in
  broadcasting operations, letting the computing nodes free.
- #strong[Links];: physical interconnection between nodes and switches
  like wires.

Then network topologies are divided in

- #strong[Direct];: there are no switches; all nodes are both endpoints
  and swithes.
- #strong[Indirect];: endpoints are connected through switches.

and characterized by three main features:

- #strong[Degree];: maximum number of neighbors of any node.
- #strong[Diameter];: the length of the longest path among all the node
  to node shortes paths.
- #strong[Bisection width];: the smallest number of edges to be removed
  in order to create two networks of equal size.

Typically a #strong[low diameter] supports efficient communication
between any pair of nodes, #strong[high bisection width] means that
there are many interconnections that is better for #emph[collective
communications] and #strong[constant degree] let the network scale to
large number of nodes without the need to add connections.

=== Direct Networks
<direct-networks>
In a #strong[linear array] topology the $n$ nodes are connected
sequentially one to each other.

#figure(image("linear_array_network.png"),
  caption: [
    Linear Array Topology|700
  ]
)

It has a degree of $2$, a diameter of $n - 1$ and a bisection width of
$1$.

In #strong[mesh] the $n$ nodes are organized in a #strong[grid] where
all the nodes are connected to their neighbors in the grid. For
simplicity we consider a square grid of $n = d times d$ nodes.

#figure(image("mesh_network.png"),
  caption: [
    Mesh Topology|400
  ]
)

This topology has a degree of $4$ (constant), a diameter of
$2 dot.op (d - 1)$ ($O (sqrt(n))$) and a bisection width of $d$
($O (sqrt(n))$).

A #strong[torus] is an extended version of mesh where an extra link is
added; this link connect a node on one edge to the opposite edge,
creating a circle.

#figure(image("torus_network.png"),
  caption: [
    Torus Topology|400
  ]
)

This topology has a degree of $4$ (constant like the mesh), a diameter
of $d \/ 2 + c \/ 2$ ($O (sqrt(n))$) and a bisection width of
$min (2 c , 2 d)$ ($O (sqrt(n))$).

In a #strong[binary tree] topology we have nodes organized exactly in a
binary tree shape.

#figure(image("binary_tree_network.png"),
  caption: [
    Binary Tree Topology|400
  ]
)

This topology has a degree of $3$ (constant), a diameter of $2 d$
($O (log (n))$) and a bisection width of $1$ (constant).

The #strong[hypercube] topology organizes nodes in a $d$-dimensional
hypercube, where every node has $2^d$ bit strings for identification.
Bit strings also provide positional informations; two nodes are adjacent
if and only if the two bit strings associated with the two nodes, differ
in exactly one bit position.

#figure(image("hypercube_network.png"),
  caption: [
    Hyper-Cube Topology|400
  ]
)

This topology has a degree of $d$ ($O (log n)$), a diameter of $d$
($O (log (n))$) and a bisection width of $n \/ 2$ ($O (n)$).

=== Indirect Networks
<indirect-networks>
One of the most common #strong[indirect networks] is the #strong[fat
tree] topology, where we have a binary tree composed by switches
(intermediate nodes) and leaves (endpoints).

#figure(image("fat_tree_network.png"),
  caption: [
    Fat-Tree Topology|500
  ]
)

As we can see in the figure, all nodes have only one link to a switch,
but the higher is the level where the switch is, the higher is the
number of connections.

The problems with this topology are the cost that increase with the
depth of the three and, most important, the number of connections is not
realistic.

A more realistic implementation uses switches with a #strong[limited
degree] and organized in a #strong[multistage network];.

#figure(image("fat_tree_network2.png"),
  caption: [
    Fat-Tree Topology|500
  ]
)

For this topology we have to consider $k$ (the maximum degree of every
node) and $l$ the number of levels of the tree. For a tree with $l$
levels we have

$ k + k / l $

switches in total and

$ n = k times k / l $

as maximum number of endpoints. As we can see every switch has the same
number of ports, so we have network degree of $k$ (constant), a diameter
of that is still $k$ and a bisection width of $n \/ l$.

One of the most utilized topology in the field of distributed systems
with an high number of nodes is the #strong[dragonfly];. that still has
a hierarchical organization but quite different from a fat tree.

There are three levels: #emph[router];, #emph[group] and #emph[system];.
Each #strong[router] has connections to $p$ endpoints, $a - 1$ local
channels and $h$ global channels. A #strong[group] consists of $a$
routers and each group has $a dot.op p$ connections to endpoints and
$a dot.op h$ connections to global channels.

#figure(image("dragonfly_network.png"),
  caption: [
    Dragonfly Topolgy|450
  ]
)

In total this topology has a degree of $p + (a - 1) + h$, a constant
diameter and large bisection width.

== References
<references>
- \[\[distributed\_memory\_systems\]\]
