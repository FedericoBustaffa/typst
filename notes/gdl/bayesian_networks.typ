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

The order to apply the chain rule is not fixed, for example considering the
bayesian network in @fig-bayesian-net we have that $Y_3$ has two parents to
choose first.

Another way to visualize it is by starting from the joint probability, for
example

$ P(Y_1, Y_2, Y_3) $

and observing that, different orders of chain rule application produce different
networks

#figure(
  grid(
    columns: 2,
    gutter: 1cm,
    {
      diagram(
        node-shape: "circle",
        node-stroke: 1pt,
        edge-stroke: 1pt,
        {
          let (Y1, Y2, Y3) = (
            (0, 0),
            (0, 1),
            (0, 2),
          )
          node(Y1, [$Y_1$])
          node(Y2, [$Y_2$])
          node(Y3, [$Y_3$])

          edge(Y1, "->", Y2)
          edge(Y2, "->", Y3)
          edge(Y1, "->", Y3, bend: 45deg)

          node(
            (-0.8, 1),
            [$P(Y_3) P(Y_2 | Y_3) P(Y_1 | Y_2, Y_3)$],
            stroke: 0pt,
          )
        },
      )
    },
    {
      diagram(
        node-shape: "circle",
        node-stroke: 1pt,
        edge-stroke: 1pt,
        {
          let (Y1, Y2, Y3) = (
            (0, 0),
            (0, 1),
            (0, 2),
          )
          node(Y1, [$Y_1$])
          node(Y2, [$Y_3$])
          node(Y3, [$Y_2$])

          edge(Y1, "->", Y2)
          edge(Y2, "->", Y3)
          edge(Y1, "->", Y3, bend: 45deg)

          node((0.9, 1), [$P(Y_3)P(Y_2 | Y_3) P(Y_1 | Y_2, Y_3)$], stroke: 0pt)
        },
      )
    },
  ),
  caption: [ Chain Rule Ordering ],
) <fig-chain-rule-order>

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

= Local Markov Property

A very useful assumption if independence bayesian networks do, can be exploited
with the *local Markov property*, that again reduces the number of parameters to
model the joint distribution.

#important(title: "Local Markov Property")[
  Each node is conditionally independent of all its *non-descendants* given a
  *joint state of its parents*

  $
    Y_v perp Y_(V minus "children"(v)) | Y_("parents" (v)) quad forall v in V
  $
]

Considering the @fig-bayesian-net network, we can say that $Y_1$ and $Y_2$ are
_marginally independent_, however the local Markov property does not support
$Y_1 perp Y_2 | Y_3$. Instead it does support $Y_4 perp Y_1 | Y_3$ because $Y_1$
is not a descendant of $Y_4$.

A typical application of chain rule and local Markov property is

+ Pick a *topological ordering* of nodes.
+ Apply the *chain rule* following the order.
+ Use the *conditional independence assumptions*.

Again, considering the network in @fig-bayesian-net we can follow the order of
the enumeration and derive

$
  P(Y_1, Y_2, Y_3, Y_4, Y_5) & = P(Y_1) P(Y_2 | Y_1) P(Y_3 | Y_1, Y_2) P(Y_4 |
                                 Y_1, Y_2, Y_3) P (Y_5 |
                                 Y_1, Y_2, Y_3, Y_4) \
                             & = P(Y_1) P(Y_2) P(Y_3 | Y_1, Y_2) P(Y_4 | Y_3)
                               P(Y_5 | Y_3)
$

So by applying the rule again we reduced the number of parameters of the
networks by assuming the local

== Generative Process

A bayesian network, once built, can be seen as a *generative process* for
observations, composed by these steps:

+ Pick a *topological ordering* of nodes.
+ Generate data by sampling from the local conditional probabilities following
  the order.

Considering again the network in @fig-bayesian-net and the factorized
representation of it obtained by the local Markov property, we can sample from
each variable

$
  y_1 & tilde P(Y_1) \
  y_2 & tilde P(Y_2) \
  y_3 & tilde P(Y_3 | Y_1 = y_1, Y_2 = y_2) \
  y_4 & tilde P(Y_4 | Y_3 = y_3) \
  y_5 & tilde P(Y_5 | Y_3 = y_3)
$

just to have a first glimpse of why these are also called _generative_ models.

= Fundamental Structures

In bayesian networks there are three *fundamentals substructures* that
determine the conditional independence relationships: *fork*, *chain* and
*collider*.

#figure(
  diagram(node-stroke: 1pt, {
    let (Y1, Y2, Y3) = ((0, 0), (1, 0), (2, 0))
    node(Y1, [$Y_1$])
    node(Y2, [$Y_2$])
    node(Y3, [$Y_3$])
    edge(Y2, "->", Y1)
    edge(Y2, "->", Y3)
    node((3, 0), [Fork], stroke: 0pt)

    node((0, 0.75), [$Y_1$])
    node((1, 0.75), [$Y_2$])
    node((2, 0.75), [$Y_3$])
    edge((0, 0.75), "->", (1, 0.75))
    edge((1, 0.75), "->", (2, 0.75))
    node((3, 0.75), [Chain], stroke: 0pt)

    node((0, 1.5), [$Y_1$])
    node((1, 1.5), [$Y_2$])
    node((2, 1.5), [$Y_3$])
    edge((0, 1.5), "->", (1, 1.5))
    edge((2, 1.5), "->", (1, 1.5))
    node((3, 1.5), [Collider], stroke: 0pt)
  }),
  caption: [ Fork, Chain and Collider ],
)

The *fork* corresponds to

$ P(Y_1, Y_3 | Y_2) P(Y_2) = P(Y_1 | Y_2) P(Y_3 | Y_2) P(Y_2) $

If $Y_2$ is unobserved, then $Y_1$ and $Y_3$ are *marginally dependent*:

$ Y_1 cancel(perp) Y_3 $

If instead $Y_2$ is observed then $Y_1$ and $Y_3$ are *conditionally
independent*:

$ Y_1 perp Y_3 | Y_2 $

#note[
  When $Y_2$ is observed is said to *block the path* from $Y_1$ to $Y_3$.
]

The *chain* corresponds to

$
  P(Y_1, Y_2, Y_3) & = P(Y_1) P(Y_2 | Y_1) P(Y_3 | Y_2) \
                   & = P(Y_1 | Y_2) P(Y_3 | Y_2) P(Y_2)
$

If $Y_2$ is unobserved, then $Y_1$ and $Y_3$ are *marginally dependent*:

$ Y_1 cancel(perp) Y_3 $

If instead $Y_2$ is observed then $Y_1$ and $Y_3$ are *conditionally
independent*:

$ Y_1 perp Y_3 | Y_2 $

#note[
  When $Y_2$ is observed is said to *block the path* from $Y_1$ to $Y_3$.
]


The *collider* corresponds to

$ P(Y_1, Y_2, Y_3) = P(Y_1) P(Y_3) P(Y_2 | Y_1, Y_3) $

If $Y_2$ is observed, then $Y_1$ and $Y_3$ are *conditionally dependent*:

$ Y_1 cancel(perp) Y_3 | Y_2 $

If instead $Y_2$ is unobserved then $Y_1$ and $Y_3$ are *marginally
independent*:

$ Y_1 perp Y_3 $

#note[
  If any $Y_2$ descendant is observed it *unlocks the path*.
]

More in general, let $r = (Y_1 <-> dots.c <-> Y_2)$ be an *undirected path*
between $Y_1$ and $Y_2$, then $r$ is *blocked* by a set $Z$ if $r$ contains

- A _fork_ $Y_i <- Y_c -> Y_j$ such that $Y_c in Z$.
- A _chain_ $Y_i -> Y_c -> Y_j$ such that $Y_c in Z$.
- A _collider_ $Y_i -> Y_c <- Y_j$ such that neither $Y_c$ nor its descendants
  are in $Z$.

== Global Markov Property

Let's now introduce the concept of *$d$-separation* for a path in the bayesian
network

#important(title: [$d$-Separated Path])[
  Let $r = Y_1 <-> dots.c <-> Y_2$ be an *undirected path* between $Y_1$ and
  $Y_2$, then $r$ is *$d$-separated by $Z$* if there exist at least one node
  $Y_c in Z$ for which path $r$ is blocked.
]

An example can be a simple collider where the child is osberved

#figure(
  diagram(
    node-stroke: 1pt,
    {
      node((0, 0), [$Y_1$])
      node((1, 0), [$Y_c$], fill: color.aqua)
      node((2, 0), [$Y_2$])
      edge((0, 0), "->", (1, 0))
      edge((2, 0), "->", (1, 0))
    },
  ),
  caption: [ $d$-Separated Collider ],
) <fig-dsep>

The concept of $d$-separation is also defined for two nodes

#important(title: [$d$-Separation])[
  Two nodes $Y_i$ and $Y_j$ in a bayesian network $cal(G)$ are said to be
  *$d$-separated by $Z subset cal(V)$*:

  $ "Dsep"_cal(G) (Y_i, Y_j | Z) $

  if and only if all undirected paths between $Y_i$  and $Y_j$ are $d$-separated
  by $Z$.

  $ Y_1 perp_cal(G) Y_2 | Z $
]

One example can still be the collider in @fig-dsep considering $Y_1$ and $Y_2$
to be $d$-separated by $Y_c$.

The concept of $d$-separation let us define the *global Markov property* for an
entire bayesian network.

#important(title: "Global Markov Property")[
  A bayesian network respects the *global Markov property* whenever
  $d$-separations in the graph imply conditional independence relations.
]

#note[
  Global and local Markov properties are equivalent.
]

From this properties of conditional independence is possible to derive the
*Markov blanket* of a node.

#important(title: "Markov Blanket")[
  The *Markov blanket* $"Mb" (Y)$ of a node $Y$ is the minimal set of vertices
  that *shields the node* from the rest of the network.
]

In a DAG the Markov blanket of $Y$ contains its

- *Parents*: knowing a parent $Y_p$ blocks the path to parents and children of
  $Y_p$ (confounder and chain block condition).
- *Children*: knowing the children blocks the path to children's children.
- *Childrens' parents*: knowing the children unblocks the path to parents' of
  children so we have to condition also them.

This means that the behavior of a node can completely be determined and
predicted by its Markov blanket:

$ P(Y | "Mb" (Y), Z) = P(Y | "Mb" (Y)) quad forall Z in.not "Mb" (Y) $

== Faithfulness Property

The *faithfulness property* gives us a strong assumption with Markov properties.

#important(title: "Faithfulness")[
  A bayesian network is *faithful* whenever conditional independence relations
  imply $d$-separation.

  $ Y_1 perp Y_2 | Z ==> Y_1 perp_cal(G) Y_2 | Z $
]

While the global Markov property requires the graph to represent *only*
conditional independences, the _faithfulness_ requires to represent *all*
conditional independences.

The faithfulness is fundamental to represent concisely joint distributions
because the more conditional independences we represent the less parameters we
need to store in the model.

