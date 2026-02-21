#import "@local/note_template:0.1.0": *
#show: doc => note_template([Discrete Dynamical Systems], doc)

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot

#title()

In a *discrete dynamical system*, all the variables update at a discrete
time-step and each behavior is modeled by *recurrence relations*. This models
are typically used to model simple _population systems_ where individuals are
born, interact in some way and die.

Note that _"discrete"_ is referred only to time steps, not to state variables
that can be either discrete or continuous. In other words, we want to compute
the value of some *state variable*, let's say $N$, at time $t + Delta t$, where
$Delta t$ is fixed.

$ N (t + Delta t) $

A common assumption that must be made when working with discrete time steps is
that nothing happens in between $\[ t , t + Delta t \)$.

Another common assumption is also that if we are modelling something like a
population density, a new individual do not reproduce or die in between the time
step he was created and the next one.

Also to simplify the notation, by fixing the time step $Delta t$ we can write
recurrence equations by considering $Delta t$ as 1 time unit, regardless its
true value:

$ N(t) & = N_t quad and quad N(t + Delta t) & = N_(t+1) $

from _sequence theory_.

= Linear Birth Model

The simplest model we can think of is the *linear birth model*, which models the
number of individuals $N$ at a certain time $t + Delta t$, with the following
formulation

$
  N(t + Delta t) & = N(t) + lambda (Delta t) / sigma N(t) \
                 & = ( lambda (Delta t) / sigma + 1 ) N(t)
$

where $lambda$ is the number of children, each individual generates every
$sigma$ time units. In this sense $(Delta t) / sigma$ represents the number of
birth moments for every individual in the time interval $[t, t + Delta t)$.

Usually the model's equation can be simplified by boiling down all the
parameters (constant for all the duration of the simulation):

$ r_d = lambda (Delta t) / sigma + 1 $

where $r_d$ is usually called *birth rate*. So is now possible to describe the
system by this formula:

$ N_(t+1) = r_d dot.c N_t $

== Bacteria Duplication

A bacteria usually duplicates itself every 20 minutes ($1\/3$ hours),
producing $lambda = 1$ offspring:

$ N_(t+1) = (1 dot.c (1 \/ 3) / (1 \/ 3) + 1) N_t = 2 N_t $

Performing some time steps we can obtain a population evolution of this kind

#figure(
  cetz.canvas({
    import plot: *

    plot(
      size: (6, 4),
      x-tick-step: 1,
      y-tick-step: 100,
      axis-style: "left",
      add(domain: (0, 9), x => calc.pow(2, x)),
    )
  }),
  caption: [ Bacteria Exponential Growth ],
)

showing an *exponential growth*.

= General Term <general-term>

In general the recurrence relation is good to compute the value of some
variabile at a given moment in time, but by definition has a recursive nature
that implies the computation of $t - 1$ steps before computing the value at time
$t$.

In order to reduce the time and also gain some more information about the
problem is possible to get the *general term* (or _solution_) of the recurrence
relation.

This is usually done by trying to understand the form of the _closed formula_,
putting some value in the recurrence relation. Then prove that the found formula
is the solution of the recurrence by induction.

== Linear Birth Model

Let's consider again the linear birth model previously introduced and let's try
to compute the _general term_. We already know that the recurrence relation is

$ N_(t+1) = r_d N_t $

and, proceeding iteratively, we can compute

$
  N_1 & = r_d N_0 \
  N_2 & = r_d N_1 & = r_d^2 N_0 \
  N_3 & = r_d N_2 & = r_d^3 N_0
$

So it seems that the general term is

$ N_t = r_d^t N_0 $

To prove it by induction we can simply consider the recurrence and prove that
the property also holds for $N_(t+1)$:

$ N_(t+1) = r_d N_t = r_d r_d^t N_0 = r_d^(t+1) N_0 $

that proves the thesis.

= Equilibrium <equilibrium>

Another important aspect is *equilibrium point* of dynamical system; this is
obtained when, given a state variable $N$, the recurrence relation satisfies
$N_(t + 1) = N_t$.

For a linear birth model there is equilibrium if

$ N_(t+1) = r_d N_t = N_t $

but this is true only for $r_d = 1$, meaning no births at all.

= Interactions <interactions>

In general, every model that describes non-interacting individuals, is linear;
*non linear models* are introduced to model *interactions* among individuals,
like mating, hunting or infection spreading.

This component is central in complex systems if we are interested in seeing
*emerging behaviors* from simple components.

== Resource Consumer Model

One example can be a competition for limited resources: an environment has a
certain *carrying capacity* $K$, that can be seen as the maximum number of
individuals in that environment at the same time.

This is usually modelled by the *logistic equation*:

$ N_(t+1) = r_d N_t (1 - N_t / K) $

Equilibrium is also interesting when we come up with *non linear models*, that
are used to model *interactions*. Linear models describe systems in which
individuals do not interact and so the behavior of one individual does not
depend on others'.

In real complex systems, interactions lead to interesting emerging behavior, not
observable with only one individual or by merging single individual behaviors.

= Limitations <limitations>

A discrete model may introduce inaccuracies because recurrence equations assume
that nothing happens during the $Delta t$ time between $N_t$ and $N_(t + 1)$.
This can be acceptable but in most cases it is an approximation; so we can use
smaller $Delta t$ to gain accuracy. Actually we want to let $Delta t$ tend to 0
and introduce _continuous models_.
