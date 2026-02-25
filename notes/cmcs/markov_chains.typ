#import "@preview/cetz:0.4.2"
#import "@local/note_template:0.1.0": *
#show: doc => note_template([Markov Chains], doc)

#title()

A possible extension of _transition systems_ are *Markov chains*, that can
basically be seen as transition systems with probabilities; each transition has
a certain probability, but the way to interpret it can change. In particular we
have two types of Markov chains:

- *Probabilistic* or *discrete time Markov chains (DTMC)*.
- *Stochastic*: or *continuous time Markov chains (CTMC)*.

= Discrete Time Markov Chains


In a DTMC, for every _outgoing_ edge is assigned a probability and for each
node, the sum of probabilities of its _outgoing edges_ must sum to $1$:

$ sum_(s' in S) P (s, s') = 1 $

where $S$ is a set of states.

#figure(
  cetz.canvas({
    import cetz.draw: *

    circle((0, 0), radius: 0.5, name: "s0")
    content("s0", $S_0$)

    circle((3, 0), radius: 0.5, name: "s1")
    content("s1", $S_1$)

    circle((6, 0), radius: 0.5, name: "s2")
    content("s2", $S_2$)

    set-style(line: (mark: (end: ">", fill: black)))

    line("s0", "s1")
    content((1.5, -0.35), $1$)

    line("s1", "s2")
    content((4.5, -0.35), $0.01$)

    set-style(arc: (mark: (end: ">", fill: black)))
    arc-through((6, 0.5), (6.5, 1), (6.5, 0), symbol: ">")
    content((7, 1.25), $1$)

    arc-through((3, 0.5), (1.5, 1.25), (0, 0.5), symbol: ">")
    content((1.5, 1.5), $0.99$)
  }),
  caption: "Discrete Time Markov Chain",
)

= Continuous Time Markov Chains
