#import "@local/note_template:0.1.0": *
#show: doc => note_template([Transition Systems], doc)

#title()

When we are interested in study *reachability* of a given *state* we cannot
deduce if some state could be reached only by running simulations. For this are
usually involved *transition systems*, that can be seen as some kind of automata
with every possible state reachable.

We can see the transition systems as *models of behavior* (like ODEs) and they
can be analysed by running stochastic simulations or through *model checking*.

#important(title: "Transition System")[
  A transition system is pair $(S , arrow.r)$ where

  - $S$ is a set of *states*.
  - $arrow.r subset.eq S times S$ is the *transition relation*.
]

With $s arrow.r s'$ we can denote the transition from state $s$ to state $s'$;
we can also use the notation $(s , s ')$ with $(s , s ') in S$. The notation
$s ↛$ denotes instead that there is no $s'$ in $S$ such that $s arrow.r s'$.

The transition system is essentially a graph used to model the behavior of a
system. Lets notice that the set of states can be infinite but typically
enumerable. Lets also notice that a transition describe the system state changes
and from a given state, we can have multiple possible new states, capturing
*non-deterministic* behaviors.

= Traces <traces>

Usually, in a transition system, a state $s_0$ is chosen as *initial state* and
a possible behavior starting from $s_0$ is called a *trace*.

#important(title: "Trace")[
  A *trace* $t$ of a transition system $(S , arrow.r)$ with initial state $s_0$,
  is a sequence of states $t = s_0 , s_1 , dots.h$ such that for each $s_(i +
  1)$ with $i in bb(N)$ in $t$ it holds $s_i arrow.r s_(i + 1)$.
]

Usually the only state $s_0$ is also called *minimal trace* and a generic trace
$t$ is called *maximal* if either $t$ is infinite or there are no possible
transitions from the last state of the sequence to the any other one.

#important(title: "Reachability")[
  A state $s$ of a transition system $(S , arrow.r)$ with initial state $s_0$ is
  *reachable* (from $s_0$) it there exists $s_1 , dots.h , s_n in S$ such that
  $s_1 , dots.h , s_n , s$ is a trace.
]

So we basically want to know if there is a path in the graph that can bring from
$s_0$ to $s$.

A particular class of transition systems are *Kripke Structures*, where states
are characterized by a set of *atomic propositions* that can be either true or
false.

#important(title: "Kripke Structure")[
  Given a finite set of atomic propositions $A P$, a Kripke structure $K$ is a
  _transition system_ $(S , arrow.r)$ where $S = cal(P) (A P)$.
]

In other words an atomic proposition $a$ is contained in a state if and only if
it is true in that state.

= Transition Systems over a set of variables
<transition-systems-over-a-set-of-variables>

Usually is natural to define the state as a composition of *variables*,
describing the *features* of it. Let's say we have every state composed by $n$
variables, each with $d$ possible values. Without this representation we need to
unify the three variables in one monolithic state; can be more convenient opting
for a modular representation.

#important(title: "Transition system over a set of variables")[
  Given a set of variables $X$ and a set of domains $D$

  $ X = { X_1 , dots.h , X_n } quad D = { D_1 , dots.h , D_n } $

  such that $D_i$ is the domain of $X_i$, a *transition system over* $X$ is a
  transition system $(S , arrow.r)$ with $S = D_1 times dots.h.c times D_n$.
]

Each domain should be a recursively enumerable set of values or, better, a
finite set of values. This is because the number of variables impact
significantly on the number of possible states of the transition system,
possibly leading to a *combinatorial explosion*.

== Specifying Transition Systems <specifying-transition-systems>

A transition system over a set of variables can be *specified* by giving a set
of *transition rules* having a similar semantic to an `if-then` statement:

$ "guard" -> "update" $

We in fact have a *guard*, composed by a _conjunction of conditions_ on the
state variables, each having the form

$ X_i op "Expr" $

where `op` is a comparison operator. For the *update*, that is a conjunction of
assignments, to state variables, we have instead the following formulation for
each variable

$ X_i^' = "Expr" $

with $X_i^'$ denoting the new value of $X_i$.

The idea is that, given $s_1$ and $s_2$, if $s_1$ satisfies the guard, $s_2$ can
be obtained by applying to $s_1$ the assignments described in the update rule.

= Labeled Transition Systems <labeled-transition-systems>

In or
We can extend normal transition systems with labels.

#important(title: "Labeled Transition Systems")[
  A *labeled transition system (LTS)* is a triple $(S , L , arrow.r)$ where

  - $S$ is a set of states.
  - $L$ is a set of labels.
  - $arrow.r subset.eq S times L times S$ is a labeled transition
    relation.
]

This kind of transition systems are usually well suited to model *concurrent
interactive systems* in a compositional way. The idea is to specify the LTS of
each component and combine them by taking synchronizations into account.

The role of transition labels is to describe the the action performed by the
system during the transition and usually the notation for internal, not
synchronized actions is a $tau$ label; for a potential action the system could
perform by interacting with another component, the labels can be arbitrarily
defined.

== Synchronization <synchronization>

Two possible approaches to synchronization are *binary* and *global*:

- *Binary*: in this case the non-$tau$ actions are split into two sets denoted
  as ${ a , b , dots.h }$ and ${ overline(a) , overline(b) , dots.h }$. The idea
  is that action $a$ has to be performed along with a transition with label
  $overline(a)$ of another component.
- *Global*: in this case non-$tau$ actions are synchronized among all system
  components. All components having a transition with label $a$ must perform
  such a transition together.

The synchronization of a number of transitions result in a new $tau$ transition.

