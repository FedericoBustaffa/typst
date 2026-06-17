#import "@local/note_template:0.1.0": *
#show: doc => note_template([Batch Normalization], doc)

#title()

A common phenomenon that happens when the network becomes deeper and is trained
with batch or mini-batch is that the distribution of the activations can vary
significantly across epochs due to weights update.

A way to stabilize the activations distribution of a mini-batch is called *batch
normalization*, which applies a gaussian normalization (standardization) to it:

$
  mu_B = 1 / N_B sum_(i=1)^(N_B) h_i, quad
  sigma_B^2 = 1 / N_B sum_(i=1)^(N_B) (h_i - mu_B)^2 \
  hat(h)_i = frac(h_i - mu_B, sqrt(sigma_B^2 + epsilon))
$

This process changes activations in order to have mean $0$ and variance $1$.
What can be done after is to rescale and shift the normalized activations with
learnable parameters $gamma$ and $beta$:

$ h_i' = gamma hat(h)_i + beta $

so that the network can decide either to keep activations normalized, bring
everything back or a compromise between the two.

This is a common technique that often improves optimization and stability during
training.
