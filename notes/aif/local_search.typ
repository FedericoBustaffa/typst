= Local Search
<local-search>
Sometimes a systematic search is not needed, because we’re not
interested in how we get the solution, we only want a solution. In this
sense, a #strong[local search] returns a solution, not the path to reach
it.

The main idea is to keep only #strong[one candidate] solution and
iteratively update it by moving in the direction of a better solution;
the search will terminate when reaching the goal (or get close enough).

== Deterministic Environment
<deterministic-environment>
There are many methods for local search, for example

- #strong[Hill-climbing];: an iterative process that uses an evaluation
  function to guide the search step by step. In machine learning this is
  the #strong[gradient descent] algorithm. This method can get stuck in
  local optima and in flat valleys, but there are some techniques to
  avoid that

  - #emph[Random restart];: if get stuck in local optima it choses a
    random point for restart the process.
  - #emph[Sideways moves];: if get stuck in flat valleys it moves
    sideways for max $K$ steps,

- #strong[Simulated annealing];: is a stochastic process where at each
  step a random solution is generated:

  - if it is better than the current it becomes the new current
    solution.
  - if instead it is worse it is accepted with a probability proportial
    to:
    - #strong[Temperature] $T$: parameter that starts with an high value
      that decrease typically with an exponential decrease
      $ T_t = k dot.op T_(t - 1) quad upright("with ") 0 < k < 1 $
    - $Delta E$: how worse is the new solution with respect to the
      current one.

    The probability of accepting a new worse solution is
    $e^(Delta E \/ T)$.

- #strong[Local Beam Search];: instead of keeping only one solution we
  keep $k$, expanding all of them, but in the end of one step we only
  keep the #strong[top-$k$];. This approach aim to abandon
  #emph[low-value] paths to focus on the most promising ones.

  To have better #emph[diversity] accross states we can perform a
  #strong[stochastic beam search] where we choose next states with a
  probability proportional to their value.

== Non-Deterministic Environment
<non-deterministic-environment>
In a #strong[non-deterministic environment] an action outcome is (or can
be) non-deterministic too. In this sense we don’t have a next state but
a #strong[belief state];, that can be seen as a #strong[set of possible
future states];.

In this kind of problems we have a #strong[conditional plan] as a
solution that is basically a #strong[tree] that represents an
#emph[if-then-else] chain. For this tree we can perform the classical
search algorithms, even though they are a little bit more complex
because now we have also different types of nodes.

In fact in this scenario are involved #strong[AND-OR search trees] where

- #strong[AND nodes] are provided by the environment and represent the
  set of all possible next states.
- #strong[OR nodes] are provided by the agent and represent the action
  to execute.

Typically the structure is composed by alternate levels of AND and OR
nodes; because given a state, the agent needs to do choose an action.
That action will lead to a new set of possible states. Keep going this
way soon or later the agent will reach a goal state.

#figure(image("and_or_search_tree.png"),
  caption: [
    AND-OR Search Tree|400
  ]
)

This tree can be searched for example with a DFS algorithm to find a
conditional plan.

=== Conformant Problems
<conformant-problems>
In the previous scenario we don’t have in advance the knowledge of the
next state, but after a move we can use the agent #emph[sensors] to get
a feedback of the current state.

There are cases were the agent can’t have feedbacks and so it has to
#strong[estimate] the state (still a belief state); this are called
#strong[conformant problems];.

This time we don’t have a conditional plan as solution because, as said
before we cannot have feedbacks. So the solution is now a sequence of
actions that we believe can bring to a certain state.

To search in these kind of problems is possible to use classical search
algorithms but this time the search is done in the belief space, not in
the state space. This is a way bigger space because now, the possible
actions on a belief state is the union or the intersection of all the
possible actions for a certain state and all the possible belief states
that action can generate.

More in general, we want to find sequence of actions that the agent can
blindly follow and arrive in a goal state. Typically we start from a set
composed of all the $n$ possible states and, expanding them causes the
creation of $n$ belief states. But doing this increase exponentially the
search space, so we need to #strong[prune];.

It is common practice to

- Prune all the already visited states, so that they won’t be repeated.
- Explore supersets: if we have to belief states $B_1$ and $B_2$ such
  that $B_1 subset.eq B_2$, it’s useless to explore first $B_1$ and then
  $B_2$ because what works for $B_2$ surely works also for $B_1$.
- Prune all belief states containing only states that will never bring
  to a goal state.

One technique starts by solving the problem for a given belief state,
this gives also the solutions for any subset as well.

== Questions
<questions>
- Simulated annealing only proceeds by random steps?

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
