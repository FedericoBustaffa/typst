#import "@local/note_template:0.1.0": *
#show: doc => note_template([Bayesian Networks], doc)

#title()

The general case of Naive Bayes is represented by *bayesian networks*, that can
be arbitrarily more flexible, depending on their structure and what we decide to
model.

A bayesian network is a direct acyclic graph $cal(G) = (cal(V), cal(E))$ in
which nodes $v in cal(V)$ represent random variables, that are typically shaded
if observed, not shaded otherwise, and edges, describing the conditional
independence relationships.

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (Y1, Y2, Y3, Y4, Y5) = (
        (0, 0),
        (1.5, 0),
        (0.75, 1),
        (0, 2),
        (1.5, 2),
      )
      node(Y1, [$Y_1$], fill: color.aqua)
      node(Y2, [$Y_2$], fill: color.aqua)
      node(Y3, [$Y_3$])
      node(Y4, [$Y_4$], fill: color.aqua)
      node(Y5, [$Y_5$], fill: color.aqua)

      edge(Y1, "->", Y3)
      edge(Y2, "->", Y3, $P(Y_3 | Y_1, Y_2)$, label-side: left)
      edge(Y3, "->", Y4, $P(Y_4 | Y_3)$)
      edge(Y3, "->", Y5, $P(Y_5 | Y_3)$)
    },
  ),
  caption: [ Bayesian Network ],
) <fig-bayesian-net>

In a bayesian network, the *joint probability* is decomposed as

$ P(Y_1, dots, Y_N) = product_(i=1)^N P(Y_i | "parents" (Y_i)) $

In a *discrete* bayesian network parameters are represented by *conditional
probability tables (CPT)*. Letting $L$ be the maximum number of ingoing edges in
a bayesian network then, the number of parameters is at most

$ N dot (k - 1)^L $

basically saying that the _sparser_ the network, the less _complex_ are the
parameters.

#note(title: "Causal Interpretation")[
  Let's also notice that typically a *causal interpretation* is given to
  bayesian networks, but in general edges do not represent causality, only
  *statistical dependence*.
]

However can happen that, under further assumptions, edges might actually
coincide with the concept of _causal dependence_.

#pagebreak()

#important(title: "Local Markov Property")[
  Each node is conditionally independent of all its *non-descendants* given a
  *joint state of its parents*

  $
    Y_v perp Y_(V backslash "children"(v)) | Y_("parents" (v)) quad forall v in V
  $
]

= Fundamental Structures
