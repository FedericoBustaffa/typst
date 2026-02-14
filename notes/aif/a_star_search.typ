= A\* Search
<a-search>
The idea behind #strong[A\*] search is to not expand paths that are
already expensive. This is done with the introduction of an
#strong[evaluation function]

$ f (n) = g (n) + h (n) $

where

- $g (n)$ is the total cost accumulated to reach $n$.
- $h (n)$ is the estimated cost to the goal from $n$ (the heuristic).

Overall we have that $f (n)$ is the estimated cost of the best path that
passes through $n$ to reach the goal.

Space complexity scales with the number of expanded nodes because A\*
expands

- all the nodes with $f (n) < C \*$.
- some nodes with $f (n) = C \*$.
- no nodes with $f (n) > C \*$.

where $C \*$ is the optimal path cost.

== Heuristic
<heuristic>
The A\* search is complete and is optimal if $h$ is #strong[admissible];.
To be #emph[admissible];, an heuristic must have 2 properties:

- $h (n) < h^(\*) (n)$ where $h^(\*) (n)$ is the #strong[true] cost from
  $n$.
- $h (n) gt.eq 0$, such that $h (G) = 0$ for any goal $G$.

The first property says that the heuristic must be #strong[optimistic];,
so, in other words, it doesn’t give a real distance from the goal, but
an optimistic estimation. It basically returns a better cost value than
the optimal solution cost.

The other property simply says that if we are not in the goal state the
heuristic must be greater than $0$, but if we are in the goal state $G$
the distance must be $0$.

#quote(block: true)[
\[!note\] Consistent Heuristic There is stronger type of heuristic,
called #strong[consistent];, and it has stricter conditions than
admissibility; it must hold the #strong[triangular inequality];:
$ h (n) lt.eq c (n , a , n ') + h (n ') $ for all $n'$. This property
tells us that paths costs monotonically increase and so, once you reach
a state, it is on its optimal path already.
]

To prove the optimality of A\* we can suppose that some suboptimal goal
$G_2$ has been generated and is in the queue. Let $n$ be an unexpanded
node on a shortest path to an optimal $G_1$. If $f (G_2) > f (n)$, A\*
will never select $G_2$ for expansion.

$ f (G_2) & = g (G_2) & upright("since ") h (G_2) = 0\
 & > g (G_1) & upright("since ") G_2 upright(" is suboptimal")\
 & gt.eq f (n) & upright("since ") h upright(" is admissible") $

=== Weighted A\*
<weighted-a>
To be #emph[complete] A\* can expands several nodes, but if it is not
required to have an optimal solution we can use a #strong[weighted]
version of the evaluation function

$ f (n) = g (n) + W h (n) $

with $W > 1$, that relaxes the problem letting the algorithm to find
solutions of cost between $C^(\*)$ and $W C^(\*)$.

== References
<references>
- \[\[informed\_search\]\]
