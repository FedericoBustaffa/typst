#import "@local/note_template:0.1.0": *
#show: doc => note_template([Normalizing Flows], doc)

#let gaussian(x, mu, sigma) = {
  let exponent = -calc.pow(x - mu, 2) / 2 * calc.pow(sigma, 2)
  let num = calc.exp(exponent)
  let denom = calc.sqrt(2 * calc.pi * calc.pow(sigma, 2))

  return num / denom
}

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
get rid of the encoder, which kind of implements the posterior distribution
which needs to marginalize over latents, and replace it with a decoder that is
also able to map data sampled from $x$ back to its latent vector $z$.

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

It's very important understading that, under an invertible transformation, the
probability contained in a small volume is conserved between the two
distributions.

$ p(z) dd(z) = p(x) dd(x) $

from which we can derive

$ p(x) = p(z) abs(dv(z, x)) $

This tells that even if the volume under the curve stays the same, even if the
shape changes.

#figure(
  lq.diagram(
    width: 60%,
    height: 4cm,
    grid: none,
    xaxis: none,
    yaxis: none,
    legend: (position: top + right, dx: 35%),
    {
      let x = lq.linspace(-4, 4, num: 100)
      lq.plot(
        x,
        x => gaussian(x, 0, 1),
        stroke: red + 1pt,
        mark: none,
      )
    },
    {
      let x = lq.linspace(0, 1, num: 100)
      lq.fill-between(
        x,
        x => gaussian(x, 0, 1),
        stroke: 0pt,
        fill: red.transparentize(60%),
        label: [$p(z) dd(z)$],
      )
    },
    {
      let x = lq.linspace(5, 12, num: 100)
      lq.plot(
        x,
        x => gaussian(x, 9.5, 1.5),
        stroke: blue + 1pt,
        mark: none,
      )
    },
    {
      let x = lq.linspace(9.5, 11, num: 100)
      lq.fill-between(
        x,
        x => gaussian(x, 9.5, 1.5),
        stroke: 0pt,
        fill: blue.transparentize(60%),
        label: [$p(x) dd(x)$],
      )
    },
  ),
  caption: [ Change Of Variable Mass Conservation ],
)

So now we have a density defined in function of $z$ but this is only useful for
sampling, if we start from a given sample $x$ and we want to estimate its
density $p(x)$ we need a formulation in function of $x$, which can obtained
simply by using the inverse because $z = f^(-1) (x)$

$ p(x) = p(f^(-1) (x)) abs(dv(f^(-1)(x), x)) $

that now can be used to estimate the density of a sample $x$.

#example[
  Let's assume $p(z) = cal(N) (0, 1)$ and define the affine transformation

  $ x = mu + sigma z quad quad sigma != 0 $

  which inverse is

  $ z = frac(x - mu, sigma) $

  Now we can apply the change of variable in order to obtain the data density

  $ p(x) = p(z) abs(dv(z, x)) = p(f^(-1) (x)) abs(dv(f^(-1)(x), x)) $

  and since the density of $z$ is

  $ p(z) = frac(1, sqrt(2 pi)) exp(-1/2 z^2) $

  we can substitute $z$ obtaining

  $ p(f^(-1)(x)) = frac(1, sqrt(2 pi)) exp(-1/2 (frac(x - mu, sigma))^2) $

  The derivative instead is simply defined as

  $ abs(dv(f^(-1)(x), x)) = 1/abs(sigma) $

  putting everything together gives us the density of $x$

  $ p(x) = frac(1, abs(sigma) sqrt(2 pi)) exp(-1/2 (frac(x - mu, sigma))^2) $

  which is exactly the density of a gaussian $cal(N) (mu, sigma^2)$
  with the factor $abs(sigma)$ accounting for the change in interval length
  induced by the transformation.
]

== Multivariate Change Of Variable

In the multivariate case the interval length $dd(x)$ is replaced by the volume
change induced by the of the Jacobian, computed as its determinant:

$ p(x) = p(z) abs(det pdv(z, f)) = p(z) abs(det pdv(f, z))^(-1) $

for which we have again to use the inverse in order to define the density in
function of $x$

$
  p(x) = p(f^(-1)(x)) abs(det pdv(f^(-1)(x), f))
  = p(f^(-1)(x)) abs(det pdv(f, f^(-1)(x)))^(-1)
$

The Jacobian determinant measures how the transformation changes local volume
around a point.

== Forward and Inverse Flows

In general we can compose many transformations before sampling $x$, performing
an *iterated forward pass*; for two consecutive transformations we have

$ z_0 tilde p(z) -> z_1 = f_1 (z_0) -> x = f_2(z_1) $

therefore, the density obtained by forward transformations is obtained by

$
  p(z_0) dd(z_0) = p(z_1) dd(z_1) ==> p(z_1) = p(z_0) abs(dv(z_0, f_1(z_0))) \
  p(z_1) dd(z_1) = p(x) dd(x) ==> p(x) = p(z_1) abs(dv(z_1, f_2(z_1)))
$

Now we can simply substitute $p(z_1)$ in the second equation with the density
obtained in the first equation:

$ p(x) = p(z_0) abs(dv(z_0, f_1(z_0))) abs(dv(z_1, f_2(z_1))) $

that again is defined in function of $z$ that is not useful to density
estimation of a specific point, so we need to build the *inverse flow* using the
inverses:

$ x tilde p(x) -> z_1 = f_2^(-1) (x) -> z_0 = f_1^(-1) (z_1) $

that translates in

$
  p(x) & = p(f_1^(-1)(f_2^(-1)(x)))
         abs(dv(f_1^(-1)(f_2^(-1)(x)), f_1(f_1^(-1)(f_2^(-1)(x)))))
         abs(dv(f_2^(-1)(x), f_2 (f_2^(-1) (x)))) \
       & = p(f_1^(-1)(f_2^(-1)(x)))
         abs(dv(f_1^(-1)(f_2^(-1)(x)), f_2^(-1)(x)))
         abs(dv(f_2^(-1)(x), x))
$

now defined in terms of $x$ only.

For the multivariate case the same reasoning can be applied introducing the
determinant of the Jacobian

$
  p(x) = p(f_1^(-1)(f_2^(-1)(x))) abs(det pdv(f_1^(-1)(f_2^(-1)(x)), f_2^(-1)(x)))
  abs(det pdv(f_2^(-1)(x), x))
$

That can be written in a more general notation considering general Jacobians for
each function and compositions:

$ p(x) = p(z_0) product_(k=1)^K abs(det J_f_k (z_(k-1)))^(-1) $

That of course can be rewritten in log-space for numerical stability

$ log p(x) = log p(z_0) - sum_(k=1)^K log abs(det J_f_k (z_(k-1))) $

with $K$ being the number of transformations used.

= Simple Normalizing Flow Layers

Let's start defining the most simple layers for normalizing flows, starting from
the *affine linear layer*:

$ f(z) = W z + b $

with $W$ that needs to be full rank to be invertible, then

$ J_f (z) = W quad ==> quad log abs(det J_f) = log abs(det W) $

This is exact but for unrestricted dense $W$ the determinant could be exponsive
and that's why we can choose *diagonal* or *triangular* matrices whose
determinant is much simpler to compute, however they pay the price of poor
expressive power.

Another interesting matrix to use is the *permutation* matrix, which has a lot
of nice properties like being volume preserving and has determinant equal to
$1$, and it's used to mix which variables interacts.

Of course also *pointwise nonlinearities* are a type of layer that must be used
with others to gain expressivity. The good thing about these layers is that the
Jacobian is diagonal so their determinant is easy

$ log abs(det J_f (z)) = sum_(i=1)^D log abs(f_i' (z_i)) $

= Coupling Flows

The first more structured layer is called *coupling flows*, that gains
expressive power with nonlinear transformations while keeping inversion and
Jacobian determinants easy.

#figure(
  image("images/coupling_flows.png", width: 80%),
  caption: [ Coupling Flows ],
)

The idea is to partition the input in two blocks:

$ z = (z_1, z_2) $

the first block stays unchanged, but is used to as input to a neural network to
predict the parameters for the second block:

$ underbrace(z'_1 = z_1 quad quad z'_2 = f(z_2; theta(z_1)), z') $

where $theta(z_1)$ is a neural network. The first block acts as _conditioning_
information to transform the other block and since $z_1$ is copied the inversion
is straightforward

// check the argument of theta
$ z_1 = z'_1 quad quad z_2 = f^(-1) (z'_2; theta(z'_1)) $

== Additive Coupling

A simple coupling layer is the *additive coupling*, which of course simply
performs an addition

$ z'_1 = z_1 quad quad z'_2 = z_2 + theta(z_1) $

whose inverse is immediate

$ z_1 = z'_1 quad quad z_2 = z'_2 - theta(z'_1) $

and the Jacobian has a very nice form for determinant computation:

$
  J = mat(I, 0; pdv(theta(z_1), z_1), I) quad ==> quad det J = 1
  quad ==> quad log abs(det J) = 0
$

To make the model more powerful it is possible to place *shuffling* between
layers in order to not generate always parameters in function of $z_1$ that,
without shuffling, will remain the same.

#figure(
  image("images/additive_coupling_shuffle.png", width: 60%),
  caption: [ Additive Coupling with Shuffling ],
)

= Multiscale Flows, Masking and Squeezing

A more powerful flow layer, that finds motivation mostly for image processing,
can be implemented in general by using three fundamental operations

*Masking*: a binary mask selects which subset of variables is copied and which
one is transformed.

*Squeezing*: tries to find a compromise between spatial resolution and channel
depth just by rearranging an input with shape $s times s times c$ into
something like $s/2 times s/2 times 4c$.

*Multiscale factorization*: instead of partitioning the input in just two
pieces we can have more partitions to add complexity.

#figure(
  image("images/multiscale_flow.png", width: 60%),
  caption: [ Multiscale Flow ],
)

In this scenario the usual coupling flow mechanism is applied but this time
incrementally. We can say that certain output partition $z'_i$ depends on
every previous output partition $z'_(1:i-1)$ and the corresponding input
partition $z_i$.

== Multiscale Nonlinear Flow

An implementation of this multiscale flow with masking and squeezing is the
following:

$
  z_2' = underbrace(exp(theta_A (z_1)) dot.o z_2, "scale") +
  underbrace(theta_B (z_1), "shift")
$

whose inverse is

$ z_2 = frac(z'_2 - theta_B (z'_1), exp(theta_A (z'_1))) $

and the Jacobian is defined as

$ J = mat(I, 0; pdv(theta_B (z_1), z_1), diag(exp(theta_A (z_1)))) $

= Autoregressive Flows

An *autoregressive flow* treats each dimension of the input as an independent
block and each output block depends on every previous one.

#figure(
  image("images/autoregressive_flow.png", width: 60%),
  caption: [ Autoregressive Flow ],
)

The general form of an autoregressive flow transformation is

$ x_i = f_i (z_i ; theta_i (z_(1:i-1))) $

In this way, coordinates generated later have more expressive dependencies, yet
the determinant is still easy to compute since the Jacobian is triangular.

== Masked Autoregressive Flows

A particular case is represented by the *masked autoregressive flow (MAF)*, that
uses an autoregressive Gaussian transformation

$ x_i = mu_i + z_i exp(s_i) $

where $mu_i = mu_i (x_(1:i-1))$ and $s_i = s_i (x_(1:i-1))$ and equivalently the
inverse is

$ z_i = (x_i - mu_i) exp(-s_i) $

Again the Jacobian is low triangular with its diagonal entries being

$ pdv(x_i, z_i) = exp(s_i) $

therefore

$
  det pdv(x, z) = product_(i=1)^D exp(s_i) quad ==>
  quad log abs(det pdv(x, z)) = sum_(i=1)^D s_i
$

= Residual Flows

An attempt to achieve dense Jacobians close to full rank to gain much more
expressive power while remaining invertible is given by *residual flows*:

$ f(z) = z + theta(z) $

which requires $theta$ to be Lipschitz with constant $L < 1$:

$ norm(theta(z) - theta(f(z))) <= L norm(z - f(z)) $

to be invertible.

The intuition here is that the residual update is small enough that the layer
remains a perturbation of the identity.

The inverse has no general close form solution but can be approximated by
*Banach fixed point* iteration:

$ z^(m+1) = f(z) - theta(z^m) $

which converges under contraction condition above.

More expressive Jacobians come at the cost of expensive determinant computation

$ log abs(det J_f (z)) = log det(I + J_theta (z)) $

which is usually approximated by _series expansion_

$
  log det(I + J_theta (z)) = sum_(k=1)^oo frac((-1)^(k+1), k) tr(J_theta (z)^k)
$

that is valid under certain spectral conditions. Also the trace can be
approximated by *Hutchinson's stochastic trace estimator* method.

== Continuous Normalizing Flows

A residual flow can be seen as a discretized dynamical system:

$ f(z) = z + delta theta(z) $

that rearranging terms becomes

$ theta(z) = frac(f(z) - z, delta) $

which looks like a *derivative*. We want to make it more explicit by considering
a generic $z_t$ and $theta(z_t) = z_(t+delta)$ the infinitesimal update for
$delta -> 0$

$ z_(t+delta) = z_t + delta theta_t (z_t) = z_t + delta pdv(z_t, t) $

with $theta_t (z_t)$ being the istantaneous change of variable.

Supposing now to cascade multiple residual layers, yielding the decomposition

$ f_T compose f_(T-1) compose dots.c compose f_1 $

Using the istantaneous update previously defined, we can represent the chain of
transformation by an *ordinary differential equation (ODE)*:

$
  cases(
    z_0 tilde N(0, 1) & " initial conditions",
    pdv(z_t, t) = theta_t (z_t) & " istantaneous update"
  )
$

which is the reason we can call this kind of model *continuous normalizing flow
(CNF)*.

If now plug the above continuous formulation in the change of variable setting
we can compute the log-likelihood for istantaneous change of variables as

$ log p(x) = log p(z_0) - integral_0^T tr(J_z_t (theta_t)) dd(t) $

which can be solved by numerical integration without computing the determinant.

#important[
  The conceptual shift is that now instead of composing finitely many discrete
  layers, is possible to evolve the latent variable continuously in time.
]
