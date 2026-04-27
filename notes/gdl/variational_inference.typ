#import "@local/note_template:0.1.0": *
#show: doc => note_template([Variational Inference], doc)

#title()

There are times in which the evaluation of the posterior made by the EM
algorithm is intractable because we may have to deal with a complex
distributions of coupled latents (dependent one another) that don't have a
closed form.

Learnig by maximum likelihood aims to maximize the log-likelihood, that, in
presence of latent variables, involves marginalization over them, including
sums and integrals in the objective function:

$ log P(X | theta) = sum_(i=1)^N log integral_z log P(x, z | theta) d z $

Since we usually use the EM algorithm to train a latent variable model, we need
to compute the posterior at each step

$ P(Z | X) = frac(P(X, Z), P(X)) $

that at the denominator has the incomplete likelihood which in log-space is
defined as the logarithm of a sum that could be intractable.

To overcome this issue, a popular optimization choice is *variational inference*
that introduces approximations of the untractable distributions that easier to
compute.

= Variational Calculus

Before proceeding we need to introduce two tools from variational calculus,
which aims to optimize over functions or distributions:

$ max_q cal(F) (q) $

where $cal(F)$ is a *functional* and $q$ is the objective we aim to optimize,
that in our case is a distribution $q(z | phi.alt)$.

The first tool we need is the *Kullback-Leibler divergence* that measures how
close two distributions $p$ are $q$:

$ "KL" (q || p) = EE_q [log q(z) / p(z)] $

that is always nonnegative and equals to zero if and only if $q(z) = p(z)$
almost everywhere. In our setting the key comparison is between the variational
approximation and the true posterior:

$
  "KL" (q(z | phi.alt) || p(z | x, theta))
  = EE_q(z|phi.alt) [log q(z | phi.alt) / p(z | x, theta) ]
$

Let's also notice that the KL divergence is not symmetric:

$ "KL" (q || p) != "KL" (p || q) $

The other tool is the *Jensen inequality* which says that for a concave function
$f$, like the logarithm it holds that

$ f(EE[Y]) >= EE[f(Y)] $

This is very useful to systematically break the logarithm of sum form we usually
get for the data likelihood.

= Evidence Lower Bound

The core idea is to define a lower bound on the data log-likelihood that is
tractable, the *evidence lower bound (ELBO)*.

Let's start from the marginal likelihood for a single observation $x$:

$ log p(x | theta) = log integral p(x, z | theta) d z $

and introduce any distribution $q(z | phi.alt)$ that is nonzero where $p(x, z |
  theta)$ is nonzero and use the identity:

$
  integral p(x, z | theta) d z
  = integral q(z | phi.alt) p(x, z | theta) / q(z | phi.alt) d z
  = EE_q(z | phi.alt) [ p(x, z | theta) / q(z | phi.alt) ]
$

Therefore

$
  log p(x | theta) = log EE_q(z | phi.alt) [ p(x, z | theta) / q(z | phi.alt) ]
  >= EE_q(z | phi.alt) [ log p(x, z | theta) / q(z | phi.alt) ]
$

for the Jensen inequality, since we are using a concave function such as the
logarithm. So now we can define the ELBO as

$
  cal(L) (x, theta, phi.alt)
  = EE_q(z | phi.alt) [log p(x, z | theta)] -
  EE_q(z | phi.alt) [log q(z | phi.alt)]
$

where the first term is an *energy* term and the second is the *entropy* of $q$.

For a dataset $cal(D) = {x_1, dots, x_N}$ with (typically independent) latent
variables $z_1, dots, z_N$, a common choice is a factorized variational
distribution

$ q(vb(z) | phi.alt) = product_(i=1)^N q(z_i | phi.alt) $

yielding

$
  log p(cal(D) | theta) = sum_(i=1)^N log p(x_i | theta)
  >= sum_(i=1)^N cal(L) (x_i, theta, phi.alt)
$
