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



= Continuous Time Markov Chains


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
  caption: "Embedded DTMC of a CTMC",
) <fig-uniformised-dtmc>
