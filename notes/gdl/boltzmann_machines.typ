#import "@local/note_template:0.1.0": *
#show: doc => note_template([Boltzmann Machines], doc)

#title()

An example of specialized case of *Markov random field* is the *Boltzmann
machine (BM)*, an *_energy model_* where random variables (both visible and
hidden) can have only two possible states $0$ or $1$.

#figure(
  image("images/boltzmann_machine.png", width: 40%),
  caption: [ Boltzmann Machine ],
) <fig-bm>

This define a *state vector* of the BM as

$ vb(s) = [vb(v) vb(h)] = vec(v_1, dots.v, v_n, h_1, dots.v, h_m) $

that simply is a concatenation of all visible ($vb(v)$) and hidden ($vb(h)$)
states in one vector. So a generic $s_i$ is the $i$-th element of that vector
that can be either visible or hidden.

#note[
  As it is, the BM is a fully connected graph so the whole graph is clique and
  the clique factorization accounts for just one clique. This also means that
  each unit depends on every other unit.
]

= Joint Probability

Since the model is in the family of _energy-based_ it uses an *energy function*,
defined as

$
  E(vb(s)) = -1/2 sum_(i j) M_(i j) s_i s_j - sum_i b_i s_i
  = -1/2 vb(s)^TT vb(M) vb(s) - vb(b)^TT vb(s)
$

with $M$ and $b$ that are learnable parameters; in particular $M$ is symmetric
and has zero diagonal (no self-recurrent connectivity). In this case we also
have $f(s_i, s_j) = s_i s_j$ that is a feature function that establish an
agreement between two nodes. While the other term is just a bias term.

The energy function favourites configurations with low energy with an higher
probability and that's why the minus term. The most important term is $M_(i j)
s_i s_j$ which relates two nodes and if they should or should not agree on the
value.

Intuitively we want that if the nodes are both $1$ a large $M_(i j)$ should
promote that agreement, while a negative value should discourage it, driving the
network to be more prone to switch one (or both) of those neurons off.

Therefore, the *joint probability* of this model factorizes as any MRF, but this
time we have only one clique, so we can write

$ p(vb(s)) = 1 / Z e^(-E (vb(s))) $

which gives us the probability of a certain configuration $vb(s)$.

= Learning

Since we want to maximize the probability of data, we can train the model by
*maximum likelihood*:

$ arg max_(M, b) p(v | M, b) = arg max_(M, b) sum_vb(h) p(v, vb(h) | M, b) $

that for the full dataset becomes

$ arg max_(M, b) product_(n=1)^N sum_vb(h) p(v^((n)), vb(h) | M, b) $

which is equivalent to

$
  product_(n=1)^N sum_vb(h) p(v^((n)), vb(h) | M, b)
  = product_(n=1)^N sum_vb(h) 1 / Z e^(-E(v^((n)), vb(h)))
  = 1 / Z product_(n=1)^N sum_vb(h) e^(-E(v^((n)), vb(h)))
$

to avoid underflows we can work in log-space, obtaining the *log-likelihood*:

$
  cal(L) (M, b) & = sum_(n=1) log sum_vb(h) e^(-E(v^((n)), vb(h))) - log Z \
                & = sum_(n=1) log sum_vb(h) e^(-E(v^((n)), vb(h))) -
                  log sum_vb(s) e^(-E(vb(s)))
$

that we can maximize by taking its derivative w.r.t. $M_(i j)$

$
  pdv(cal(L), M_(i j)) = sum_(n=1) frac(
    e^(-E(v^((n)), vb(h))), sum_vb(h)
    e^(-E(v^((n)), vb(h)))
  ) (- pdv(E, M_(i j))) -
  frac(
    e^(-E(vb(s))), sum_vb(s)
    e^(-E(vb(s)))
  ) (- pdv(E, M_(i j)))
$

where the derivative we are interested in is

$ pdv(E, M_(i j)) = -1/2 s_i s_j $

that makes the formula above become

$
  pdv(cal(L), M_(i j)) & = 1/2 sum_(n=1) frac(
                           e^(-E(v^((n)), vb(h))), sum_vb(h)
                           e^(-E(v^((n)), vb(h)))
                         ) s_i s_j - 1/2
                         frac(e^(-E(vb(s))), sum_vb(s) e^(-E(vb(s)))) s_i s_j \
                       & = 1/2 (sum_(n=1)^N p(v^((n)), vb(h)) s_i s_j
                           - p(vb(s)) s_i s_j) \
                       & = EE_"data" [s_i s_j] - EE_"model" [s_i s_j]
$

where both terms involve marginalization of the latents and for the second term
we also have to deal with the $Z$ term, making the learning by maximum
likelihood untractable in most cases.

The second term sum over all the possible states of the model, that for a single
sample with $V$ visible and $H$ hiddens, becomes $Order(2^(V + H))$ in time
complexity.

== Sampling

Due to the clear tractability issues of maximum likelihood learning, we can
approximate some term using *Gibbs sampling*. The idea is to start from a random
configuration and start sampling, updating the network and collecting its
states.

In order to do it we need to sample from the network node by node and so we need
the probability distribution associated with a single unit, that as we know is
dependent on its neighbors and direct local connections.

$ p(s_i | s_(-i)) $

So the probability of state $i$ to have (for example) value $1$ is equivalent to

$
  p(s_i = 1 | s_(-i)) =
  frac(p(s_i = 1 | s_(-i)), p(s_i = 0 | s_(-i)) + p(s_i = 1 | s_(-i)))
$

and this also means that the energy function simplifies as

$ E(s_i = 1) = -1/2 sum_j M_(i j) s_j - b_i $

and so we obtain

$
  p(s_i = 1 | s_(-i))
  = frac(e^(-E(s_i = 1)), e^(-E(s_i = 0)) + e^(-E(s_i = 1)))
  = frac(1, e^(E(s_i = 1)) (e^(-E(s_i = 0)) + e^(-E(s_i = 1))))
$

and since

$ E(s_i = 0) = 0 $

we have that

$
  frac(1, e^(E(s_i = 1)) (e^(-E(s_i = 0)) + e^(-E(s_i = 1))))
  = frac(1, 1 + e^(E(s_i = 1))))
$

that is the formulation of *sigmoid*, therefore we can simply write

$ p(x_i = 1 | x_(-i)) = sigma(-1/2 sum_j M_(i j) x_j - b_i) $

that we can use to sample node by node.

= Restricted Boltzmann Machines

In order to ease the computation of BMs we need to discard some connections; the
new and more tractable model is the *restricted Boltzmann machine (RBM)*, which
connects every visible to every latent and viceversa but connections between
visibles and between latents are not allowed.

#figure(
  image("images/rbm.png", width: 40%),
  caption: [ Restricted Boltzmann Machine ],
)

The model doesn't have a global clique anymore but only have cliques composed by
paired visibles and latents. In this way the conditional probabilities factorize as

$
  p(vb(v) | vb(h)) = product_i p(v_i | vb(h)) \
  p(vb(h) | vb(v)) = product_i p(h_i | vb(v))
$

and also the computation of probability for a single unit is simplified; it has
the same shape but if the unit is visible its probability only depends on
latents, if instead is latent its probability depends only on visibles:

$
  p(v_i = 1 | vb(h)) = sigma(sum_j M_(i j) h_j + b_j) \
  p(h_i = 1 | vb(v)) = sigma(sum_j M_(i j) v_j + b_j)
$

== Learning

=== Contrastive Divergence
