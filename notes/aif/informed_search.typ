= Informed Search
<informed-search>
An #strong[informed search] is performed when we have some knowledge on
the #emph[distance] from the current state to the goal state. This is
not part of the problem definition and it is usually #emph[given];.

This measure of how far we are from the goal state is called
#strong[heuristic] and provides an estimate of the cheapest cost from
the state at node $n$ to the goal.

The most popular category of informed search algorithms are the
#strong[best first];, in which we expand the #emph[most desirable]
unexpanded nodes. In this case how desirable is a node is defined by the
heuristic or some #emph[evaluation function] that comprehends it.

The main two #emph[best first] algorithms are

- \[\[greedy\_search\]\]
- \[\[a\_star\_search\]\]

in which the frontier is now a #strong[weighted queue] sorted by
increasing heuristic value.

If we have two different admissible heuristics $h_1$ and $h_2$, then we
can say that $h_2$ #strong[dominates] $h_1$ if $h_2 (n) gt.eq h_1 (n)$
for all $n$.

== Design Heuristics
<design-heuristics>
Designing heuristics is not a mechanical process and it always depends
on the problem.

In general we can try to #strong[relax] the problem and find an exact
solution to that relaxed problem. The cost of transition of the relaxed
problem become the heuristic for the real problem.

To compare heuristic we can measure the #strong[effective branching
factor] $b$: the closer to $1$ the better it is.

Is also possible to #emph[learn] heuristics because they are just
functions, but a fair amount of data is needed.

== References
<references>
- \[\[search\_problems\]\]
- \[\[greedy\_search\]\]
- \[\[a\_star\_search\]\]
