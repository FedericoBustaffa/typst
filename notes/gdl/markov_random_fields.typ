#import "@local/note_template:0.1.0": *
#show: doc => note_template([Markov Random Fields], doc)

#title()

Bayesian networks are used to model *asymmetric dependencies*, but in order to
model *symmetric dependencies*, like bidirectional effects we need *undirected
models*.

In fact directed models cannot represent some (bidirectional) dependencies in
the distributions.

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

Considering the BN above we can represent $Y_1 perp Y_3 | Y_2, Y_4$ but we
cannot represent $Y_2 perp Y_4 | Y_1, Y_3$. Even changing edges, in whatever
configurations, the two conditional independeces cannot be represented together
by a bayesian network.

This can be done instead by *undirected models*, like *random Markov fields
(MRF)*, that are simpler and have an equivalent definition of $d$-separation,
which is only based on conditioning nodes to block a path, if a node is not
conditioned the path is unblocked.

#figure(
  image("images/markov_random_field.png", width: 50%),
  caption: [ Markov Random Field ],
)

In this case the _Markov blanket_ of a node include all and only its neighbors.

= Joint Probability Factorization

Like for bayesian networks, we are interested in representing the *joint
probability* of the model. The main difference is that in BNs we had the
topological order given by the DAG, that naturally defines a factorization of
the joint distribution.

$ P(X_1, dots, X_n) = product_(i=1)^N P(X_i | "Pa"(X_i)) $

The problem with MRFs is that we have _undirected edges_ therefore no
topological order; since that, we need to find a way to factorize the joint
distribution that also takes into account independences given by the graph.

#figure(
  diagram(
    node-stroke: 1pt,
    node-shape: "circle",
    {
      let (Y1, Y2, Y3, Y4) = ((0, 0), (0.75, -0.75), (1.5, 0), (0.75, 0.75))

      node(Y1, $X_1$)
      node(Y2, $X_2$)
      node(Y3, $X_3$)
      node(Y4, $X_4$)

      edge(Y1, "-", Y2)
      edge(Y2, "-", Y3)
      edge(Y1, "-", Y3)
      edge(Y1, "-", Y4)
    },
  ),
  caption: [ Simple Markov Random Field ],
) <fig-simple-mrf>

Let's try to reason by looking at @fig-simple-mrf; the joint probability must
keep track of the fact that $X_1$, $X_2$ and $X_3$ are connected one another,
while $X_4$ is connected only to $X_1$. In this MRF is clear that $X_1$ is a
separating set for some nodes, in particular it holds

$ X_2, X_3 perp X_4 | X_1 $

This suggests some structure in which $X_2$ and $X_3$ are together, while $X_4$
is separated and $X_1$ is a sort of _bridge_ in between.

#important(title: "Clique")[
  A *clique* is a subset of nodes $C$ in a graph $cal(G)$ such that $cal(G)$
  contains an edge between all pair of nodes in $C$.
]

#important(title: "Maximal Clique")[
  A clique $C$ that cannot include any further nodes from the graph without
  ceasing to be a clique is called *maximal clique*.
]

#figure(
  image("images/clique.png", width: 35%),
  caption: [ Cliques ],
) <fig-cliques>

In @fig-simple-mrf we have two maximal cliques: ${X_1, X_2, X_3}$ and ${X_1,
  X_4}$ and so we can factorize the joint probability as some function of those
cliques.

$ P(X_1, X_2, X_3, X_4) prop psi (X_1, X_2, X_3) dot psi(X_1, X_4) $

This gives us the intuition to factorize the joint distribution of a MRF as

$ P(X_1, dots, X_N) = 1 / Z product_C psi (X_C) $

where

- $X_C$ is the random variable associated with nodes in the maximal clique $C$.
- $psi(X_C)$ is the *potential function* over the maximal cliques $C$.
- $Z$ is the *partition function* ensuring normalization defined as
  $ Z = sum_X product_C psi(X_C) $

The partition function is the computational bottleneck of undirected models,
with a time complexity in the order of $cal(O) (K^N)$ for $N$ discrete random
variables with $K$ distinct values.

= From Directed to Undirected

It's also possible to go from a directed graph to an undirected one just by
switching all the directed edges in undirected ones

#figure(
  image("images/directed_to_undirected.png", width: 80%),
  caption: [ Directed to Undirected Chain ],
)

and in some cases by also
performing what is called *moralization* (marrying the parents).

#figure(
  image("images/moralization.png", width: 60%),
  caption: [ Moralization ],
)

and this require to recognize *v-structures*. This process is done to ensure
that conditional independences modelled by a directed model are preserved in the
undirected. The marginal independences can change from directed to undirected
because now we have links among parents that before were not present.

= Likelihood and Potential Functions

Potential functions express which configurations of the local variables are
preferred and a convenient and widely used potential function is the *Boltzmann
distribution*:

$ psi (X_C) = e^(-E (X_C)) $

where $E(X_C)$ is the so called *energy function*, that typically is just a
linear combination of $X_C$:

$ psi (X_C) = e^(- sum_k theta_(C k) f_(C k) (X_C)) $

where

- $f_(C k)$ is called *feature function* and defines some *constraint* on some
  or all the random variables in the clique $C$. Usually is something user
  defined that injects knowledge about the problem.
- $theta_(C k)$ is a parameter learned from data that _weights_ the importance
  of the feature function.

Usually feature functions are simple linear combinations that are used for
example to _correct_ noisy data $X_i$ with their _clean_ version

$ f_i (X_i, Y_i) = X_i Y_i $

or to put constraints w.r.t. the neighbors

$ f_(i j) (Y_i, Y_j) = Y_i Y_j $

and every clique can have its feature function set

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

Anyway, undirected graphical models do not express the factorization of
potentials into feature functions, therefore there is the need of *factor
graphs*.

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

= Conditional Random Fields

Random variables that model input data can be assumed to be always observable
and this means that we can directly model the conditional distribution:

$ P(Y | X) = 1 / Z(X) product_k e^(theta_k f_k (X_k, Y_k)) $

where $X$ is the joint input that is always observable and the partition
function is defined as

$ Z(X) = sum_y product_k e^(theta_k f_k (X_k, Y_k = y_k)) $

and where $X_k$ is the observable inputs in factor $k$, $Y_k$ are the hidden
variables in factor $k$ and $f_k (X_k, Y_k)$ is the factor $k$ feature function.

This defines the so called *conditional random fields (CRF)* and a special case
of CRF is the *linear CRF*, that can be seen as an indirected version of hidden
markov model to work with sequences.

#figure(
  diagram(
    node-stroke: 1pt,
    node-shape: "circle",
    {
      for i in range(3) {
        let offset = i * 2.5
        let (Y1, Y2, Y3, Y4) = (
          (offset, 0),
          (offset - 0.75, 1),
          (offset, 1),
          (offset + 0.75, 1),
        )

        node(Y1, [$Y_t$])
        node(Y2, [$X_(t-1)$], fill: aqua, inset: 2pt)
        node(Y3, [$X_(t)$], fill: aqua, inset: 2pt)
        node(Y4, [$X_(t+1)$], fill: aqua, inset: 2pt)

        node(
          (offset - 0.4, 0.55),
          align(bottom + right)[$f_p$],
          width: 6pt,
          height: 6pt,
          shape: "rect",
          fill: color.black,
        )

        node(
          (offset, 0.55),
          align(top + right)[$f_s$],
          width: 6pt,
          height: 6pt,
          shape: "rect",
          fill: color.black,
        )

        node(
          (offset + 0.4, 0.55),
          align(top)[$f_s$],
          width: 6pt,
          height: 6pt,
          shape: "rect",
          fill: color.black,
        )

        edge(Y1, "-", Y2)
        edge(Y1, "-", Y3)
        edge(Y1, "-", Y4)
      }

      edge((0, 0), "-", (2.5, 0))
      edge((2.5, 0), "-", (5, 0))
      node(
        (1.25, 0),
        align(top)[$f_t$],
        width: 6pt,
        height: 6pt,
        shape: "rect",
        fill: color.black,
      )
      node(
        (3.75, 0),
        align(top)[$f_t$],
        width: 6pt,
        height: 6pt,
        shape: "rect",
        fill: color.black,
      )
    },
  ),
)

and are able to model relative influence of suffix and prefix symbols with the
following conditional probability

$
  P(Y | X, theta) = 1 / Z(X) product_t product_k
  exp{theta_k f_k (Y_(t-1), Y_t, X_t)}
$

