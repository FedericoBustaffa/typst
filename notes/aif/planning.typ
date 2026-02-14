= Planning
<planning>
In the classical way of #strong[planning] the aim is to find a
#strong[sequence of actions] to accomplish a goal in a discrete,
deterministic, static and fully observable environment.

This is already done by agents via search algorithms or by logical
agents via inference, and there are ad-hoc languages to implement this
kind of stuff, like #strong[planning domain definition language (PDDL)];.

In this kind of languages it is possible represent a combinatorial
number of actions with a single schema, and in the end return a
#emph[plan];.

A core component in PDDL are states, that are basically a
#strong[conjunction of #emph[ground atomic fluents];];, where

- #strong[Ground] means that there are no variables.
- #strong[Atomic] means that is a single literal with no structure.
- #strong[Fluents] is an aspect of the world that changes over time.

Another important component is the #strong[action];, for which we can
define a #emph[schema] composed by:

- #emph[Name];: the name of the action.
- #emph[Variables];: a list of variables involved in the action.
- #emph[Precondition];: conjuctions of literals.
- #emph[Effect];: conjunctions of literals.

We can assign values to variables, resulting in a ground action.

A set of action schemas defines the #strong[planning domain] and for a
problem in the domain is necessary to add the #emph[initial state]
(formed by a conjunction of ground fluents) and the #emph[goal state]
(formed by a conjunction of literals).

Given an action with precondition $P$, the action is applicable in a
state $s$ if and only if $S tack.r.double P$. Every positive literal in
$P$ must also hold in $s$ and every negated laiteral in $P$ must not be
present in $s$.

The result of an action is a new state with all fluents from the
previous state, from which it’s necessary to

- Remove fluents appearing as negated literals in the action’s effects.
- Add fluents appearing as positive literals in an action’s effects.

== Algorithms for Planning
<algorithms-for-planning>
In order to find an actual plan, typically we can start from a
declarative representation, and it’s possible to proceed in two ways:
#emph[forward] or #emph[backward];.

In the #strong[forward] case the start is the initial state, then it’s
necessary to #strong[unify] the current state agains the preconditions
of each action schema to find the #emph[applicable] actions. Then, by
applying each resulting substitution, is possible to get a ground action
that we can apply.

In the #strong[backward] the start is the goal state and considering
#strong[relevant actions];, we can say that, their effect #emph[unifies]
with one of the goal’s literals and none of its effects negates any part
of the goal. Applying any relevant until the initial state is reached.

As many backward approaches the branching factor is reduced, because
only relevant actions are considered (DFS-like), while the forward
approach goes on until the goal state is reached (BFS-like).

== Heuristics
<heuristics>
Even for planning algorithms is possible to design #strong[heuristics]
by thinking about exact solutions for relaxed problems.

For example we can use the #strong[ignore precondition heuristic];, that
assumes that every action is applicable (drop preconditions). From each
action’s effect keep only literals present in the goal. Find the minimum
number of actions needed such that the union of the actions’ effects
satisfy the goal. This is an #emph[admissible] heuristic that leads to a
#emph[greedy] algorithm for an approximate solution.

Another is the #strong[ignore delete list heuristic] that removes
negative literals from actions’ effect. This allows to make monotonic
steps towards the goal since no action can undo previous steps.

=== Domain Independent Pruning
<domain-independent-pruning>
The #strong[symmetry reduction heuristic] prunes every symmetric
branches of the tree but one.

The #strong[forward pruning] prunes away branches based on a
#emph[preferred action];, getting a relaxed plan that solves a relaxed
version of the problem.

=== Reducing State Space Size
<reducing-state-space-size>
Another approach is based on the reduction of state space size, unlike
action based heuristics.

The #strong[state abstraction heuristic] applies a #emph[many to one]
mapping from states to the abstract representation. It removes some
fluents to get an approximate solution and, if possible, adds back some
fluents to recover the exact solution.

The #strong[decomposition heuristic] divides a problem into parts,
solving each part independently, and then combining the parts. For this
a #strong[sub-goal independence assumption] must be held: the cost of
solving a conjunction of subgoals is approximated by the sum of the
costs of solving subgoal independently.

== Hierarchical Planning
<hierarchical-planning>
In order to mitigate #emph[explosion of action] in the final plan is
possible to abstract away some details and build hierarchical
structures.

- #strong[High level action (HLA)];: admits one or more refinements to a
  sequence of actions.
- #strong[High level plan (HLP)];: a sequence of HLAs that, in its
  implementation concatenates the implementation of all HLAs. HLP
  achieves the goal if at least one of its implementation achieves the
  goal.

An example of this is the #strong[hierarchical forward planning] that,
starting from a HLP with a single HLA, that HLA needs to reach the goal.
It uses BFS to find possible refinements of each HLA in the current
plan.

== Sensorless Planning
<sensorless-planning>
An extension of planning can be defined also for #strong[sensorless]
agents, that keep a #emph[belief state] and act under an
#strong[open-world assumption] (if a fluent does not appear, then its
value is #strong[unknown];).

The agent acts under a #strong[conditional effect];, where a
#emph[condition] is a logical formula to be compared against the current
belief and the #emph[effect] is a formula that describes the resulting
state.

In this case can happen that the action’s effect might depend on the
unknown state and dealing with all possible ramifications easily make
the number of fluents in a belief state grows exponentially.

== Online Planning
<online-planning>
A potentially more flexible apprach is #strong[online planning] where
the agents plans as it explores more the environment. This can be useful
for non-deterministic environments, for example when

- #strong[Execution monitoring];: there is the need for for a new plan.
- There are too many contingencies to prepare for.
- A contingency is not prepared, #strong[replanning] is required.
- The agent’s model of the world turns out to be incorrect and so a
  replanning is needed.

The are basically three appraches for this:

- #strong[Action monitoring];: before executing an action, the agent
  verifies that all the preconditions still hold.
- #strong[Plan monitoring];: before executing an action, the agent
  verifies that the remaining plan will still succeed.
- #strong[Goal monitoring];: before executing an action, the agent
  checks to see if there is a better set of goals it could be trying to
  achieve.

== Constraints
<constraints>
The classical planning takes into account only the actions sequence, but
doest consider the actual time or resources needed for every action, in
order to performed.

In this way we can omit some #strong[constraints] given by the problem,
failing to solve it. A more realistic agent should take into account the
type and number of resources it needs to perform an action and also if
the resource is consumable or reusable.

Typically this problems are addressed by first #strong[plan] and then
#strong[schedule];:

- In the #strong[planning phase] actions are selected, with some
  ordering constraints, to meet the goals of the problem.
- In the #strong[scheduling phase] temporal information is added to the
  plan to ensure that it meets resource and deadline constraints.

This approach is common in real world manufacturing and logistical
settings.

In order to solve the scheduling problem we can define a #strong[partial
order] plan that is a path in a directed graph that allows multiple
actions to be taken in parallel from initial to goal state.

The #strong[critical path] is the the one with the longest total
duration and determines the duration of the entire plan.

Actions that are off the critical path typically have a #emph[window] of
time, called #strong[slack];, in which they can be executed. For this
type of scheduling greedy heuristics like #emph[minimum slack heuristic]
work quite well.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
- \[\[logical\_agents\]\]
- \[\[first\_order\_logical\_agents\]\]
- \[\[work\_span\_model\]\]
