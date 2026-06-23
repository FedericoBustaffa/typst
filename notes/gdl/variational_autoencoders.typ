#import "@local/note_template:0.1.0": *
#show: doc => note_template([Variational Autoencoders], doc)

#title()

The *variational autoencoder (VAE)* aims to explicitly learn a distribution
density, making possible to better organize the latent space in order to also
generate significative samples from it.

= Probabilistic View

The model has a strong probabilistic interpretation and in fact can be seen as
such, which also let us understand why it is called variational and why the
neural layers play an important role in it.

Thinking about it as a completely probabilistic model, the VAE is structured as
a GMM, with the important difference that the latent is continuous normal
distribution:

$ z tilde cal(N) (vb(0), I) $

While the observables are generic Gaussians conditioned on $z$:

$ x tilde p_theta (x | z) = cal(N) (x | mu_theta (z), Sigma_theta (z)) $

In this sense we defined the latent space core structure and a *conditional
decoder*, that all together define the *generative process* of the model as

+ Sample a latent code from the prior distribution $z tilde cal(N)(0, I)$.
+ Decode it with the conditional decoder distribution $x tilde p_theta (x | z)$.

This process defines the *joint distribution* (and *complete likelihood*) of
the model:

$ p_theta (x, z) = p_theta (x | z) p(z) $

which also gives the *data likelihood* of it by latents' marginalization

$
  p_theta (x) = integral p_theta (x, z) dd(z) = integral p_theta (x | z) p(z) dd(z)
$

And as for any latent variable model we can think of perform learning by maximum
likelihood, using the EM algorithm, for which we need the *posterior*

$
  p_theta (z | x) = frac(p_theta (x | z) p(z), p_theta (x))
  = frac(p_theta (x, z), p_theta (x))
$

The first thing we can notice about this posterior is the fact that at the
denominator we have again the data likelihood that, differently from a GMM, now
is continuous distribution that involve the computation of an integral of a non
trivial function.

== Variational Inference

The other thing we should notice is that the posterior has a complex structure,
like a multimodal gaussian, or something not even gaussian.

The assumption made by the model is that latent space is organized as gaussians,
so is reasonable to approximate it with a generic gaussian by *variational
inference*.

$ z tilde q_phi.alt (z | x) = cal(N) (z | mu_phi.alt (x), sigma_phi.alt (x)) $

that in theory let us perform learning by maximum likelihood with the
variational EM algorithm. In practice we will not perform explicit EM learning,
but it's useful to obtain the VAE *objective function*.

Let's start by simply stating that

$
  log p_theta (x) = cal(L) (x; theta, phi.alt) +
  "KL"(q_phi.alt (z | x) || p_theta (z | x))
$

with the ELBO defined as

$
  cal(L) (x; theta, phi.alt)
  = EE_(q_phi.alt(z | x)) [log p_theta (x, z) - log q_phi.alt (z | x) ]
$

and since the KL divergence is nonnegative

$ cal(L) (x; theta, phi.alt) <= log p_theta (x) $

meaning that optimizing the ELBO gives us a tractable lower-bound optimization
objective.

Now to obtain the VAE objective we need to expand the joint term

$ log p_theta (x, z) = log p_theta (x | z) + log p(z) $

defining an equivalent ELBO to the previous

$
  cal(L) (x; theta, phi.alt) & = EE_(q_phi.alt(z | x)) [log p_theta (x | z) +
    log p(z) - log q_phi.alt (z | x) ] \
  & = EE_(q_phi.alt(z | x)) [log p_theta (x | z) +
    log frac(p(z), q_phi.alt (z | x)) ] \
  & = EE_(q_phi.alt(z | x)) [log p_theta (x | z)] +
  EE_(q_phi.alt(z | x)) [ log frac(p(z), q_phi.alt (z | x)) ] \
  & = EE_(q_phi.alt(z | x)) [log p_theta (x | z)] + "KL"(q_phi.alt (z | x) ||
    p(z))
$

Where the first term is the *reconstruction term* that, tries to maximize the
probability $p_theta (x | z)$ for the latent sampled from $q_phi.alt (z | x)$.

The second term instead is a *regularization term* that keeps the variational
posterior close to the normal prior $cal(N) (vb(0), I)$.

== Close Form KL Divergence

In its standard formulation the VAE assumes the variational posterior to be a
gaussian with diagonal covariance matrix.

$ q_phi.alt (z | x) = cal(N)(mu_phi.alt (x), diag(sigma_phi.alt^2 (x))) $

and for this choice the KL divergence has a *closed form*

$
  "KL"(q_phi.alt (z | x) || p(z)) = 1/2 sum_(i=1)^K
  (mu_i (x)^2 + sigma_i (x)^2 - log sigma_i (x)^2 - 1)
$

with $K$ being the number of latent dimensions.

= Neural Encoder-Decoder

The novelty w.r.t. a "pure" probabilistic model and also a classic autoencoder,
is that now the variational posterior $q_phi.alt (z | x)$ is parameterized by a
*neural encoder*, that directly outputs the parameters

$ mu_phi.alt (x) quad sigma_phi.alt^2 (x) $

of the Gaussian:

$ q_phi.alt (z | x) = cal(N)(mu_phi.alt (x), diag(sigma_phi.alt^2 (x))) $

The decoder then receives a sampled latent code $z tilde q_phi.alt (z | x)$ and
defines a *reconstruction distribution* $p_theta (x | z)$.

== Reparameterization Trick

The problem here is that in the middle of the process we have a random sampling

$ z tilde q_phi.alt (z | x) $

that is not differentiable, meaning that we cannot backpropagate. A simple
solution to the problem is given by the *reparameterization trick*, which does
not use $mu(x)$ and $sigma^2(x)$ directly to sample the latent $z$.

The idea is to sample a random noise

$ epsilon tilde cal(N) (vb(0), I) $

while using $mu(x)$ and $sigma^2(x)$ as starting coordinates for the latent. The
noise is than multiplied element wise to the standard deviation, regulating
intensity and direction

$ z = mu(x) + sigma(x) dot.o epsilon $

defining a different architecture that now allows backpropagation.

#figure(
  image("images/vae.png", width: 70%),
  caption: [ Variational Autoencoder ],
)

The backpropagation is now possible because the randomness is independent of
everything else and so we can backpropagate through the encoder as usual.

This also slightly changes the objective function in

$
  cal(L) (x; theta, phi.alt) = EE_(epsilon tilde cal(N)(vb(0), I))
  [log p_theta (x | mu_phi.alt (x) + sigma_phi.alt (x) dot.o epsilon)]
  + "KL"(q_phi.alt (z | x) || p(z))
$

for a single sample, so that for the full dataset we just need to sum over all
samples

$ max_(theta, phi.alt) sum_(n=1)^N cal(L) (x^((n)); theta, phi.alt) $

= Sampling

Once the model is trained we can exploit the probabilistic structure to sample
from the latent space

$ z tilde cal(N) (vb(0), I) $

and decode it

$ tilde(x) tilde p_theta (x | z) $

hopefully obtaining a meaningful $x$.

This is now possible because the latent space is organized as gaussian
distribution; we also need to take into account that a strong regularization
towards a gaussian could prevent the model to organize the latent space enough
to also have a low reconstruction loss.

On the other end the model could be to powerful in terms of expressive power,
making the reconstruction term dominant, overfitting the training data and
losing the gaussian organization of the latent space.

= Conditional Variational Autoencoders

If available we can add some auxiliary variable $y$ like a class label to making
the model learn a conditional distribution $p_theta (x | y)$ which defines the
generative process of a *conditional variational autoencoder (CVAE)* as

$ z tilde p(z) quad quad x tilde p_theta (x | z, y) $

therefore, the variational posterior becomes

$ q_phi.alt (z | x, y) $

and the ELBO changes accordingly

$
  cal(L) (x, y; theta, phi.alt) =
  EE_(q_phi.alt (z | x, y)) [log p_theta (x | z, y)]
  - "KL"(q_phi.alt (z | x, y) || p(z))
$

This allow for conditional generation based on a class label $y$.
