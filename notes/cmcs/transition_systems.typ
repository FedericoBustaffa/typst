#import "@local/note_template:0.1.0": *
#show: note_template

#title("Transition Systems") <transition-systems>

Transition systems can be seen as some kind of automata which aim to study
things like #emph[reachability] of a given #emph[state];. This because we cannot
deduce if some state could be reached only by running simulations.

We can see the transition systems as *models of behavior* (like ODEs) and they
can be analysed by running stochastic simulations or through _model checking_.

#important(title: "Transition System")[
  A transition system is pair $(S , arrow.r)$ where

  - $S$ is a set of #strong[states];.
  - $arrow.r subset.eq S times S$ is the #strong[transition relation];.
]

With $s arrow.r s'$ we can denote the transition from state $s$ to state $s'$;
we can also use the notation $(s , s ')$ with $(s , s ') in S$. The notation $s
↛$ denote instead that there is no $s'$ in $S$ such that $s arrow.r s'$.

The transition system is essentially a graph used to model the behavior of a
system. Lets notice that the set of states can be infinite but typically
enumerable. Lets also notice that a transition describe the system state changes
and from a given state, we can have multiple possible new states, capturing
#emph[non-deterministic] behaviors.

= Traces <traces>

Usually in a transition system a state $s_0$ is chosen as #emph[initial state]
and a possible behavior starting from $s_0$ is called a #strong[trace];.

#important(title: "Trace")[
  A *trace* $t$ of a transition system $(S , arrow.r)$ with initial state $s_0$,
  is a sequence of states $t = s_0 , s_1 , dots.h$ such that for each $s_(i +
  1)$ with $i in bb(N)$ in $t$ it holds $s_i arrow.r s_(i + 1)$.
]

Usually the only state $s_0$ is also called #strong[minimal trace] and a generic
trace $t$ is called #strong[maximal] if either $t$ is infinite or there are no
possible transitions from the last state of the sequence to the any other one.

== Reachability <reachability>

Finally, with traces, we can introduce the notion of #emph[reachability] of a
state.

#important(title: "Reachability")[
  A state $s$ of a transition system $(S , arrow.r)$ with initial state $s_0$ is
  #strong[reachable] (from $s_0$) it there exists $s_1 , dots.h , s_n in S$ such
  that $s_1 , dots.h , s_n , s$ is a trace.
]

So we basically want to know if there is a path in the graph that can bring from
$s_0$ to $s$.

A particular class of transition systems are #strong[Kripke Structures];, where
states are characterized by a set of #strong[atomic propositions] that can be
either true or false.

#important(title: "Kripke Structure")[
  Given a finite set of atomic propositions $A P$, a Kripke structure $K$ is a
  Transition System $(S , arrow.r)$ where $S = cal(P) (A P)$.
]

In other words an atomic proposition $a$ is contained in a state if and only if
it is true in that state.

= Transition Systems over a set of variables
<transition-systems-over-a-set-of-variables>

Very often the definition of the state of a transition system is based on a set
of variables describing the features of the state.

#important(title: "Transition system over a set of variables")[
  Given a set of variables $X = { X_1 , dots.h , X_n }$ and a set of domains
  ${ D_1 , dots.h , D_n }$ such that $D_i$ is the domain of $X_i$, a transition
  system over $X$ is a transition system $(S , arrow.r)$ with $S = D_1 times
  dots.h.c times D_n$.
]

Each domain should be a recursively enumerable set of values or, better, a
finite set of values. This is because the number of variables impact
significantly on the number of possible states of the transition system,
possibly leading to a #emph[combinatorial explosion];.

== Specifying Transition Systems <specifying-transition-systems>

A transition system over a set of variables can be #emph[specified] by giving a
set of #strong[transition rules] having a similar semantic to an `if-then`
statement. We in fact have a #strong[guard];, composed by a conjunction of
conditions on the state variables; and a #strong[update] that is a conjunction
of assignments to state variables.

The idea is that, given $s_1$ and $s_2$, if $s_1$ satisfies the #emph[guard]
$s_2$ can be obtained by applying to $s_1$ the assignments described in the
#emph[update] rule.

= Labeled Transition Systems <labeled-transition-systems>

We can extend normal transition systems with labels.

#important(title: "Labeled Transition Systems")[
  A labeled transition system (LTS) is a triple $(S , L , arrow.r)$ where

  - $S$ is a set of states.
  - $L$ is a set of labels.
  - $arrow.r subset.eq S times L times S$ is a labeled transition
    relation.
]

This kind of transition systems are usually well suited to model
#emph[concurrent interactive systems] in compositional way. The idea is to
specify the LTS of each component and combine them by taking synchronizations
into account.

The role of transition labels is to describe the the action performed by the
system during the transition and usually the notation for internal, not
synchronized actions is a $tau$ label; for a potential action the system could
perform by interacting with another component the labels can be arbitrary and
can explain the action.

== Synchronization <synchronization>

Two possible approaches to synchronization are #emph[binary] and #emph[global];:

- #strong[Binary];: in this case the non-$tau$ actions are split into two sets
  denoted as ${ a , b , dots.h }$ and ${ overline(a) , overline(b) , dots.h }$.
  The idea is that action $a$ has to be performed along with a transition with
  label $overline(a)$ of another component.
- #strong[Global];: in this case non-$tau$ actions are synchronized among all
  system components. All components having a transition with label $a$ must
  perform such a transition together.

The synchronization of a number of transitions result in a new $tau$ transition.

= References <references>

- Complex Systems
