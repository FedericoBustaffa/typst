#import "@local/note_template:0.1.0": *
#show: doc => note_template([Normalizing Flows], doc)

#title()

In the class of *explicit* density learner with visible variables we have
*normalizing flows (NF)*, that learn an *invertible transformation* to morph a
simple probability density into an arbitrarily complex one.

To better visualize it let's start from *autoregressive models*, which define
the joint probability distribution through the chain rule, following the
structure of the Bayesian network generative process.

For sequences this is particularly intuitive, let's think about a Markov chain,
which factorizes the joint probability of a sequence as

$ p(x) = product_(t=1)^T p(x_t | x_(1:t-1)) $

that can be trained by maximum likelihood. The thing is that these models impose
a fixed joint probability factorization through the chain rule and the bayesian
network structure.

NFs don't use a BN to define the joint probability and then try to fit the model
to data; instead they learn a function $f$ that determines the shape of $p(x)$.

A direct consequence of this is that, starting from something like a VAE, we can
rid of the encoder, which kind of implements the posterior distribution which
needs to marginalize over latents, and replace it with a decoder that is also
able to map data sampled from $x$ back to its latent vector $z$.

This defines the *generative direction* in which we can sample

$ z tilde cal(N) (vb(0), I) $

transform it into a meaningful sample through some function

$ x = f(z) $

Then is possible to have back the latent code we started from just by using the
inverse

$ z = f^(-1) (x) $

defining the *normalizing direction*.

In practice a NF learns a sequence of invertible transformations that gradually
morphs a simple density into a complex target density.

Under the conditions of having a simple base distribution to sample and evaluate
and tractable Jacobian determinants for the function $f$, sampling is easy and
likelihood evaluation is exact.

= Change of Variable

In order to achieve a functioning NF, the core mechanism to morph one
distribution into another is the *change of variable*

#figure(
  image("images/change_of_variable.png", width: 50%),
  caption: [ 1-D Change Of Variable ],
)

In one dimension is simply defined by taking a random variable

$ z tilde p(z) $

and the invertible and differentiable function $f$ such that

$ x = f(z) $

A very important intuition is that probability mass must be conserved since we
are dealing with probability distributions that must remain valid, hence we can
write

$ p(z) dd(z) = p(x) dd(x) $

which means that

$ p(x) = p(z) abs(dv(z, x)) = p(f^(-1) (x)) abs(dv(f^(-1)(x), x)) $

#example[
  Let's assume $p(z) = cal(N) (0, 1)$ and define the affine transformation

  $ x = mu + sigma z quad quad sigma != 0 $

  which inverse is

  $ z = frac(x - mu, sigma) $

  Now we can apply the change of variable in order to obtain the data density

  $ p(x) = p(z) abs(dv(z, x)) = p(f^(-1) (x)) abs(dv(f^(-1)(x), x)) $

  so now we can simply substitute

  $
    p(f^(-1)(x)) & = p(frac(x - mu, sigma)) \
                 & = frac(1, sqrt(2 pi sigma^2))
                   exp(-1/2 (frac(frac(x-mu, sigma) - mu, sigma))^2) \
                 & = frac(1, sqrt(2 pi)) exp(-1/2 (frac(x - mu, sigma))^2)
  $

  since $mu=0$ and $sigma=1$ for the density of $p(z)$, while the $mu$ and
  $sigma$ defining $x$ are free parameters. Now if we compute the derivative

  $ dv(f^(-1)(x), x) = 1/sigma $

  we obtained the density of $x$ as

  $ p(x) = frac(1, abs(sigma) sqrt(2 pi)) exp(-1/2 (frac(x - mu, sigma))^2) $

  which is exactly the density of a gaussian of the shape $cal(N) (mu, sigma^2)$
  with the factor $abs(sigma)$ accounting for the change in interval length
  induced by the transformation.
]
