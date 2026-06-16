#import "@local/note_template:0.1.0": *
#show: doc => note_template([Markov Random Fields], doc)

#title()

Bayesian networks are used to model *asymmetric dependencies*, but in order to
model *symmetric dependencies*, like bidirectional effects we need *undirected
models*. Let's consider the following BN:

#figure(
  diagram(
    node-stroke: 1pt,
    {
      let (Y1, Y2, Y3, Y4) = ((0, 0), (0.75, -0.75), (1.5, 0), (0.75, 0.75))

      node(Y1, $Y_1$)
      node(Y2, $Y_2$)
      node(Y3, $Y_3$)
      node(Y4, $Y_4$)

      edge(Y1, "-|>", Y2)
      edge(Y2, "-|>", Y3)
      edge(Y4, "-|>", Y3)
      edge(Y1, "-|>", Y4)
    },
  ),
)

that in fact cannot represent some (bidirectional) dependencies in the
distributions. Considering the BN above we can represent $Y_1 perp Y_3 | Y_2,
Y_4$ but we cannot represent $Y_2 perp Y_4 | Y_1, Y_3$. Even changing edges, in
whatever configurations, the two conditional independeces cannot be represented
together by a bayesian network.

This can be done instead by *undirected models*, like *random Markov fields
(MRF)*:

#figure(
  diagram(
    node-stroke: 1pt,
    {
      let (Y1, Y2, Y3, Y4) = ((0, 0), (0.75, -0.75), (1.5, 0), (0.75, 0.75))

      node(Y1, $Y_1$)
      node(Y2, $Y_2$)
      node(Y3, $Y_3$)
      node(Y4, $Y_4$)

      edge(Y1, "-", Y2)
      edge(Y2, "-", Y3)
      edge(Y4, "-", Y3)
      edge(Y1, "-", Y4)
    },
  ),
)

that are simpler and have an equivalent definition of $d$-separation, which is
only based on conditioning nodes to block a path, if a node is not conditioned
the path is unblocked.

#figure(
  image("images/markov_random_field.png", width: 50%),
  caption: [ Markov Random Field ],
)

In this case the _Markov blanket_ of a node include all and only its neighbors.
The first challenge of these models is to write their joint probability, that,
as we will see is not that trivial.

= Joint Probability Factorization

Like for bayesian networks, we are interested in representing the *joint
probability* of the model. The main difference is that in BNs we have a
topological order given by the DAG, that naturally defines a factorization of
the joint distribution through the chain rule and the Markov property.

$ P(X_1, dots, X_n) = product_(i=1)^N P(X_i | "Pa"(X_i)) $

We would like something similar but the problem here is that, we don't have any
topological order and, most important we have bidirectional dependencies. Let's
consider the simplest graph we can imagine

#figure(
  diagram(
    node-stroke: 1pt,
    node-shape: "circle",
    {
      let (a, b) = ((0, 0), (1, 0))
      node(a, $A$)
      node(b, $B$)
      edge(a, "-", b)
    },
  ),
)

We could think to sample $A$ first but it means sampling from

$ p(A | B) $

same thing for $B$, that is conditioned on $A$.

For MRFs the strategy is different from BNs: we aim to find a factorization that
already embeds the conditional independence relations over the graph, unlike in
BNs where we use the chain rule following the graph and then applying the
conditional independence assumptions.

We need something that takes into account the neighborhood of a node and the
bidirectional dependencies at the same time.

#figure(
  image("images/clique.png", width: 35%),
  caption: [ Cliques ],
) <fig-cliques>

#important(title: "Clique")[
  A *clique* is a subset of nodes $C$ in a graph $cal(G)$ such that $cal(G)$
  contains an edge between all pair of nodes in $C$.
]

The clique is perfect for the purpose because it consider only neighbors of a
node that are also related to each other.

#important(title: "Maximal Clique")[
  A clique $C$ that cannot include any further nodes from the graph without
  ceasing to be a clique is called *maximal clique*.
]

This gives us the intuition to factorize the joint distribution of a MRF as a
function of maximal cliques:

$ P(X_1, dots, X_N) = 1 / Z product_C psi (X_C) $

where

- $X_C$ is the random variable associated with nodes in the maximal clique $C$.
- $psi(X_C)$ is the *potential function* over the maximal cliques $C$.
- $Z$ is the *partition function* ensuring normalization defined as
  $ Z = sum_X product_C psi(X_C) $

The partition function is the computational bottleneck of undirected models,
with a time complexity in the order of $cal(O) (K^N)$ for $N$ discrete random
variables with $K$ distinct values.

= Likelihood and Potential Functions

Potential functions express which configurations of the local variables are
preferred and a convenient and widely used potential function is the *Boltzmann
distribution*:

$ psi (X_C) = e^(-E (X_C)) $

where $E(X_C)$ is the so called *energy function*, that typically is just a
linear combination of $X_C$:

$ psi (X_C) = e^(- sum_k theta_(C k) f_(C k) (X_C)) $

where

- $f_(C k)$ is called *feature function* and can define _constraint_,
  _interaction_ or _compatibility_ between nodes of the clique $C$. Usually is
  something user defined that injects knowledge about the problem.
- $theta_(C k)$ is a parameter learned from data that _weights_ the importance
  of the feature function.

Usually feature functions are simple linear combinations like

$ f_i (X_i, Y_i) $

with $X_i, Y_i in {-1, +1}$ that for example models agreement between two nodes.
It is then up to the weight $theta_i$ to define how strong this agreement is
wanted (or not wanted).

#figure(
  diagram(
    node-stroke: 1pt,
    node-shape: "circle",
    node-inset: 5pt,
    {
      let (Y1, Y2, Y3, Y4) = ((0, 0), (0.75, -0.5), (1.5, 0), (2.25, -0.5))

      node(Y1, $Y_1$)
      node(Y2, $Y_2$)
      node(Y3, $Y_3$)
      node(Y4, $Y_4$)

      edge(Y1, "-", Y2)
      edge(Y1, "-", Y3)
      edge(Y2, "-", Y4)
      edge(Y4, "-", Y3)

      let (X1, X2, X3, X4) = ((0, 1), (0.75, 0.5), (1.5, 1), (2.25, 0.5))
      node(X1, $X_1$, fill: color.aqua)
      node(X2, $X_2$, fill: color.aqua)
      node(X3, $X_3$, fill: color.aqua)
      node(X4, $X_4$, fill: color.aqua)

      edge(Y1, "-", X1)
      edge(Y2, "-", X2)
      edge(Y3, "-", X3)
      edge(Y4, "-", X4)
    },
  ),
  caption: [ Markov Random Field with Hidden Units ],
) <fig-mrf-pixel>

For example, the MRF in @fig-mrf-pixel could be a model used for background
segmentation in images: $X_i$ is one pixel and $Y_i$ is the denoised cleaned
pixel learned by the model. As show we can also exploit the neighborhood of $Y$s
in order to adjust possible errors by _looking at the neighbors_ when there is
high uncertainty.

Putting everything together we have that the joint probability now is

$ P(X) = 1 / Z e^(-E(X)) = 1 / Z e^(- sum_C sum_k theta_(C k) f_(C k) (X_C)) $

and since is an exponential with a negative exponent is clear that maximizing
that probability is equal to find low-energy configurations.

= Factor Graphs

Undirected graphical models do not express the factorization of potentials into
feature functions, therefore there is the need of *factor graphs*.

#figure(
  diagram(
    node-stroke: 1pt,
    node-shape: "circle",
    node-inset: 5pt,
    {
      let (X1, X2, X3) = ((0, 0), (1.5, 0), (0.75, 1))

      node(X1, $X_1$)
      node(X2, $X_2$)
      node(X3, $X_3$)

      edge(X1, "-", X2)
      edge(X1, "-", X3)
      edge(X3, "-", X2)

      let (X1, X2, X3, f) = ((2.5, 0), (4, 0), (3.25, 1), (3.25, 0.375))

      node(X1, $X_1$)
      node(X2, $X_2$)
      node(X3, $X_3$)
      node(f, width: 6pt, height: 6pt, shape: "rect", fill: color.black)
      node((3.25, 0.15), $f$, stroke: none)

      edge(X1, "-", f)
      edge(X2, "-", f)
      edge(X3, "-", f)

      // third
      let (X1, X2, X3, fa, fb) = (
        (5, 0),
        (6.5, 0),
        (5.75, 1),
        (5.75, 0.375),
        (6.5, 0.75),
      )

      node(X1, $X_1$)
      node(X2, $X_2$)
      node(X3, $X_3$)
      node(fa, width: 6pt, height: 6pt, shape: "rect", fill: color.black)
      node(fb, width: 6pt, height: 6pt, shape: "rect", fill: color.black)
      node((5.75, 0.125), $f_a$, stroke: none)
      node((6.75, 0.75), $f_b$, stroke: none)

      edge(X1, "-", fa)
      edge(X2, "-", fa)
      edge(X3, "-", fa)
      edge(X3, "-", fb)
      edge(X2, "-", fb)
    },
  ),
  caption: [ Factor Graphs ],
)

Where the second and third graphs respectively factorize the potential as

$
  psi (X_1, X_2, X_3) = f (X_1, X_2, X_3) \
  psi (X_1, X_2, X_3) = f_a (X_1, X_2, X_3) f_b (X_2, X_3)
$

= From Directed to Undirected

It's also possible to go from a directed graph to an undirected one just by
switching all the directed edges in undirected ones

#figure(
  grid(
    columns: 2,
    column-gutter: 2em,
    diagram(
      node-stroke: 1pt,
      node-shape: "circle",
      {
        let (Y1, Y2, Y3) = ((0, 0), (0.75, 0), (1.5, 0))

        node(Y1, $X_1$)
        node(Y2, $X_2$)
        node(Y3, $X_3$)

        edge(Y1, "-|>", Y2)
        edge(Y2, "-|>", Y3)
      },
    ),
    diagram(
      node-stroke: 1pt,
      node-shape: "circle",
      {
        let (Y1, Y2, Y3) = ((0, 0), (0.75, 0), (1.5, 0))

        node(Y1, $X_1$)
        node(Y2, $X_2$)
        node(Y3, $X_3$)

        edge(Y1, "-", Y2)
        edge(Y2, "-", Y3)
      },
    ),
  ),
  caption: [ Directed to Undirected Chain ],
) <fig-dir-to-undir>

and in some cases by also
performing what is called *moralization* (marrying the parents).

#figure(
  grid(
    columns: 2,
    column-gutter: 2em,
    diagram(
      node-stroke: 1pt,
      node-shape: "circle",
      {
        let (Y1, Y2, Y3, Y4) = ((0, 0), (0.75, 0.25), (1.5, 0), (0.75, 1.25))

        node(Y1, $X_1$)
        node(Y2, $X_2$)
        node(Y3, $X_3$)
        node(Y4, $X_4$)

        edge(Y1, "-|>", Y4)
        edge(Y2, "-|>", Y4)
        edge(Y3, "-|>", Y4)
      },
    ),
    diagram(
      node-stroke: 1pt,
      node-shape: "circle",
      {
        let (Y1, Y2, Y3, Y4) = ((0, 0), (0.75, 0.5), (1.5, 0), (0.75, 1.25))

        node(Y1, $X_1$)
        node(Y2, $X_2$)
        node(Y3, $X_3$)
        node(Y4, $X_4$)

        edge(Y1, "-", Y4)
        edge(Y2, "-", Y4)
        edge(Y3, "-", Y4)

        edge(Y1, "-", Y2, stroke: 1.5pt + color.red)
        edge(Y2, "-", Y3, stroke: 1.5pt + color.red)
        edge(Y3, "-", Y1, stroke: 1.5pt + color.red)
      },
    ),
  ),
  caption: [ Moralization ],
) <fig-moralization>

and this require to recognize *v-structures*. This process is done to ensure
that conditional independences modelled by a directed model are preserved in the
undirected. The marginal independences can change from directed to undirected
because now we have links among parents that before were not present.
