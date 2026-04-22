#import "@local/note_template:0.1.0": *
#show: doc => note_template([Biased Coin], doc)

#title()

The most simple case of probabilistic model is the one that fits the
distribution parameters of coin toss. The *generative process* is trivial: all
the sample are simply draw from a Bernoulli distribution of parameter $theta$.

$ P(X = x) tilde cal(B)(theta) = theta^x dot (1 - theta)^(1-x) $

where $x$ can only be $0$ or $1$.

= Maximum Likelihood

Since all the samples are for sure i.i.d. we can define the *likelihood* as

$
  P(X | theta) = product_(i=1)^N P(x_i | theta)
  = product_(i=1)^N theta^(x_i) (1 - theta)^(1 - x_i)
  = theta^(n_H) (1 - theta)^(n_T)
$

with $n_H$ being the number of heads and $n_T$ being the number of tails. Since
we want to work in log space it becomes

$ cal(L) (theta | d) = n_H theta + n_T (1 - theta) $

which derivative is

$ (partial cal(L)) / (partial theta) = n_H / theta - n_T / (1 - theta) $

and it is zero when

$ quad theta = n_H / (n_H + n_T) = n_H / N $

that basically is the simplest probability rule.

= Maximum a Priori

If we want to add *prior* knowledge we can learn by MAP in order to maximize the
*posterior*

$ P(theta | d) = P(d | theta) P(theta) $

and for this particular case we use the conjugate prior distribution that is a
beta and basically adds _pseudo counts_ as prior knowledge.

The idea is that we don't want to directly put our belief on the parameters but
just the knowledge we have on the problem that is not present in the
observations. In this case we still don't know what is the real value of $theta$
but we can say something like: "I saw 45 times head and 55 tails yesterday", so
that the optimization take into account also that.

$
  P(theta | d) = P(d | theta) P(theta) =
  underbrace(theta^(n_H) (1 - theta)^(n_T), "Bernoulli") dot
  underbrace(
    frac(
      theta^(alpha - 1) (1 - theta)^(beta - 1),
      B(alpha, beta)
    ), "Beta"
  ) =
  underbrace(
    frac(
      theta^(n_H + alpha - 1) (1 - theta)^(n_T + beta - 1),
      B(alpha + n_H, beta + n_T)
    ), "Beta"
  )
$

that can be optimized like before and without considering the constant at the
denominator, since does not affect the optimization problem:

$ cal(L) = theta^(n_H + alpha - 1) (1 - theta)^(n_T + beta - 1) $

and so like before we can use the logarithm in order to transform the formula in

$ cal(L) = (n_H + alpha - 1) theta + (n_T + beta - 1) (1 - theta) $

whose derivative is

$
  (partial cal(L)) / (partial theta) = (n_H + alpha - 1) / theta -
  (n_T + beta - 1) / (1 - theta)
$

which is zero for

$
  theta = (n_H + alpha - 1) / (n_H + alpha - 1 + n_T + beta - 1)
  = (n_H + alpha - 1) / (N + alpha + beta - 2)
$

similary to the previous case.

