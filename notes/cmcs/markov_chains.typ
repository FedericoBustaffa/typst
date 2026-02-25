#import "@local/note_template:0.1.0": *
#show: doc => note_template([Markov Chains], doc)

#title()

A possible extension of _transition systems_ are *Markov chains*, that can
basically be seen as transition systems with probabilities; each transition has
a certain probability, but the way to interpret it can change. In particular we
have two types of Markov chains:

- *Discrete time Markov chains (DTMC)* or *probabilistic*.
- *Continuous time Markov chains (CTMC)* or *stochastic*.

Both with similar properties but with slightly different behaviors.

= Discrete Time Markov Chains

A DTMC is a transition system with an assigned probability for each _outgoing_
edge of a node.

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (S0, S1, S2) = ((0, 0), (2, 0), (4, 0))
      node(S0, [$S_0$])
      node(S1, [$S_1$])
      node(S2, [$S_2$])

      edge(S0, "->", S1, $1$)
      edge(S1, "->", S0, $0.99$, bend: -65deg)
      edge(S1, "->", S2, $0.01$)
      edge(S2, "->", S2, $1$, bend: 130deg, loop-angle: 90deg)
    },
  ),
  caption: "Discrete Time Markov Chain",
) <fig-dtmc>

#important(title: "Discrete Time Markov Chain")[
  A DTMC is a pair $(S, P)$ where

  - $S$ is a set of states.
  - $P : S times S arrow [0, 1]$ is the *probability transition matrix*, such
    that for all $s in S$ it holds
    $ sum_(s' in S) P (s, s') = 1 $
]

When the set of states $S = { s_0, dots, s_n }$ is finite, the probability
transition matrix can be represented as a square matrix:

$
  mat(
    delim: "[",
    p_(00), dots.c, p_(0n);
    dots.v, dots.down, dots.v;
    p_(n 0), dots.c, p_(n n);
  )
$

where $P_(i j) = P(s_i, s_j)$ and the sum of each row is equal to $1$. The
transition matrix of @fig-dtmc is in fact

$
  mat(
    delim: "[",
    0, 1, 0;
    0.99, 0, 0.01;
    0, 0, 1
  )
$

Usually for DTMC we don't have a given initial state but a *probability
distribution of initial states*, represented as a vector. For example the vector

$ mat(delim: "[", 1, 0, 0) $

means that $s_0$ is the initial state, while the vector

$ mat(delim: "[", 0.5, 0.5, 0) $

means that $s_0$ and $s_1$ are equally likely to be the initial state.

== Probabilistic Reachability

A similar concept to transition systems' trace is *path* for DTMC

#important(title: "Path")[
  A *path* $pi$ of a DTMC $(S, P)$ with initial state $s_0$, is a (possibly
  infinite) sequence of states $pi = s_0, s_1, dots$ such that for each
  $s_(i+1)$, with $i in bb(N)$ in $pi$ it holds

  $ P(s_i, s_(i+1)) > 0 $
]

The probability of a _path_ to be taken is simply the product of the
probabilities of its transitions:

$
  "Prob" (s_0, s_1, dots, s_n) & = product_(i=0)^(n-1) P(s_i, s_(i+1)) \
       "Prob" (s_0, s_1, dots) & = product_(i in bb(N)) P(s_i, s_(i+1))
$

In this sense is possible to compute the probability for a system to reach a
given state. Since, different paths are independent events, their probability
can be summed if the _goal state_ is the same.

#important(title: "Probabilistic Reachability")[
  The *probability of reaching* state $s$ of a DTMC $(S, arrow)$ from the
  initial state $s_0$, is the sum of probabilities of all paths leading to it:

  $ "ProbReach" (s_0, s) = sum_(pi in "Reach" (s_0, s)) "Prob" (pi) $

  where $"Reach" (s_0, s)$ is the (possibly infinite) set of paths reaching $s$
  from $s_0$.
]

Again, considering the DTMC in @fig-dtmc, is possible to compute the probability
of reaching $s_2$ from $s_0$:

$
  "ProbReach" (s_0, s_2) & = 1 dot 0.01 \
                         & = 1 dot 0.99 dot 1 dot 0.01 \
                         & = (1 dot 0.99)^2 dot 1 dot 0.01 \
                         & dots.v \
                         & = (1 dot 0.99)^n dot 1 dot 0.01 \
                         & dots.v \
                         & = 1
$

Of course is possible to avoid the infinite sum, considering the opposite
problem: the only path not leading to $s_2$ is the infinite loop from $s_0$ to
$s_1$ and viceversa. This is basically equal to compute

$ (1 dot 0.99)^infinity = 0 $

hence it is an infinite product of numbers smaller than $1$. But this is still
stricly related to this DTMC instance. A more general way to solve the same
problem is to set a *linear system of equations* like the following:

$
  cases(
    x_(s_2) = 1,
    x_(s_1) = 0.01 x_(s_2) + 0.99 x_(s_0),
    x_(s_0) = x_(s_1)
  )
$

that in general can be solved with any algorithm for linear systems and obtain
that $x_(s_0) = 1$. In general, every equation of the system represents the
probability of reaching the goal state from every other state. With this method
is now possible to automatically compute the probability of reaching a certain
state, and so is also possible to compute the probability of reaching every
state from any other just by solving multiple linear systems as before.

= Continuous Time Markov Chains

In the case of *continuous time Markov chains* we extend the concept of
transition systems by introducing *rates*.

#important(title: "Continuous Time Markov Chain")[
  A *continuous time Markov chain* is a pair $(S, R)$ where

  - $S$ is a set of states
  - $R : S times S arrow bb(R)^+$ is the *transition rate matrix*
]

Can happen that, given a CTMC, there exist multiple $s'$ with $R(s, s') > 0$,
causing a *race condition* in which the _fastest_ transition determines the
next state of the system.

With CTMC we can now model *how much time is spent in a state* $s$ before
transition. That can be done by assigning an exponential distribution to each
transition, which models how likely is it to occur.

Using the property of exponential distributions being independent and
identically distributed, we can use just one with its parameter being the sum

$ E(s) = sum_(s' in S) R (s, s') $

that is called *exit rate* (the rate of exit from state $s$).

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (S0, S1, S2) = ((0, 0), (1.5, 0), (0.75, 1.5))
      node(S0, [$S_0$])
      node(S1, [$S_1$])
      node(S2, [$S_2$])

      edge(S0, "->", S1, $2$)
      edge(S0, "->", S2, $3$, label-side: right)
      edge(S1, "->", S2, $4$, label-side: left)
    },
  ),
  caption: "Continuous Time Markov Chain",
) <fig-ctmc>

For example in @fig-ctmc we have that _exit rate_ of $S_0$ is $5$.

Another thing to model is *which transition is taken* from state $s$,
considering that the choice is independent from the time at which it occurs and
the probability is proportional to the rate of each transition.

More in general, the probability of the next transition to occur is given by the
*embedded DTMC of the CTMC*, that describes the state changes of the CTMC by
ignoring time. It can be obtained by *normalizing* the transition rates of the
CTMC with respect to the exit rate of each state.

#figure(
  grid(
    columns: 2,
    gutter: 2cm,
    {
      diagram(
        node-shape: "circle",
        node-stroke: 1pt,
        edge-stroke: 1pt,
        {
          let (S0, S1, S2) = ((0, 0), (1.5, 0), (0.75, 1.5))
          node(S0, [$S_0$])
          node(S1, [$S_1$])
          node(S2, [$S_2$])

          edge(S0, "->", S1, $2$)
          edge(S0, "->", S2, $3$, label-side: right)
          edge(S1, "->", S2, $4$, label-side: left)
        },
      )
    },
    {
      diagram(
        node-shape: "circle",
        node-stroke: 1pt,
        edge-stroke: 1pt,
        {
          let (S0, S1, S2) = ((0, 0), (1.5, 0), (0.75, 1.5))
          node(S0, [$S_0$])
          node(S1, [$S_1$])
          node(S2, [$S_2$])

          edge(S0, "->", S1, $2 \/ 5$)
          edge(S0, "->", S2, $3 \/ 5$, label-side: right)
          edge(S1, "->", S2, $1$, label-side: left)
          edge(S2, "->", S2, $1$, bend: 130deg, loop-angle: -90deg)
        },
      )
    },
  ),
  caption: "Embedded DTMC of a CTMC",
) <fig-embedded-dtmc>

#important(title: "Embedded DTMC")[
  Given a CTMC $(S, R)$, its embedded DTMC is the DTMC $(S, P)$ where, for any
  $s, s' in S$ it holds

  $
    P(s, s') = cases(
      R (s, s') \/ E(s) "if" E(s) > 0,
      1 "if " E(s) = 0 "and" s = s',
      0 "otherwise"
    )
  $
]

So now is possible to compute the probability of reaching a given state at _any
time_ just by computing the _probabilistic reachability_ of the same state in
the corresponding embedded DTMC.

== Transient Probabilistic Reachability

Given a CTMC is also possible to compute the probability of reaching a certain
state at a given amount of time.

This can be done by *uniformisation*, that basically introduces a
*uniformisation rate* $q$ that is greater or equal to all the _exit rates_ of
the CTMC states.

After choosing a uniformisation rate, every transition rate $r$ is transformed
into probability $r / q$, giving us the *uniformised DTMC* of the CTMC.

#figure(
  grid(
    columns: 2,
    gutter: 2cm,
    {
      diagram(
        node-shape: "circle",
        node-stroke: 1pt,
        edge-stroke: 1pt,
        {
          let (S0, S1, S2) = ((0, 0), (1.5, 0), (0.75, 1.5))
          node(S0, [$S_0$])
          node(S1, [$S_1$])
          node(S2, [$S_2$])

          edge(S0, "->", S1, $2$)
          edge(S0, "->", S2, $3$, label-side: right)
          edge(S1, "->", S2, $4$, label-side: left)
        },
      )
    },
    {
      diagram(
        node-shape: "circle",
        node-stroke: 1pt,
        edge-stroke: 1pt,
        {
          let (S0, S1, S2) = ((0, 0), (1.5, 0), (0.75, 1.5))
          node(S0, [$S_0$])
          node(S1, [$S_1$])
          node(S2, [$S_2$])

          edge(S0, "->", S1, $0.2$)
          edge(S0, "->", S2, $0.3$, label-side: right)
          edge(S1, "->", S2, $0.4$, label-side: left)
          edge(S0, "->", S0, $0.5$, bend: 130deg, loop-angle: +90deg)
          edge(S1, "->", S1, $0.6$, bend: 130deg, loop-angle: +90deg)
          edge(S2, "->", S2, $1$, bend: 130deg, loop-angle: -90deg)
        },
      )
    },
  ),
  caption: [ Uniformised CTMC with $q = 10$ ],
) <fig-uniformised-dtmc>

#note[
  If $q = E(s)$ for some $s$, of course the probabilities of the outgoing edges
  of that node will sum to $1$. In case $q > E(s)$ that won't happens except if
  we add self-loops taking the remaining probability.
]

The uniformisation rate $q$ should be chosen large enough to assume that at most
one transition can occur during a $1 / q$ time interval (because this MC
describes a step with duratioun $1 / q$).

Similarly as before we can now compute the *transient probabilistic
reachability* in the uniformised DTMC as before, also taking into account the
length of the paths.

