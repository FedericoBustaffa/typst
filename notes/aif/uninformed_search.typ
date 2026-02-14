= Uninformed Search
<uninformed-search>
An #strong[uninformed search] is performed when we don’t know the
#emph[distance] from the current state to the goal state.

In order to perform a search we need a #strong[strategy] that defines
how nodes are expanded and so how much the search will cost, and things
like

- #strong[Completeness];: the search always finds a solution if one
  exists and always fails if it does not.
- #strong[Optimality];: the search always find the least cost solution.

We are also interested in #strong[time] and #strong[space complexity]
and in this case they are usually measured in

- #strong[Maximum branching factor] of the tree ($b$).
- #strong[Depth] of the least cost solution ($d$).
- #strong[Maximum depth] of the state space ($m$) that can be infinite.

Strategies for uninformed search use only information available with the
problem definition, so there is no information about how far we are from
the goal state. The most popular strategies for uninformed search are

- #strong[Breadth first search]
- #strong[Uniform cost search]
- #strong[Depth first search]
- #strong[Depth limited search]
- #strong[Iterative deepening search]

Some of these strategies handle naturally the #strong[repeated states]
issue that presents when for example there are cycles in the search
graph or there are redundant paths (differents paths that lead to the
same state). In this case, detection of cycles and redundant paths can
prevent a possible exponential complexity.

== References
<references>
- \[\[search\_problems\]\]
