= Search
<search>
A very used paradigm for intelligent agents is the #strong[search];,
where the problem is modelled as a #strong[graph] (or #strong[tree];)
#strong[search];. In this structure every node represents a state and
links that #emph[enter] a node, typically represent the cost to move in
that state.

There are two main ways for search-based agents to operate, depending on
the environment:

- #strong[Open-loop (offline)];: the agent searches for the sequence of
  actions before perform it. This is possible only with a
  #emph[fully-observable] and #emph[deterministic] environment.
- #strong[Closed-loop (online)];: the agent continuously evaluates the
  feedback from the environment. This is typically done with
  #emph[partially observable] and #emph[stochastic] environments.

There are many possible environments that will lead to different
strategies, so it becomes crucial to know which kind of environment the
agent is working.

Another variable to take into account and that can depend on the
environment or can come with some previous knowledge is the type of
search the agent will perform.

== Tree Search
<tree-search>
The most common approach for search problem is #strong[tree-search]
algorithms; in general the algorithm starts from already visited states
and #strong[expands] them, generating #strong[successor states];. For
this kind of algorithm we need

- #strong[Frontier];: set of unexpanded nodes separating expanded nodes
  from unreached nodes.
- #strong[Reached nodes];: a set composed by the frontier and the
  expanded nodes.

In other words, an #emph[expanded] node is a node that has been
extracted from the frontier, and on which the #emph[successor function]
has been applied. An #emph[unexpanded] node is a #emph[reached] node but
still in the frontier, waiting to be expanded. An #emph[unreached] node
is a node that is not in the frontier but is in the graph (or tree)
because the problem definition implies it.

Let’s also emphasize that a #emph[state] and a #emph[node] are not the
same thing:

- A #emph[state] is a representation of a physical configuration.
- A #emph[node] is a data structure that is part of the
  #emph[search-tree];, so it includes parent, children, depth, path cost
  etc.

The last piece we need is the #strong[expand function];, that, applied
to a node:

- Creates new nodes.
- Fills in the various fields.
- Uses the #emph[successor function] of the problem to create the
  corresponding states.

#quote(block: true)[
\[!important\] State space $eq.not$ Search Tree An important thing to
take into account is that the problem’s #strong[state space] is
different from the #strong[search tree];.

This is clear if we remember that a state is different from a node; but
we can say that a node is a #emph[concrete] representation of a state in
the tree. The main difference is that, in the state space, every state
is unique, while in a search tree we can have multiple nodes
representing the same state.
]

This is because, depending on the problem and the #emph[search strategy]
we can have loops that can lead to infinite search.

We already mentioned an #emph[expand] function, which gives a set of
#emph[successor] nodes; in order to do that it needs a #emph[successor]
function, that takes in input the problem and the current state and
returns a set of nodes and the action needed to reach that node.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
- \[\[intelligent\_agents\]\]
- \[\[uninformed\_search\]\]
- \[\[informed\_search\]\]
