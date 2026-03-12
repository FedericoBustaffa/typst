#import "@local/note_template:0.1.0": *
#show: doc => note_template([Fully Observable Variables Learning], doc)

#title()

The most simple case of probabilistic inference is when the bayesian network is
already defined and all the variables are *observable*. In general there is an
hypothesis $h_theta$ that better explains the data, and so is more suitable to
answer a query.

Depending on the inference method we are using, the problem to solve is
different:

- *Bayesian learning*: we can directly answer the query by computing the
  probability of it over all the possible explainations (hypothesis $h_theta$)

  $ P(X | theta) = integral_theta P(X | h_theta) P(h_theta | d) d theta $

  In this scenario every the answer is weighted over all possible realizations
  of $h_theta$; the most likely will weight more because it better explains data
  but the others will _smooth_ the result.
- *Maximum Likelihood (ML)*: in this case we have to find first the parameter $theta$
  the most likely explains the data, in order to update the posterior (the
  second term of the integral above). In order to do that we can maximize the
  *likelihood* given by the Bayes rule:

  $ P(h_theta | d) = (P(d | h_theta) P(h_theta)) / P(d) $

  This can be a good choice if any prior is equally probable, but is completely
  *data-driven* and can be prione to over-fitting.
- *Maximum a Priori (MAP)*: this is like maximum likelihood but introduce a
  preference accross all the possible hypothesis. So it tries to maximize both
  term at the numerator of the Bayes rule. Moreover it adds a regularization
  effect, particularly useful in low data density situations.

The concept of ML and MAP are similar and are usually faced in the same way. For
the ML we want to find $theta$ that is more likely to have generated the data,
assuming $d$ is independently and identically distributed.

$
  theta = arg max_(theta in Theta) P(d | theta) =
  arg max_(theta in Theta) P(x_1, dots, x_N | theta) =
  arg max_(theta in Theta) product_(i=1)^N P(x_i | theta)
$

from a family of parametrized distributions $P(x | theta)$. This can be seen as
an optimization problem that considers the *likelihood function*

$ cal(L) (theta | x) = P(x | theta) $

that of course can be addressed like any optimization problem by

$ (partial cal(L) (theta | x)) / (partial theta) = 0 $

For the MAP the reasoning is analogue but the function $cal(L)$ to optimize will
be different.

Another useful trick is to use logarithms' properties in order to make products
become sums, reducing the derivative complexity and also definining the
*log-likelihood*.

= Biased Coin

Let's consider a coin toss repeated multiple times; the outcome can be modelled
as a random variable $C$ that of course is Bernoulli distribution. Now by
looking at the data we want to know what are the probabilities

$ P(C = "head") = theta quad P(C = "tail") = 1 - theta $

The ML approach finds the $theta$ that is more likely to have generated the
observed distribution. As said, the underlying family distribution is a
Bernoulli and so we can say that

$ P(d | theta) = theta^(n_H) (1 - theta)^(n_T) $

that is our *likelihood* function $cal(L)$ to optimize, but of course we can
optimize the log-likelihood version:

$ cal(L) (theta | d) = n_H theta + n_T (1 - theta) $

which derivative is

$ (partial cal(L)) / (partial theta) = n_H / theta - n_T / (1 - theta) $

if we now pose the derivative to zero we can find the optimial $theta$

$
  n_H / theta - n_T / (1 - theta) = 0 \
  n_H / theta = n_T / (1 - theta) \
  theta = n_H / (n_H + n_T)
$

that basically is the simplest probability rule (sign that this thing has some
sense).

The MAP version of this problem can be solved in the exact same way by
considering also the *prior* in order to maximize the *posterior*

$ P(theta | d) = P(d | theta) P(theta) $

Of course we don't know the posterior distribution but the standard way of
proceeding is to choose the *conjugate prior* w.r.t. the likelihood
distribution, because in this way the posterior will have the same distribution
of the prior.

For a Bernoulli distribution the conjugate distribution is Beta and so we can
write

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

$ theta = (n_H + alpha - 1) / (n_H + alpha - 1 + n_T + beta - 1) $

similary to the previous case.

= Naive Bayes

One of the simplest probabilistic models is the *Naive Bayes* that is based on a
*strong independence assumption*: every _effect_ is independent from each other
given the _cause_.

#figure(
  image("images/naive_bayes.png", width: 20%),
  caption: [ Naive Bayes ],
) <fig-naive-bayes>

This model is typically involved in classification tasks in which features are
considered effects and the target class is considered the cause. Each input
sample is defined as a set of attributes:

$ x = chevron.l a_1, dots, a_L chevron.r $

and we have a *target classification function*

$ f : X --> C $

where $X$ is the feature space and $C$ is the class label space. The model wants
to know the probability of each possible class, given an input pattern

$
  P(c_j | a_1, dots, a_L) =
  frac(P(a_1, dots, a_L | c_j) dot P(c_j), P(a_1, dots, a_L))
$

that under the Naive Bayes assumptions becomes

$
  P(c_j | a_1, dots, a_L) =
  frac(P(c_j) dot product_(i=1)^L P(a_i | c_j), P(a_1, dots, a_L))
$

or in more compact and _proportional_ form

$ P(c_j | a_1, dots, a_L) prop P(c_j) dot product_(i=1)^L P(a_i | c_j) $

where the right term is the joint probability of the training data

$ P(c_j) dot product_(i=1)^L P(a_i | c_j) = P(a_1, dots, a_L, c_j) $

Even though we can know the joint distribution family we have to learn its
parameters $theta$ in order to make inference, and so we have to solve the
*parameters estimation problem*:

$ P(theta | c_j, a_1, dots, a_L) prop P(c_j, a_1, dots, a_L | theta) P(theta) $

with one of the three framework for learning.

If we consider a classification problem where both features and targets are
categorical, we can use a multinomial distribution for the likelihood, that
considering $K$ the set of classes and $S_l$ the set of possible values for the
$l$-th feature, results in

$
  P(d | theta) = product_(k = 1)^K theta_k^(n_k) dot
  product_(l=1)^L product_(s=1)^(S_l) theta_(l s)^n_(l s)
$

where $n_k$ is the number of samples classified as $k$ and $n_(l s)$ is the
number of samples whose $l$-th feature has value $s$.

A useful thing to do (expecially for implementation purposes) is to rewrite the
formula using *indicator variables*.
