#import "@local/note_template:0.1.0": *
#show: doc => note_template([Boltzmann Machines], doc)

#title()

An example of specialized case of *Markov random field* is the *Boltzmann
machine (BM)* where random variables (both visible and hidden) can have only two
possible states $0$ or $1$.

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

The model uses a specific *energy function*, defined as

$
  E(vb(s)) = -1/2 sum_(i j) M_(i j) s_i s_j - sum_j b_j s_j
  = -1/2 vb(s)^TT vb(M) vb(s) - vb(b)^TT vb(s)
$

with $M$ and $b$ that are learnable parameters; in particular $M$ is symmetric
and has zero diagonal (no self-recurrent connectivity). In this case we also
have $f(s_i, s_j) = s_i s_j$ that is a feature function that establish an
agreement between two nodes.

= Joint Probability

The *joint probability* of this model factorizes as any MRF, but this time we have
only one clique, so we can write

$ p(vb(s)) = 1 / Z e^(-E (vb(s))) " with " Z = sum_vb(s)' e^(-E(vb(s)')) $

which gives us the probability of a certain configuration.

= Learning

Since we want to maximize the probability of data, we can train the model by
*maximum likelihood*:

$ arg max_(M, b) p(v | M, b) = arg max_(M, b) sum_h p(v, h | M, b) $

that for the full dataset becomes

$ arg max_(M, b) product_(n=1)^N sum_h p(v_n, h_n = h | M, b) $

to avoid underflows we can work in log-space, obtaining the *log-likelihood*:

$
  cal(L) (M, b) & = sum_(n=1) log sum_h p(v_n, h_n = h | M, b) \
                & = sum_(n=1)^N log sum_h 1 / Z e^(-E(v_n, h)) \
                & = sum_(n=1)^N (log sum_h e^(-E(v_n, h)) - log Z) \
                & = sum_(n=1)^N (log sum_h e^(-E(v_n, h)) - log sum_(v, h)
                    e^(-E(v, h)))
$

The second term sum over all the possible states of the model, that for a single
sample with $V$ visible and $H$ hiddens, becomes $Order(2^(V + H))$ in time
complexity.

== Sampling

Due to the clear tractability issues of maximum likelihood learning, we can
learn by *sampling* using Gibbs.

The last piece we need is the probability of single units to be either $0$ or
$1$; this is equivalent to compute the energy function with the neuron $i$
having value $1$, while all the other ones remains fixed:

$ E(vb(s)) = sum_(j) M_(i j) s_j - b_i $

so that the probability

$ p(s_i = 1 | s_(backslash i)) = 1 / Z e^(-E(vb(s))) $

