#import "@local/note_template:0.1.0": *
#show: doc => note_template([Bayesian Networks], doc)

#title()

In the field of probabilistic models in machine learning, *Bayesian networks*
define a _building block_ on which a large class of models is based. Bayesian
networks define a framework in order to work with probability distributions in a
more _automated_ way, also defining useful assumptions to ease the computation
while keeping a certain level of expressive power.

When working with probabilistic models a fundamental thing to do is to write the
*joint probability distribution*. That without knowing anything about the data
can be both computational and memory consuming.

Let's suppose to have three _discrete_ random variables $Y_1$, $Y_2$ and $Y_3$,
their joint probability can be represented with a *conditional probability table
(CPT)*. The problem with that representation is that it takes into account all
the possible combinations of values for each random variable, that in general is
$k^N - 1$ (in this case $k=2$) where $k$ is the number of possible values for
each random variable and $N$ is the number of random variables.

We can also define the joint probability by using the chain rule:

$ P(Y_1, Y_2, Y_3) = P(Y_1) dot P(Y_2 | Y_1) dot P(Y_3 | Y_1, Y_2) $

but this doesn't solve the problem at all because we still have the same number
of parameters, since the chain rule just gives an order and a more compact way
to write the joint distribution; it doesn't affect the number of parameters.

= Representation in BNs

In order to reduce the exponential number of parameters we need to do some
approximation, in particular is possible to exploit *conditional independence
assumptions*. In general, (conditional) independence is nice because simplifies
the factorization of a joint probability; for example, the previous chain rule
factorization becomes

$
  P(Y_1, Y_2, Y_3)
  = underbrace(P(Y_1), 1) dot underbrace(P(Y_2 | Y_1), 2) dot
  underbrace(P(Y_3 | Y_2, Y_1), 4)
  = underbrace(P(Y_1), 1) dot underbrace(P(Y_2), 1) dot underbrace(P(Y_3), 1)
$

if we assume that every variable is conditionally independent given the others,
that is much nicer to compute. Still we don't want to lose relations between
variables that are crucial to have a model expressive enough to perform good.

#note[
  Bayesian networks offer a way to represent *joint probability distributions*,
  placing conditional independence assumptions automatically, depending on the
  structure of the BN itself.
]

In other words we now have a way to define arbitrarily complex relations among
random variables, by changing the network structure. That structure also defines
where conditional independence assumptions must be applied, in order to ease the
computation.

Graphically, a bayesian network is a *direct acyclic graph (DAG)* with nodes and
vertices: $cal(G) = (cal(V), cal(E))$, in which nodes $v in cal(V)$ represent
random variables, that in the graphical representation are typically shaded if
observed, not shaded otherwise, and edges, describing the conditional
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
      node(Y3, [$Y_3$], fill: color.white)
      node(Y4, [$Y_4$], fill: color.aqua)
      node(Y5, [$Y_5$], fill: color.aqua)

      edge(Y1, "-|>", Y3)
      edge(Y2, "-|>", Y3, $P(Y_3 | Y_1, Y_2)$, label-side: left)
      edge(Y3, "-|>", Y4, $P(Y_4 | Y_3)$)
      edge(Y3, "-|>", Y5, $P(Y_5 | Y_3)$)
    },
  ),
  caption: [ Bayesian Network ],
) <fig-bayesian-net>

In a bayesian network, the *joint probability* is decomposed as

$ P(Y_1, dots, Y_N) = product_(i=1)^N P(Y_i | "parents" (Y_i)) $

The order to apply the chain rule is not fixed, for example considering the
bayesian network in @fig-bayesian-net we have that $Y_3$ has two parents from
which we can choose to apply the rule first.

Another way to visualize it is by starting from the joint probability, for
example

$ P(Y_1, Y_2, Y_3) $

and observing that, different orders of chain rule application produce different
networks

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (Y1, Y2, Y3) = ((0.5, 0), (1, 0), (1.5, 0))
      node(Y1, [$Y_1$])
      node(Y2, [$Y_2$])
      node(Y3, [$Y_3$])

      edge(Y1, "-|>", Y2)
      edge(Y2, "-|>", Y3)
      edge(Y1, "-|>", Y3, bend: 45deg)

      node(
        (1, 0.7),
        [$P(Y_3) P(Y_2 | Y_3) P(Y_1 | Y_2, Y_3)$],
        stroke: 0pt,
        shape: "rect",
      )

      let (Y1, Y2, Y3) = ((2, 0), (2.5, 0), (3, 0))
      node(Y1, [$Y_3$])
      node(Y2, [$Y_2$])
      node(Y3, [$Y_1$])

      edge(Y1, "-|>", Y2)
      edge(Y2, "-|>", Y3)
      edge(Y1, "-|>", Y3, bend: 45deg)

      node(
        (2.5, 0.7),
        [$P(Y_3) P(Y_2 | Y_3) P(Y_1 | Y_2, Y_3)$],
        stroke: 0pt,
        shape: "rect",
      )
    },
  ),
  caption: [ Chain Rule Ordering ],
) <fig-chain-rule-order>

So by now we didn't add much more than before, we still have a joint
distribution factorized with the chain rule, which defines the BN structure but
we still have the same problem as before, since we didn't define yet how CI
assumptions are applied.

In that perspective we will see that we basically have to flip our point of
view: it is not the chain rule that defines the BN, but the is the BN structure
that defines the factorization and, with CI assumptions, what of the full
factorization can be _simplified_.

#note(title: "Causal Interpretation")[
  Let's also notice that typically a *causal interpretation* is given to
  bayesian networks, but in general edges do not represent causality, only
  *statistical dependence*.

  However can happen that, under further assumptions, edges might actually
  coincide with the concept of _causal dependence_.
]

== Plate Notation

Since a model can involve many variables of the same type, the resulting graph
can become unnecessary big to draw. So is possible to use the so called *plate
notation* to have a more compact representation:

#figure(
  image("images/plate_notation.png", width: 90%),
  caption: [ Plate Notation ],
) <fig-plate-notation>

This notation basically adds the possibility to _replicate_ a graph substructure
by the times specified in the box. In @fig-plate-notation we assume to work with
$L$ features that are all of the same nature and of course we work under the
assumption that the $N$ samples in the dataset are i.i.d.

An example of a more structured plate notation is this

#figure(
  image("images/gmm_plate_notation.png", width: 25%),
  caption: [ Plate Notation ],
)

in which we can also specify parameters of random variables, that in this case
are shared among them.

= Local Markov Property

In order to automatically know where to apply CI conditions we assume the *local
Markov property*, introducing approximations that can of course worsen the model
performance but crucial to make the training feasible.

#important(title: "Local Markov Property")[
  Each node is conditionally independent of all its *non-descendants* given a
  *joint state of its parents*

  $
    Y_v perp Y_(V minus "children"(v)) | Y_("parents" (v)) quad forall v in V
  $
]

Considering the following BN

#figure(
  diagram(
    node-shape: "rect",
    node-corner-radius: 10pt,
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
      node(Y1, [PArty], fill: color.aqua)
      node(Y2, [Study], fill: color.aqua)
      node(Y3, [Headache], fill: color.aqua)
      node(Y4, [Tabs], fill: color.aqua)
      node(Y5, [Coffee], fill: color.aqua)

      edge(Y1, "-|>", Y3)
      edge(Y2, "-|>", Y3)
      edge(Y3, "-|>", Y4)
      edge(Y3, "-|>", Y5)
    },
  ),
)

we can say that PArty and Study are _marginally independent_, however the local
Markov property does not support $P A perp S | H$. Instead it does support
$T perp P A | H$ because $P A$ is not a descendant of $T$.

A typical application of chain rule and local Markov property is

+ Pick a *topological ordering* of nodes.
+ Apply the *chain rule* following the order.
+ Use the *conditional independence assumptions* (local Markov property).

Again, considering the network in @fig-bayesian-net we can follow the
enumeration order as topological order and derive

$
  P(P A, S, H, T, C) & = P(P A) P(S | P A) P(H | P A, S)
  P(T | P A, S, H)
  P (C | P A, S, H, T) \
  & = P(P A) dot P(S) dot P(H | P A, S) dot P(T | H) dot P(C | H)
$

So by applying the rule again we reduced the number of parameters of the
network.

#note[
  In order to apply the property, parents variables need to be observed. If not
  observed they need to be marginalized which in general can be expensive.
]

= Ancestral Sampling

A bayesian network, once built, can be seen as a *generative process*, called
*ancestral sampling* for observations, composed by these steps:

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

In bayesian networks there are three *fundamentals substructures* crucial to
determine the conditional independence relationships: *confounder*, *chain* and
*collider*.

The focus is mostly on the central variable and what is the effect of
*conditioning* (observe) it or not.

== Confounder

The *confounder*

#figure(
  diagram(node-stroke: 1pt, {
    let (Y1, Y2, Y3) = ((0, 0), (1, 0), (2, 0))
    node(Y1, [$Y_1$])
    node(Y2, [$Y_2$])
    node(Y3, [$Y_3$])
    edge(Y2, "-|>", Y1)
    edge(Y2, "-|>", Y3)
  }),
  caption: [ Confounder ],
)

whose joint probability is always defined by the model structure as

$ P(Y_1, Y_2, Y_3) = P(Y_2) dot P(Y_1 | Y_2) dot P(Y_3 | Y_2) $

If $Y_2$ is unobserved, then $Y_1$ and $Y_3$ are *marginally dependent*:

$ Y_1 cancel(perp) Y_3 $

#example[
  Suppose everythin is unobserved and we want to compute $P(Y_3 = y_3)$, we need
  to marginalize what is unobserved:

  $
    p(y_3) & = sum_y_1 sum_y_2 p(y_2) dot p(y_1 | y_2) dot p(y_3 | y_2) \
           & = sum_y_2 p(y_2) dot p(y_3 | y_2) dot sum_y_1 p(y_1 | y_2)
  $

  but the second sum is a valid distribution so it's equal to $1$, therefore
  only remains

  $ p(y_3) = sum_y_2 p(y_2) dot p(y_3 | y_2) $

  so we only need to marginalize over $y_2$ in this case. The interesting thing
  here is what happens when we observe $Y_1$ instead. In that case we don't
  marginalize it anymore, hence we have to keep the probability of $y_1$ from
  the previously simplified sum over $y_1$:

  $ p(y_3) = p(y_1) dot sum_y_2 p(y_2) dot p(y_3 | y_2) $

  proving that observing $Y_1$ changes the probability over $Y_3$.
]

If instead $Y_2$ is observed then $Y_1$ and $Y_3$ are *conditionally
independent*:

$ Y_1 perp Y_3 | Y_2 $

In this case things are much simpler since the observation of the parent make
the other two variables conditionally independent and we don't need to
marginalize anything, since $Y_3$ (for example) depends only on $Y_2$.

#note[
  When $Y_2$ is observed is said to *block the path* from $Y_1$ to $Y_3$.
]

== Chain

The *chain*

#figure(
  diagram(node-stroke: 1pt, {
    node((0, 0.75), [$Y_1$])
    node((1, 0.75), [$Y_2$])
    node((2, 0.75), [$Y_3$])
    edge((0, 0.75), "-|>", (1, 0.75))
    edge((1, 0.75), "-|>", (2, 0.75))
  }),
  caption: [ Chain ],
)

corresponds to

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

== Collider

The *collider*

#figure(
  diagram(node-stroke: 1pt, {
    node((0, 0), [$Y_1$])
    node((1, 0), [$Y_2$])
    node((2, 0), [$Y_3$])
    edge((0, 0), "-|>", (1, 0))
    edge((2, 0), "-|>", (1, 0))
  }),
  caption: [ Collider ],
)

corresponds to

$ P(Y_1, Y_2, Y_3) = P(Y_1) P(Y_3) P(Y_2 | Y_1, Y_3) $

If $Y_2$ is observed, then $Y_1$ and $Y_3$ are *conditionally dependent*:

$ Y_1 cancel(perp) Y_3 | Y_2 $

If instead $Y_2$ is unobserved then $Y_1$ and $Y_3$ are *marginally
independent*:

$ Y_1 perp Y_3 $

The collider can be counterintuitive since it behaves almost the opposite way of
the other two. In reality it follows exactly the same rules; let's simply
suppose that nothing is observed and we want to compute $p(y_3)$:

$
  p(y_3) & = sum_y_1 sum_y_2 p(y_1) dot p(y_3) dot p(y_2 | y_1, y_3) \
         & = p(y_3) dot sum_y_1 p(y_1) dot sum_y_2 p(y_2 | y_1, y_3)
$

but similarly to the previous case

$ sum_y_1 p(y_1) = 1 " and " sum_y_2 p(y_2 | y_1, y_3) = 1 $

so we just have a prior probability $p(y_3)$ left. If we observe $Y_1$ we have
that

$
  P(Y_3 | Y_1) = frac(P(Y_1 | Y_3) dot P(Y_3), P(Y_1))
  = frac(P(Y_1, Y_3), P(Y_1))
$

but $P(Y_1, Y_3) = P(Y_1) dot P(Y_3)$ and so

$ P(Y_3 | Y_1) = P(Y_3) $

#note[
  If any $Y_2$ descendant is observed it *unlocks the path*.
]

= D-Separation

Let $r = (Y_1 <-> dots.c <-> Y_2)$ be an *undirected path* between $Y_1$ and
$Y_2$, then $r$ is *blocked* by a set $Z$ if $r$ contains

- A _confounder_ $Y_i <- Y_c -> Y_j$ such that $Y_c in Z$.
- A _chain_ $Y_i -> Y_c -> Y_j$ such that $Y_c in Z$.
- A _collider_ $Y_i -> Y_c <- Y_j$ such that neither $Y_c$ nor its descendants
  are in $Z$.

Let's now introduce the concept of *$d$-separation* for a path in the bayesian
network

#important(title: [$d$-Separated Path])[
  Let $r = Y_1 <-> dots.c <-> Y_2$ be an *undirected path* between $Y_1$ and
  $Y_2$, then $r$ is *$d$-separated by $Z$* if there exist at least one node
  $Y_c in Z$ for which path $r$ is blocked.
]

An example can be a simple confounder where the parent is observed

#figure(
  diagram(
    node-stroke: 1pt,
    {
      node((0, 0), [$Y_1$])
      node((1, 0), [$Y_p$], fill: color.aqua)
      node((2, 0), [$Y_2$])
      edge((1, 0), "-|>", (0, 0))
      edge((1, 0), "-|>", (2, 0))
    },
  ),
)

#important(title: [$d$-Separation])[
  Two nodes $Y_i$ and $Y_j$ in a bayesian network $cal(G)$ are said to be
  *$d$-separated* by $Z subset cal(V)$:

  $ "Dsep"_cal(G) (Y_i, Y_j | Z) $

  if and only if all undirected paths between $Y_i$  and $Y_j$ are $d$-separated
  by $Z$.

  $ Y_1 perp_cal(G) Y_2 | Z $
]


#figure(
  diagram(
    node-stroke: 1pt,
    {
      node((0, 0.75), [$Y_1$])
      node((1, 0), [$Y_2$], fill: color.aqua)
      node((2, 0.75), [$Y_4$])
      node((1, 1.5), [$Y_3$], fill: color.aqua)

      edge((0, 0.75), "-|>", (1, 0))
      edge((0, 0.75), "-|>", (1, 1.5))
      edge((1, 0), "-|>", (2, 0.75))
      edge((1, 1.5), "-|>", (2, 0.75))
    },
  ),
)

In this case we can say that $Y_1$ and $Y_4$ are _d-separated_ by the set $Z =
{Y_2, Y_3}$.

= Global Markov Property

The concept of $d$-separation lets us define the *global Markov property* for an
entire bayesian network.

#important(title: "Global Markov Property")[
  A bayesian network respects the *global Markov property* whenever
  $d$-separations in the graph imply conditional independence relations.
]

It basically says that if two nodes are $d$-separated by a set of nodes $Z$,
they are conditionally independent given $Z$. In other words, if the model
represents conditional independence, that must be true also in the distribution.

#note[
  Global and local Markov properties are equivalent.
]

From this properties of conditional independence is possible to derive the
*Markov blanket* of a node.

#important(title: "Markov Blanket")[
  The *Markov blanket* $"Mb"(Y)$ of a node $Y$ is the minimal set of vertices
  that *shields the node* from the rest of the network.
]

In a DAG the Markov blanket of $Y$ contains its

- *Parents*: knowing a parent $Y_p$ blocks the path to parents and children of
  $Y_p$ (confounder and chain block condition).
- *Children*: knowing the children blocks the path to children's children.
- *Childrens' parents*: knowing the children unblocks the path to parents' of
  children so we have to condition also them.

#figure(
  image("images/markov_blanket.png", width: 30%),
  caption: [ Markov Blanket ],
) <fig-markov-blanket>

This means that the behavior of a node can completely be determined and
predicted by its Markov blanket:

$ P(Y | "Mb"(Y), Z) = P(Y | "Mb"(Y)) quad forall Z in.not "Mb"(Y) $

and if this is true for every node in the network we can say that the graph is
*Markovian to the distribution*.

== Faithfulness Property

The *faithfulness property* gives us strong assumptions if paired with Markov
properties.

#important(title: "Faithfulness")[
  A bayesian network is *faithful* whenever conditional independence relations
  imply $d$-separation.

  $ Y_1 perp Y_2 | Z ==> Y_1 perp_cal(G) Y_2 | Z $
]

While the global Markov property requires the graph to represent *only*
conditional independences, the _faithfulness_ requires to represent *all*
conditional independences.

In other words it says that if there is conditional independence in the
distribution, the model have to represent it.

The faithfulness is fundamental to represent concisely joint distributions
because the more conditional independences we represent the less parameters we
need to store in the model.

We can say that a graph is *faithful* to the distribution if it represents all
conditional independences. Paired with the Markov property we can obtain

$ Y_1 perp Y_2 | Z <==> Y_1 perp_cal(G) Y_2 | Z $

which basically say that the model represent *all and only* the conditional
independences present in the distribution.
