#import "@local/note_template:0.1.0": *
#show: doc => note_template([Diffusion Models], doc)

#title()

In the family of explicit density learners models with latent variables we can
find the *diffusion model (DM)*, which defines a *diffusion process*, that
gradually corrupts an input adding noise and then try to reconstruct it by
removing the noise.

In this sense the generation is divided in many simple steps which may be
simpler than generate something like an image from pure noise in one shot like a
GAN would do.

The first direction of the process is called *forward diffusion*, that
informally is simply something like

$ x = z_0 -> z_1 -> dots.c -> z_T $

with each $z_t$ that is slightly noisier than the previous and with $z_T$ that
should be approximately Gaussian noise sampled from $cal(N) (vb(0), I)$ for a
$T$ sufficiently large.

The *reverse denoising* process follows the same exact logic, reverting the
sequence

$ z_T -> z_(T-1) -> dots.c -> z_0 = x $

Therefore, the simple idea behind diffusion models is to learn the reverse of
noising process.

= Forward Diffusion

The forward diffusion process is implemented by a Markov chain that gradually
adds Gaussian noise. A standard choice is

$ q(z_t | z_(t-1)) = cal(N) (sqrt(1 - beta_t) z_(t-1), sqrt(beta_t) I) $

with $beta_t in [0, 1]$. This formulation is crucial in order to have in the end
that

$ q(z_T | z_(T-1)) approx cal(N)(vb(0), I) $

for $T$ sufficiently large.


#note[
  Adding noise from normal distribution will cause the variance to grow at each
  step; we want instead something that, independetly from the input and the
  amount of steps done, will converge to a standard normal distribution.
]

Equivalently we can do a reparameterization trick and sample

$ epsilon_t tilde cal(N) (vb(0), I) $

and construct the corrupted sample at time $t$ as

$ z_t = sqrt(1-beta_t) z_(t-1) + sqrt(beta_t) epsilon_t $

In some formulation $beta$ is fixed for every time and has value in $[0,1]$. In
our, more expressive, formulation we will use a *time schedule* $beta_t$
defining a scaling factor for each time step.

Since the forward process is modelled by a Markov chain, we can write its joint
probability as

$ q(z_(1:T) | x) = product_(t=1)^T q(z_t | z_(t-1)) $

similarly to what we would have done describing the generative process for a BN.

== Diffusion Kernel

The full forward process is simple to simulate but costly if $T$ is large and
data is high-dimensional. It would be nice to have a way to sample an
intermediate step $z_t$ in one shot without explicitly building the full chain.

Let's define the following (nonsense) substitution

$ alpha_t = 1 - beta_t $

so that the previous formulation rewrites as

$ z_t = sqrt(alpha_t) z_(t-1) + sqrt(1 - alpha_t) epsilon_t $

If we now generate the first two elements of the forward process we will have

$
  z_1 & = sqrt(alpha_1) x + sqrt(1 - alpha_1) epsilon_1 \
  z_2 & = sqrt(alpha_2) z_1 + sqrt(1 - alpha_2) epsilon_2
$

and if substitute $z_1$ in the second formulation we will obtain

$
  z_2 & = sqrt(alpha_2) (sqrt(alpha_1) x + sqrt(1 - alpha_1) epsilon_1)
        + sqrt(1 - alpha_2) epsilon_2 \
      & = sqrt(alpha_1 alpha_2) x + sqrt((1 - alpha_1) alpha_2) epsilon_1
        + sqrt(1 - alpha_2) epsilon_2
$

Now since the two $epsilon$ are randomly sampled every time, we can treat them
as a random variable and since $epsilon_1$ and $epsilon_2$ are independent
random variables we can sum them as

$ X = a dot epsilon_1 + b dot epsilon_2 $

that is still Gaussian with mean

$ EE[X] = a EE[epsilon_1] + b EE[epsilon_2] = a dot 0 + b dot 0 = 0 $

and variance

$
  "Var"(X) & = EE[(X - EE[X])^2] = EE[X^2]
             = EE[(a dot epsilon_1 + b dot epsilon_2)^2] \
           & = a^2 E[epsilon_1^2] + b^2 E[epsilon_2^2] + 2 a b EE[epsilon_1]
             EE[epsilon_2] = a^2 + b^2
$

So now we can rewrite the sum of the two terms as

$
  sqrt((1 - alpha_1) alpha_2) epsilon_1 + sqrt(1 - alpha_2) epsilon_2
  = (a^2 + b^2) epsilon = sqrt(1 - alpha_1 alpha_2) epsilon
$

and the full formulation for $z_2$ as

$
  z_2 & = sqrt(alpha_1 alpha_2) x + sqrt(1 - alpha_1 alpha_2) epsilon
$

if we now pack $alpha_1 alpha_2$ in one value $overline(alpha)_2$ we can rewrite
the formula as

$
  z_2 & = sqrt(overline(alpha)_2) x + sqrt(1 - overline(alpha)_2) epsilon
$

that by induction becomes

$
  z_t & = sqrt(overline(alpha)_t) x + sqrt(1 - overline(alpha)_t)
        epsilon quad " with "
        overline(alpha)_t = product_(t=1)^T alpha_t
$

So for a fixed $T$ we can compute every $overline(alpha)_t$ and store them in
memory in order to compute a generic $z_t$ in one shot without the need of
constructing the full forward diffusion process.

== Diffusion Process Distribution

Denoting with $q(x)$ the data distribution, then the distribution of the noisy
variable at time $t$ is

$ q(z_t) = integral q(x) q(z_t | x) d x $

that can "ignore" intermediate representations for the diffusion kernel in
closed form which make possible to sample $z_t$ directly without using the full
chain.

= Reverse Diffusion

Now that we defined the forward process as a Markov chain we want to invert the
chain in order to generate $x$ starting from $z_T$. Ideally at each step we want
to compute the reverse transition

$ q(z_(t-1) | z_t) = frac(q(z_t | z_(t-1)) q(z_(t-1)), q(z_t)) $

that is a _posterior_ if we consider the forward process as the generative
process of a BN. The problem is that at some point in the reverse chain we will
have

$ q(x | z_1) = frac(q(z_1 | x) q(x), q(z_1)) $

and $q(x)$ is not simply difficult to compute, is completely unknown in
analytical form. We just have the empirical distribution that approximate it
pointwise.

A crucial observation to be able to train the model is that if the original $x$
is known, then the *reverse conditional*

$ q(z_(t-1) | z_t, x) $

is tractable and Gaussian, allowing for the derivation of a *variational
training objective* that approximates the true one.

The idea is to build a parameterized *reverse Markov* chain:

$ p_theta (z_(t-1) | z_t) = cal(N) (mu_theta (z_t, t), sigma_t^2 I) $

with $mu_theta (z_t, t)$ predicted from a neural network and with a fixed
terminal prior:

$ p(z_T) = cal(N) (vb(0), I) $

In this setting is possible to generate samples through ancestral sampling
following the chain of conditional probabilities starting from $z_T$.

== Variational Objective

The new chain is very similar to a classical generative model where a latent
random variable $z$ starts a generative process of the original data $x$.

In this sense is possible to define the joint probability distribution as we
would for a Markov chain

$ p_theta (x, z_(1:T)) = p(z_T) product_(t=1)^T p_theta (z_(t-1) | z_t) $

from which we can derive the data log-likelihood:

$ log p_theta (x) = log integral p_theta (x, z_(1:T)) d z_(1:T) $

which is intractable for maximum log-likelihood learning. To solve the problem
we can use the forward distribution as inference distribution

$
  log integral p_theta (x, z_(1:T)) d z_(1:T)
  & = log integral q(z_(1:T) | x) frac(p_theta (x, z_(1:T)), q(z_(1:T)|x)) d z_(1:T) \
  & = log EE_q(z_(1:T)|x) [frac(p_theta (x, z_(1:T)), q(z_(1:T)|x))]
$

that by using Jensen inequality becomes

$
  log EE_q(z_(1:T)|x) [frac(p_theta (x, z_(1:T)), q(z_(1:T)|x))]
  & >= EE_q(z_(1:T)|x) [log frac(p_theta (x, z_(1:T)), q(z_(1:T)|x))] \
  & = EE_q(z_(1:T)|x) [log p_theta (x, z_(1:T)) - log q(z_(1:T)|x)] \
  & = EE_q(z_(1:T)|x) [log p_theta (x) + log p_theta (z_(1:T)) - log q(z_(1:T)|x)]
$

Now since both the numerator and the denominator can be factorized using
conditional independence, together with the logarithm property we can write

$
  EE_q(z_(1:T)|x) [log p_theta (x, z_(1:T))] =
  sum_(t=1)^T
$

