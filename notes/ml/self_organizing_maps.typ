#import "note_template.typ": *
#show: note_template

#title("Self Organiniziing Maps")

A model based on vector quantization and that can be used for clustering and
dimensionality reduction is the #strong[self organizing map (SOM)];. This model,
in order to avoid confinement to local minima, uses the #strong[soft-max]
adaptation rule: not only the winner reference is updated but all references are
affected depending on their distance to the input $x$.

The self organizing map consists of $N$ neurons located on a regular
low-dimensional grid (usually 2D). Each unit can be identified by the coordinate
on the map, receives the same input $x$ and has a weight $w$ that lives in input
space.

SOMs learn a map from input space to a lattice of neural units that preserves
topology. Neighboring units respond to similar input pattern and data points
close in the input space are mapped onto the same or #emph[nearby map units];.

The aim of the SOM is to learn a map from vectors to a discrete output space
(the coordinates of the unit on the map). The map is randomly initialized and
has two phases for each iteration

- #strong[Competitive stage];: the winner is the most similar unit to $x$.
- #strong[Collaborative stage];: update weights of the units that have
  topological relationships with the winner unit (soft-max approach).

The algorithm continues until convergence criterion is met.

A critical aspect is the collaborative stage, where each neuron moves towards
the input $x$ considering two forces:

- The distance between $w$ and $x$ in input space: the greater the distance the
  bigger the update.
  $ w_i (t + 1) = w_i (t) + eta (t) dot.op h_(i , i^(\*)) (t) [x - w_i (t)] $
- The topological distance between the neuron and the #emph[winner] on the grid.
  The higher the distance the smaller is the update.
  $
    h_(i , i^(\*)) (t) = exp (- frac(
        parallel r_i - r_(i^(\*)) parallel^2, 2
        sigma (t)^2
      ))
  $

This two forces are typically not equally strong: the first is proportional to
the distance, while the other decays exponentially with the distance, resulting
in very tiny updates for very far away neurons.

Let’s notice that learning rate and neighbourhood radius values ($sigma$) are
decreased as function of iteration $t$.

= References <references>

- Unsupervised Learning
