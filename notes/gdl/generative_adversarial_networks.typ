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

This leads to the same loss for both models, with the only difference that one
tries to maximize it and the other one to minimize it.

== Original GAN Objective

Also the loss is just a
classification loss, that in the standard GAN formulation is the *binary cross
entropy*.

Intuitively, if the discriminator learns how to discriminate reals from fakes
using the BCE loss, the generator just tries to do the inverse optimization of
the same function in order to fool it.

In general we have that the BCE loss for one sample $x$, for which the network
outputs $hat(y)$ and whose true class is $y$, is defined as

$ L(y, hat(y)) = - y log hat(y) - (1-y) log (1 - hat(y)) $

Since it is used for binary classification one term cancels out depending on the
true class. If the discriminator is fed only with real samples (class label
$1$), the loss becomes

$ L(y, hat(y)) = - log hat(y) $

that we might want to reduce with the mean over $N$ samples

$
  L(Y, hat(Y)) = - 1/N sum_(n=1)^N log hat(y)^((n))
  = - 1/N sum_(n=1)^N log D_theta_D (x^((n)))
  = -EE_p_"data" [ log D_theta_D (x)]
$

Now we can apply the same reasoning for fakes samples, that will have label $0$
and so the corresponding BCE will be

$ L(y, hat(y)) = -log (1 - hat(y)) = -log (1 - D_theta_D (x)) $

therefore, the resulting BCE over $M$ fakes is

$
  L(Y, hat(Y)) = - 1/M sum_(m=1)^M log D_theta_D (G_theta_G (z^((m))))
  = -EE_p(z)[ log D_theta_D (G_theta_G (z))]
$

We can just sum the two terms obtaining the *original GANs objective*:

$ V(D, G) = log D_theta_D (x) + log(1 - D_theta_D (G_theta_G (z))) $

which is usually defined in its _positive_ formulation.

== Alternate Optimization

The optimization is done alternating discriminator's optimization steps to
generator's optimization steps. When one of the two model is optimized, the
other one has its weights freezed.

- *Discriminator step*: the discriminator *maximizes* the objective, since it
  wants to discriminate with high probability fakes from reals:

  $
    max_theta_D EE_(x tilde p_"data") [log D_theta_D (x)]
    + EE_(z tilde p(z)) [log(1 - D_theta_D (G_theta_G (z)))]
  $

- *Generator step*: the generator wants to *minimizes* it because its goal is to
  fool the discriminator, and since only the second term depends on $theta_G$,
  we can directly

  $ min_theta_G EE_(z tilde p(z)) [log(1 - D_theta_D (G_theta_G (z)))] $

In practice this loss often leads to very weak gradients for the generator, when
the discriminator is too good. For one generated sample we have

$ L(y, G_theta_G (z)) = log (1 - D_theta_D (G_theta_G (z))) $

that we want to optimize by taking the derivative w.r.t. $G_theta_G$:

$ pdv(L, G_theta_G) = frac(1, 1 - D_theta_D (G_theta_G (z))) $

If the discriminator is already good and fakes have label $0$, this means that
$D_theta_D (G_theta_G (z)) approx 0$, hence the gradient will be near to $1$.
Now since the discriminator has a sigmoid in the end that produced an near zero
output, it means that it is already in the saturating zone, producing near zero
gradients.

A common trick is to replace the objective for generator with a *non-saturating*
version

$ max_theta_G EE_(z tilde p(z)) [log(D_theta_D (G_theta_G (z)))] $

that has much better gradients for the first term that now is

$ pdv(L, G_theta_G) = frac(1, D_theta_D (G_theta_G (z))) $

which, if the discriminator produce something like $0.001$ probability of being
real, will result in gradient of $1000$ that can compensate the small sigmoid
gradient for which we can't do much.

This is like changing the labels of fakes just for generator step, resulting in
a discriminator that, even if correctly predicts the label, the loss will tell
it that is wrong and that it should classify that sample as real. In this way
the gradient will point towards the regions in which samples are considered real.

#note[
  It's possible to let the generator do multiple consecutive steps, while the
  discriminator remains freezed (or viceversa), trying to regulate one overcome
  the other.
]

== Saddle Point

The difficulty of training these models lies on the fact that the _minimax_
optimization defines the optimum in a *saddle point*, which is often unstable.

In fact if one of the two _players_ overcomes the other, that point could never
be reached. The most common case is for the discriminator to be too good, not
giving enough informations to the generator to improve, resulting in a bad local
optimum.

= Optimal Discriminator

For a fixed generator, we can derive the optimal discriminator that maximimes
the original GAN loss point-wise. Let $p_G$ be the generator distribution
induced by $G_theta_G$, hence, the optimal discriminator is

$ D^* (x) = frac(p_"data" (x), p_"data" (x) + p_G (x)) $

Substituting this in the original GAN objective makes clear how, under idealized
assumptions, GANs training is equivalent to minimize the divergence between
$p_"data"$ and $p_G$.

$
  V(D, G) = integral p_"data" (x) log D(x) dd(x) +
  integral p_G (x) log (1 - D(x)) dd(x)
$

and since this can be decomposed point-wise we can maximize

$ f(D) = p_"data" (x) log D + p_G log (1 - D) $

and now the derivative with respect to $D$ is

$ pdv(f, D) = frac(p_"data" (x), D) - frac(p_G (x), 1 - D) $

that is zero for

$
  frac(p_"data" (x), D) = frac(p_G (x), 1 - D) <==>
  D = frac(p_"data" (x), p_"data" (x) + p_G (x))
$

since $p_"data" (x)$ is always $1$ for a real sample and $0$ for a fake.

This implies that if generator-induced distribution has no overlap with the
data-generating distribution, we end up in this situation

$
  p_"data" (x) = 1 -> p_G (x) = 0 -> D(x) = 1 \
  p_"data" (x) = 0 -> p_G (x) = 1 -> D(x) = 0
$

resulting in the generator to have small gradients because the discriminator is
already too good.

= Mode Collapse

On the other end can happen that the generator learns to generate a very narrow
set of _plausible_ samples, which always fool the discriminator. In this
scenario, different latent codes can be mapped to nearly identical samples.

#note[
  This happens mostly because the generator is only rewarded for fooling the
  discriminator, without taking into account *coverage*.
]

= Latent Space Structure and Interpolation

A well trained GAN should map nearby latent vectors into similar outputs,
leading to smooth *semantic manipulations* and *linear interpolations*,
producing coherent outputs.

Even if not guarranteed, in practice should be possible to do

$ z_G = z_1 - z_2 + z_3 $

producing a sample that combines semantic features in a meaningful way.

Another possible thing to do should be interpolation

$ z(alpha) = (1 - alpha) z_1 + alpha z_2 $

that should produce a smooth interpolation between $z_1$ and $z_2$ varying
$alpha$.

= Wasserstein GANs

Even with the _non-saturating_ version of the loss, the problem can still be too
hard because

- For a good discriminator the sigmoid still tends to saturate, producing very
  small gradients.
- If structured images are in a completely different region w.r.t. the decoded
  latent code, it may still to hard to make the generator-induced distribution
  become equal to real data distribution.

A possible way to address the problem is to remove the sigmoid from the
discriminator, letting the output be an unrestricted *scalar score*. In this way
the discriminator becomes a *critic* that assigns scores to samples.

This leads to the definition of the *Wasserstein loss*:

$
  W(p_"data", p_G) = sup_(norm(D)_L <= 1) (EE_(x tilde p_"data") [D(x)]
    - EE_(z tilde p(z)) [D(G(z))])
$

that also gives the name to this type of GANs, called *WGAN*.

Intuitively if realistic samples are grouped in some region, they will have
similar scores and most important the score will be in some range of values.
While instead generated samples at the beginning will have a completely
different range of score values.

In this way the critic tries to increase the distance by maximizing the
difference of expectations, while the generator tries to minimize it.

== Wasserstein Distance and Lipschitz Constraint

The Wasserstein loss is based on the *Wasserstein distance* between two
distributions and measure how much _mass_ we need to move and how far to
transform a distribution into another.

In the original formulation we need a matrix $P$ that is the *transport plan*
and a discrete (or discretized) distribution. The Wasserstein distance is given
by

$ sum P dot | i - j | $

where $i$ is a possible value of the first distribution and $j$ is a possible
value of the second distribution. The sum is computed accross all the possible
values of the two distributions and $P$ represents the mass that must be moved.

#figure(
  image("images/wasserstein_distance.png", width: 90%),
  caption: [ Wasserstein Distance ],
)

This loss must be optimized under $1$-Lipschitz constraint, basically meaning
that the function is contractive on average and stable. This is enforced either
by weight clipping but can worsen the optimization; a much better solution is
simply given by gradient penalty.

= Adversarial Autoencoders

An interesting way to use _adversarial learning_ is to train autoencoders. An
*adversarial autoencoder (AAE)* keeps the reconstruction structure of an
autoencoder but replaces KL-based latent regularization with adversarial
learning in latent space.

The encoder produces a latent code

$ z = f_theta (x) $

and the decoder tries to reconstruct it

$ tilde(x) = g_theta (z) $

In the VAE formulation the KL term forces the encoder to produce latent codes
like they were sample from a prior distribution $cal(N) (vb(0), I)$.

In AAE we use a discriminator to discriminate between encoded latent codes and
latent codes sampled from the prior $cal(N) (vb(0), I)$. In this way the encoder
is forced to produce latent codes that resemble that distribution in order to
fool the discriminator.

Therefore, the training has two phases:

- *Reconstruction*: update the encoder and decoder to minimize the
  reconstruction loss.
- *Regularization*: use a discriminator in latent space to distinguish prior
  samples from encoded samples.

In this way we can avoid the KL term when the prior is complicated to compute.
