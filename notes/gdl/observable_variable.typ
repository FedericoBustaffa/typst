#import "@local/note_template:0.1.0": *
#show: doc => note_template([Learning with Fully Observable Variables], doc)

#title()

The most simple case of probabilistic inference is when the bayesian network is
already defined and all the variables are *observable*. In general there is an
hypothesis $h_theta$ that better explains the data, and so is more suitable to
answer a query.

// Depending on the inference method we are using, the problem to solve is
// different:
//
// - *Bayesian learning*: we can directly answer the query by computing the
//   probability of it over all the possible explainations (hypothesis $h_theta$)
//
//   $ P(X | theta) = integral_theta P(X | h_theta) P(h_theta | d) d theta $
//
//   In this scenario every the answer is weighted over all possible realizations
//   of $h_theta$; the most likely will weight more because it better explains data
//   but the others will _smooth_ the result.
// - *Maximum Likelihood (ML)*: in this case we have to find first the parameter $theta$
//   the most likely explains the data, in order to update the posterior (the
//   second term of the integral above). In order to do that we can maximize the
//   *likelihood* given by the Bayes rule:
//
//   $ P(h_theta | d) = (P(d | h_theta) P(h_theta)) / P(d) $
//
//   This can be a good choice if any prior is equally probable, but is completely
//   *data-driven* and can be prione to over-fitting.
// - *Maximum a Priori (MAP)*: this is like maximum likelihood but introduce a
//   preference accross all the possible hypothesis. So it tries to maximize both
//   term at the numerator of the Bayes rule. Moreover it adds a regularization
//   effect, particularly useful in low data density situations.
//
// The concept of ML and MAP are similar and are usually faced in the same way. For
// the ML we want to find $theta$ that is more likely to have generated the data,
// assuming $d$ is independently and identically distributed.
//
// $
//   theta = arg max_(theta in Theta) P(d | theta) =
//   arg max_(theta in Theta) P(x_1, dots, x_N | theta) =
//   arg max_(theta in Theta) product_(i=1)^N P(x_i | theta)
// $
//
// from a family of parametrized distributions $P(x | theta)$. This can be seen as
// an optimization problem that considers the *likelihood function*
//
// $ cal(L) (theta | x) = P(x | theta) $
//
// that of course can be addressed like any optimization problem by
//
// $ (partial cal(L) (theta | x)) / (partial theta) = 0 $
//
// For the MAP the reasoning is analogue but the function $cal(L)$ to optimize will
// be different.
//
// Another useful trick is to use logarithms' properties in order to make products
// become sums, reducing the derivative complexity and also definining the
// *log-likelihood*.

= Biased Coin

Let's consider a coin toss repeated multiple times; the outcome can be modelled
as a random variable $C$ that of course is a Bernoulli distribution of parameter
$theta$:

$ P(X = i) tilde cal(B)(theta) = theta^i dot (1 - theta)^(1-i) $

Now by looking at the data we want to know what are the probabilities

$ P(C = "Head") = theta quad P(C = "Tail") = 1 - theta $

The ML approach finds the $theta$ that is more likely to have generated the
observed distribution. As said, the underlying family distribution is a
Bernoulli and so we can say that

$ P(d | theta) = theta^(n_H) (1 - theta)^(n_T) $

where $n_H$ and $n_T$ are respectively the number of heads and tails observed.
That is our *likelihood* function $cal(L)$ to optimize, but of course we can
optimize the log-likelihood version:

$ cal(L) (theta | d) = n_H theta + n_T (1 - theta) $

which derivative is

$ (partial cal(L)) / (partial theta) = n_H / theta - n_T / (1 - theta) $

and it is zero when

$ quad theta = n_H / (n_H + n_T) $

that basically is the simplest probability rule (sign that what we are doing has
sense).

The MAP version of this problem can be solved in the exact same way by
considering also the *prior* in order to maximize the *posterior*

$ P(theta | d) = P(d | theta) P(theta) $

For a Bernoulli distribution the *conjugate distribution* is Beta and so we can
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

that under the Naive Bayes conditional independence assumptions becomes

$
  P(c_j | a_1, dots, a_L) =
  frac(P(c_j) dot product_(i=1)^L P(a_i | c_j), P(a_1, dots, a_L))
$

or in more compact and _proportional_ form

$ P(c_j | a_1, dots, a_L) prop P(c_j) dot product_(i=1)^L P(a_i | c_j) $

where the right term is the joint probability of the training data

$ P(c_j) dot product_(i=1)^L P(a_i | c_j) = P(a_1, dots, a_L, c_j) $

Now this is the classification function used for inference. The way in which we
can train this model is by learn the parameters $theta$ of the joint
distribution of the whole dataset.

$ P(theta | c_j, a_1, dots, a_L) prop P(c_j, a_1, dots, a_L | theta) P(theta) $

with one of the three framework for learning.

== Maximum Log-Likelihood Learning

Let's focus on maximum log-likelihood for simplicity and let's also consider the
case where both class labels and features are categorical.


Class labels can have $K$ values, while the $l$-th feature can pick values from
a set $S_l$ of values. So we basically have a bunch of multinomial distributions
that model the data, hence the likelihood will be

$
  P(X, C | theta) & = P(C | theta) dot P(X | C, theta) \
                  & P(C | theta) dot P(X_1, dots, X_L | C, theta)
$

But for the conditional independence assumption the model does, we can write

$ P(X, C | theta) = P(C | theta) dot product_(l = 1)^L P(X_l | C, theta) $

that for every sample becomes

$
  P(X, C | theta) = product_(i = 1)^N [ P(c_i | theta)
    product_(l=1)^L P(x_(i l) | c_i, theta) ]
$

Now the class labels distribution is a plain multinomial of parameter $pi$, with
$K$ possible values, and the features distributions are also multinomials, each
of parameter $phi.alt_l$, we can rewrite the joint distribution like follows

$
  P(X, C | theta) = product_(k=1)^K pi_k^(N_k) dot
  product_(k=1)^K product_(l=1)^L product_(s=1)^S_l phi.alt_(k l s)^(N_(k l s))
$

where $N_k$ is the number of samples with class $k$ and $N_(k l s)$ is the
number of samples with classified as $k$ with value $s$ for the $l$-th feature.

A useful way of reformulating the problem is by the introduction of *indicator
variables*, defined as

$
  z_(i k) = cases(1 "if" c_i = k, 0 "otherwise") quad quad
  t_(i l s) = cases(1 "if" x_(i l) = s, 0 "otherwise")
$

In this way is possible to model the *likelihood* distribution as follow

$
  cal(L) (theta) & =
  product_(i=1)^N product_(k=1)^K P(c_i = k)^(z_(i k)) (product_(l=1)^L
    product_(s=1)^S_l (P(x_(i l) = s | c_i = k))^(t_(i l s)))^(z_(i k)) \
  & = product_(i=1)^N product_(k=1)^K pi_k^(z_(i k))
  (product_(l=1)^L product_(s=1)^S_l phi.alt_(k l s)^(t_(i l
    s)))^(z_(i k)) \
$

Now we can go in log-space and define the *log-likelihood* as follows

$
  log cal(L)(theta) & =
                      log(
                        product_(i=1)^N product_(k=1)^K pi_k^(z_(i k))
                        (product_(l=1)^L product_(s=1)^S_l
                          phi.alt_(l s)^(t_(i l s)))^(z_(i k))
                      ) \
                    & = sum_(i=1)^N sum_(k=1)^K z_(i k) log pi_k +
                      sum_(i=1)^N sum_(k=1)^K z_(i k)
                      (sum_(l=1)^L sum_(s=1)^S_l
                        t_(i l s) log phi.alt_(k l s))
$

So now is possible to optimize it by computing its derivative and set it to zero

$ (partial cal(L)) / (partial theta) = 0 $

we will obtain the update formula for $pi_k$ and $phi.alt_(k l s)$ that will
result in

$ pi_k = N_k / N quad quad phi.alt_(k l s) = N_(k l s) / N_k $

that now we can use to learn the data distribution.

== Sparse Data and Zero-Frequency

Can happen that a feature with value $s$ is never observed with class $k$ and so
$N_(k l s) = 0$ and the resulting probability will go to zero

$ P(x_l = s | c = k) = 0 $

because in this cases the Naive Bayes model confuses _unobserved_ with
_impossible_.

A classical remedy is to add *pseudo-counts* through a Dirichlet prior,
performing MAP learning.

