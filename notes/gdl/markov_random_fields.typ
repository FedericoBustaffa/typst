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

This can be done instead by *undirected models*, like *random Markov fields*,
that are simpler and have an equivalent definition of $d$-separation, which is
only based on conditioning nodes to block a path, if a node is not conditioned
the path is unblocked.

#figure(
  image("images/markov_random_field.png", width: 50%),
  caption: [ Markov Random Field ],
)

In this case the _Markov blanket_ of a node include all and only its neighbors.

= Joint Probability Factorization

For the *joint probability* of undirected models we can exploit the fact that
the Markov blanket of a node is composed by its neighbors therefore, given a
node's neighborhood, it is conditionally independent from every other node in
the graph (Markov property):

$
  P(X_i, X_j | X_(cal(V) - {i, j})) =
  P(X_i | X_(cal(V) - {i, j})) P(X_j | X_(cal(V) - {i, j}))
$

The factorization should be chosen in a way that nodes $X_i$ and $X_j$ are not
in the same factor. One possible graph structure that includes only nodes that
are pairwise connected is the *clique*.

#important(title: "Clique")[
  A *clique* is a subset of nodes $C$ in a graph $cal(G)$ such that $cal(G)$
  contains an edge between all pair of nodes in $C$.
]


#figure(
  image("images/clique.png", width: 40%),
  caption: [ Cliques ],
)

#important(title: "Maximal Clique")[
  A clique $C$ that cannot include any further nodes from the graph without
  ceasing to be a clique is called *maximal clique*.
]

In this sense is possible to perform a *maximal clique factorization* by
defining $X = X_1, dots, X_N$ as the random variables associated to the $N$
nodes in the undirected graph $cal(G)$

$ P(X) = 1 / Z product_C psi (X_C) $

where

- $X_C$ is the random variable associated with nodes in the maximal clique $C$.
- $psi(X_C)$ is the *potential function* over the maximal cliques $C$.
- $Z$ is the *partition function* ensuring normalization defined as
  $ Z = sum_X product_C psi(X_c) $

The partition function is the computational bottleneck of undirected models,
with a time complexity in the order of $cal(O) (K^N)$ for $N$ discrete random
variables with $K$ distinct values.

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

