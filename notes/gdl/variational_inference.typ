#import "@local/note_template:0.1.0": *
#show: doc => note_template([Variational Inference], doc)

#let plot_kl_divergence() = {
  let gaussian(x, mu, sigma) = {
    let exponent = -calc.pow(x - mu, 2) / 2 * calc.pow(sigma, 2)
    let num = calc.exp(exponent)
    let denom = calc.sqrt(2 * calc.pi * calc.pow(sigma, 2))

    return num / denom
  }

  let kl_term(q, p) = {
    if q > 0 {
      q * calc.log(q / p)
    } else {
      0
    }
  }

  let x = lq.linspace(0, 4, num: 100)

  figure(
    lq.diagram(
      width: 60%,
      height: 4cm,
      grid: none,
      xaxis: none,
      yaxis: none,
      legend: (position: top + right, dx: 15%),
      {
        lq.plot(
          x,
          x => gaussian(x, 1.5, 2),
          stroke: red + 1pt,
          mark: none,
          label: [$q(z)$],
        )
      },

      {
        lq.plot(
          x,
          x => gaussian(x, 2.5, 1.75),
          stroke: blue + 1pt,
          mark: none,
          label: [$p(z)$],
        )
      },

      {
        lq.fill-between(
          x,
          x => kl_term(
            gaussian(x, 1.5, 2),
            gaussian(x, 2.5, 1.75),
          ),
          stroke: none,
          fill: rgb(0, 150, 0, 100),
          label: [$"KL"(q || p)$],
        )
      },
    ),
    caption: [Kullback-Leibler Divergence],
  )
}

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
close two distributions $p$ and $q$ are:

$ "KL" (q || p) = EE_q [log q(z) / p(z)] $

#plot_kl_divergence()

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

Now that we have the lower bound we need a measure of how _tight_ is w.r.t. our
distribution by using the KL divergence:

$
  "KL"(q(z | phi.alt) || p(z | x, theta))
  = EE_q [log q(z | phi.alt) - log p(z | x, theta)]
$

that using the Bayes rule on $p(z | x, theta)$ becomes

$
  "KL"(q || p)
  & = EE_q [log q(z | phi.alt) - log p(x, z | theta) + log p(x | theta)] \
  & = EE_q [log q(z | phi.alt)] - EE_p [log p(x, z | theta)] + EE_p [log p(x | theta)]
$

Since $log p(x | theta)$ does not depend on $z$ we can rewrite the equation as

$
  log p(x | theta) = EE_p [log p(x, z | theta)] - EE_q [log q(z | phi.alt)] +
  "KL"(q(z | phi.alt) || p(z | x, theta))
$

that brings back the ELBO previously defined as the difference of the first two
terms on the right-hand side:

$
  log p(x | theta) = cal(L) (x, theta, phi.alt) +
  "KL"(q(z | phi.alt) || p(z | x, theta))
$

And since the KL divergence is nonnegative, the ELBO is indeed a lower bound,
that is _tight_ if and only if

$ q(z | phi.alt) = p(z | x, theta) $

This also emphasizes the fact that _variational learning_ can be solved in two
equivalent ways: ELBO maximization or KL minimization. In particular, since we
also have to optimize the parameters of the model we have to

+ Optimize $phi.alt$ so that $q(z | phi.alt)$ approximates the posterior well.
+ Optimize $theta$ so that the model assigns high probability to the data.

The ELBO maximization is often preferred since the KL divergence minimization
not always exhibits a closed form.

= Generalized Expectation Maximization

So now we can finally define the *generalized expectation maximization* that
keeps the same structure but know the E-step is a *variational E-step*,
replacing the exact posterior with a tractable approximation.

+ *Variational E-step*: update $phi.alt$ to improve $q(z | phi.alt)$ under the
  current model parameters $theta^((k))$:

  $
    phi^((k)) in arg max_phi.alt sum_(i=1)^N cal(L) (x_i, theta^((k)), phi.alt)
  $

  or by KL divergence minimization.
+ *M-step*: update $theta$ to improve the bound under the current variational
  distribution:

  $
    theta^((k+1)) in arg max_theta
    sum_(i=1)^N cal(L) (x_i, theta, phi.alt^((k)))
  $

Let's also point out that in case the true posterior is tractable, if we choose
the variational such that

$ q(z | phi.alt^((k))) = p(z | x, theta^((k))) $

then $"KL"(q || p) = 0$ and so the ELBO becomes an equality:

$ cal(L) (x, theta, phi.alt) = log p(x | theta) $

and in this case, the variational E-step coincides with the classical E-step,
reducing to the exact EM algorithm. In fact if we apply the variational
inference to the GMM we obtain again the exact form, since its posterior is
tractable.
