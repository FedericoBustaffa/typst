#import "@local/note_template:0.1.0": *
#show: doc => note_template([Boltzmann Machines], doc)

#title()

An example of specialized case of *Markov random field* is the *Boltzmann
machine (BM)* where random variables (both visible and hidden) can have only two
possible states $0$ or $1$.

#figure(
  image("images/boltzmann_machine.png", width: 35%),
  caption: [ Boltzmann Machine ],
) <fig-bm>

This define a *state vector* of the BM as

$ vb(s) = [vb(v) vb(h)] = vec(v_1, dots.v, v_n, h_1, dots.v, h_m) $

that simply is a concatenation of all visible ($vb(v)$) and hidden ($vb(h)$)
states in one vector. So a generic $s_i$ is the $i$-th element of that vector
that can be either visible or hidden.

#note[
  As it is, the BM is a fully connected graph so the whole graph is clique and
  the clique factorization accounts for just one clique.
]

The model uses a specific *energy function*, defined as

$
  E(vb(s)) = -1/2 sum_(i j) M_(i j) s_i s_j - sum_j b_j s_j
  = -1/2 vb(s)^TT vb(M) vb(s) - vb(b)^TT vb(s)
$

with $M$ and $b$ that are learnable parameters; in particular $M$ is symmetric
and has zero diagonal (no self-recurrent connectivity). In this case we also
have $f(s_i, s_j) = s_i s_j$ that is a feature function that establish an
agreement between two nodes. Therefore, the induced distribution is

$ p(vb(s)) = 1 / Z e^(-E (vb(s))) " with " Z = sum_vb(s)' e^(-E(vb(s)')) $

which gives us the probability of a certain configuration.

The last piece we need is the probability of single neurons, which depends only
on its neighborhood; this is equivalent to compute the energy function with the
neuron $i$ having value $1$:


$ E(vb(s)) = sum_(j) M_(i j) s_j - b_i $

so that the probability

$ p(s_i = 1 | s_(backslash i)) = 1 / Z e^(-E(vb(s))) $
