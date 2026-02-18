#import "@local/note_template:0.1.0": *
#show: note_template

#title("Discrete Systems") <discrete-systems>

In a #strong[discrete dynamical system];, all the variables update at a discrete
time-step and each behavior is modeled by #strong[recurrence relations];. This
models are typically used to model simple #emph[population systems] where
individuals are born, interact in some way and die.

Note that _"discrete"_ is referred only to time steps, not to state variables
that can be either discrete or continuous. In other words, we want to compute
the value of some *state variable* (for example $N$) at time $t + Delta t$,
where $Delta t$ is fixed.

$ N (t + Delta t) $

A common assumption that must be made when working with discrete time steps is
that nothing happens in between $\[ t , t + Delta t \)$. Another common
assumption is also that if we are modelling something like a population density,
a new individual do not reproduce or die in between the time step he was created
and the next one.

= General Term <general-term>

In general the recurrence relation is good to compute the value of some
variabile at a given moment in time, but by definition has a recursive nature
that implies the computation of $t - 1$ steps before computing the value at time
$t$.

In order to reduce the time and also gain some more information about the
problem is possible to get the #strong[general term] (or #emph[solution];) of
the recurrence relation.

This is usually done by trying to understand the form of the #emph[closed
  formula] by putting some value in the recurrence relation. Then prove that the
found formula is the solution of the recurrence by induction.

= Equilibrium <equilibrium>

Another important aspect is #strong[equilibrium point] of dynamical system; this
is obtained when, given a state variable $N$, the recurrence relation satisfies
$N_(t + 1) = N_t$.

== Interactions and non linear models <interactions-and-non-linear-models>

Equilibrium is also interesting when we come up with *non linear models*, that
are used to model #strong[interactions];. Linear models describe systems in
which individuals do not interact and so the behavior of one individual does not
depend on other’s.

In real complex systems, interactions lead to interesting emerging behavior, not
observable with only one individual or by merging single individual behaviors.

= Limitations <limitations>

A discrete model may introduce inaccuracies because recurrence equations assume
that nothing happens during the $Delta t$ time between $N_t$ and $N_(t + 1)$.
This can be acceptable but in most cases it is an approximation; so we can use
smaller $Delta t$ to gain accuracy. Actually we want to let $Delta t$ tend to 0
and introduce #emph[continuous models];.

= References <references>

- Complex Systems
