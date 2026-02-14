= Constraint Satisfaction Problem
<constraint-satisfaction-problem>
There are problems where the goal is to reach a state that satisfies
some #emph[constraints];, these are called #strong[constraint
satisfaction problems] (#strong[CSP];) and in order to solve them, we
need to

- Define a #strong[structured state] via #strong[factored
  representation];. In other words we pass from an #strong[atomic] state
  to a state that has the shape of a vector, whose components are in a
  sense independent. $ X = { X_1 , X_2 , dots.h , X_n } $
- The #strong[domain knowledge] is expressed by a set $C$ of
  constraints. For example $ X_1 lt.eq 0 quad X_2 in [1 , 3] $

A CSP solution so is basically a triple formed by

- $X$: the assignment that satisfies all constraints.
- $D$: the domain space of $X$.
- $C$: the set of constraints.

Let’s also define some type of assignment or solution

- #strong[Complete] if all variables have been assigned a value. It is
  called #strong[partial] if only a few variables have been assigned.
- #strong[Consistent] if the assigned variables satisfy the constraints.
- #strong[Partial solution] is a partial assignment that is consistent.

Of course the aim is to find a #emph[complete] and #emph[consistent]
solution.

#horizontalrule

There are different types of constraints:

- #strong[Unary];: only one variable is involved.
- #strong[Binary];: two variables are involved.
- #strong[Global];: any number of variables involved.
- #strong[Preference];: soft constraints that represent a preference
  that will not affect the consistency of a solution if not satisfied,
  but would be better to. They are typically modelled by a cost
  associated with each assignment.

The first three types are called #strong[absolute constraints];.

== Search in CSPs
<search-in-csps>
Like in other fields, we can search in the factored states space, but
instead of expanding nodes, we can exploit the vectorial structure. If
we have $n$ variables that can take $d$ possible values, making an
assignment that respects some constraints reduces the search space
(#strong[constraint propagation];).

For the initial state we have an #strong[empty] assignment and a
branching factor of $n d$ at the root. We proceed by assigning one of
the possible $d$ value to a variable that does not conflict with the
current assignment. The branching factor at the second level will be
$(n - 1) d$, and so all the solutions will be at level $n$ (we have
assigned all the variables).

The problem is that the number of leaves is $n ! d^n$, but to fix this
we can exploit the problem structure.

=== Backtracking
<backtracking>
just by fixing the order of assignments, in this way is possible to
remove the $n !$ complexity. This is because, at each step, we no longer
choose which variable assign, but only which value assign to it because
the order is predefined.

This is basically a DFS that recursively assign variable after variable
and if the assignment is not consistent, it fails and try another value
from the domain. If every value bring to non consistent assignment the
there is the need to change the value of the previous variable.

==== Heuristics
<heuristics>
With vectorial state is possible to build heuristics that are
independent from the domain and that can speed up the search.

- #strong[Minimum Remaining Value] (#strong[MRV];): choose variable with
  fewest legal values first, in order to fail fast and pruning earlier.
- #strong[Degree];: choose variable with most constraints first.
- #strong[Least Constraining Values];: choose a value assignment that
  rules out the fewest values in the other variables to be assigned. In
  other words it let more options open in order reduce the probability
  of going back too much.

There are also possible improvements via #emph[inference];,

- #strong[Forward Checking];: assign a value to $X$ and for each
  constraint $C_(X Y)$, remove values from $D_Y$ that break constraints.
  If there is no value left we backtrack

- #strong[Arc-Consistency];: a variable $X$ is #strong[arc-consistent]
  if and only if for every constraint $C_(X Y)$, and for all possible
  values $x in D_X$, there exists a value $y in D_Y$ such that $y$
  satisfies the constraint $C_(X Y)$.

  In other words, every possible value of $X$ is supported by at least
  one compatible value in $D_Y$. The opposite must be checked
  separately. If a value in $D_X$ does not have at least one value in
  $D_Y$ that satisfies the constraint $C_(X Y)$, it can be removed from
  the $D_X$.

  It’s possible to repeat the process until we remain only with
  variables that are #emph[arc-consistent] and so, with a reduced search
  space.

these techniques can be used before and/or during the search in order to
reduce the space of possible assignments.

=== Local Search in CSPs
<local-search-in-csps>
Local search algorithms for CSPs does not partially assign values, they
in fact consider a #strong[complete state formulation] where each state
assign a value to every variables.

So we typically start from a random assignment of all variables and the
search changes only one value at a time.

- #strong[Min Conflicts];: choose the value that breaks the least
  constraints.

Even though there are many tricks, CSP is still difficult, in fact the
worst case have $d^n$ leaves anyway.

=== Exploiting Problem Structure
<exploiting-problem-structure>
There are cases where we need to reason on the problem structure in
order to be able to optimize.

For example in a #strong[graph-structure] CSPs, we can compute the
#strong[connected components] in order to be able to solve sub-problems,
whose union will bring the main problem solution.

For #strong[tree-structured] CSPs the cost is $O (n d^2)$ if we use the
following algorithm:

+ #strong[Topological sort];: choose any variable as root and order
  variables such that each one is a child of its parents.
+ Make the tree arc-consistence, return failure otherwise.
+ Assign to each node any value consistent with its parents, or fail.

This specific structure let us never backtrack. Is also possible to
#strong[force a CSP in a tree structure] by

+ Assign a variable to a node.
+ Make arcs consistence.
+ Remove that variable.

If the resulting graph can be made a tree, it’s possible to check
quickly if the CSP is solvable, otherwise is possible to try out another
variable assignment or node selection.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
