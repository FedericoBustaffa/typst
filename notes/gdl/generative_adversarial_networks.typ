#import "@local/note_template:0.1.0": *
#show: doc => note_template([Generative Adversarial Networks], doc)

#title()

A model in the class of _implicit_ density learner is the *generative
adversarial network (GAN)*, which learns a way to transform noise into
meaningful data.

In particular the model does not learn a probability distribution density and
give up the latent space organization. This can be good because there is no need
to compute the likelihood in high-dimensional space which often introduce
tractability issues.

Instead the model learns a way to sample from a simple latent prior distribution
like

$ z tilde cal(N) (vb(0), I) $

and train a *generator* to decode it in something similar to samples belonging
to the true data distribution.

$ tilde(x) = G_theta_G (z) $

The problem is that differently from an AE or a VAE we are not trying to decode
a latent code coming from an encoded true sample. Here we have a latent code but
no target to compare with.

To solve the issue we also need to train a *discriminator*, that simply is a
binary classifier that tries to discriminate between _real_ samples and _fakes_.

= Adversarial Learning

Generator and discriminator are trained simoultaneously with the discriminator
receiving either real and fake samples, respectively labeled with $1$ and $0$:

$ D_theta_D (x) -> 1 quad quad D_theta_D (G_theta_G (z)) -> 0 $

The generator instead wants to fool the discriminator by making it classify fake
samples as real

$ D_theta_D (G_theta_G (z)) -> 1 $

This double problem can be addressed by the same objective function, that for
one pair of samples (one real and one generated) is

$ V(D, G) = log D_theta_D (x) + log(1 - D_theta_D (G_theta_G (z))) $

that basically is the _binary cross entropy loss_ that, for the full dataset,
becomes

$
  V(D, G) = EE_(x tilde p_"data") [log D_theta_D (x)]
  + EE_(z tilde p(z)) [log(1 - D_theta_D (G_theta_G (z)))]
$

The optimization is done alternating discriminator's optimization steps to
generator's optimization steps. When one of the two model is optimized, the
other one has its weights freezed.

The discriminator tries to maximize the objective, since it wants to
discriminate with high probability fakes from reals:

$
  max_theta_D EE_(x tilde p_"data") [log D_theta_D (x)]
  + EE_(z tilde p(z)) [log(1 - D_theta_D (G_theta_G (z)))]
$

while the generator wants to minimize it because its goal is to fool the
discriminator.

$ min_theta_G EE_(z tilde p(z)) [log(1 - D_theta_D (G_theta_G (z)))] $

In practice this loss often leads to very weak gradients when the discriminator
is already good, so it has been replaced with a *non-saturating* version

$ max_theta_G EE_(z tilde p(z)) [log(D_theta_D (G_theta_G (z)))] $

that can be interpreted as the goal for the generator of maximizing the error of
discriminator, instead of minimizing the probability of a correct
classification.

== Saddle Point

The difficulty of training these models lies on the fact that the _minimax_
optimization defines the optimum in a *saddle point*, which is often unstable.

In fact if one of the two _players_ overcomes the other, that point could never
be reached. The most common case is for the discriminator to be too good, not
giving enough informations to the generator to improve.
