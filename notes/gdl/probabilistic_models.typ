#import "@local/note_template:0.1.0": *
#show: doc => note_template([Probabilistic Models], doc)

#title()

In contrast with _discriminative models_ like neural networks or SVMs, a
relevant field of machine learning is occupied by *probabilistic models*, which
instead of learning functions (regressors) or trying to separate data
(classifiers), they directly try to model the distribution that have generate
the data.

They are based on the *Bayesian theory of probability* and use *inference* as
core mechanism to learn and make predictions.

Modelling data distributions is particularly powerful if compared to pure
discriminative models because

- *Uncertainty*: discriminative models typically operate in a setting in which,
  given some evidence, they answer with the most probable fact (even if most of
  them do not model probabilities). Probabilistic models instead comes with
  _builtin uncertainty_. We can in fact ask how probable is a fact given some
  evidence (now the answer is a valid probability).
- *Generative*: some probabilistic models are _generative_ because, once
  trained, we can sample from the distribution they model, generating new
  synthetic data that is consistent with the observed (and if given with the prior
  knowledge injected)

#note[
  Of course a probabilistic model can be used as a discriminative one by asking
  the most probable fact given some evidence.
]

So of course these are machine learning models and so they need to have the two
core functionalities of any machine learning model: _training_ and _prediction_.
Since we are in bayesian probability setting, both are addressed by solving an
inference problem:

- *Prediction*: as for discriminative models we want to give evidences and get
  in return a value, a label or whatever is meaningful for the task. So
  typically the prediction of these models is addressed by

  $ P(y | x) = frac(P(x | y) dot P(y), P(x)) $

  where $x$ is the observed data we gave to the model and $y$ is the most
  probable answer given the observation $x$.
- *Learning*: also the learning process is defined as a specific inference
  problem and since we want to learn parameters $theta$ of a distribution, this
  is formalized by

  $ P(theta | X) = frac(P(X | theta) dot P(theta), P(X)) $

  where $X$ is a set of observations.

= Learning

The *probabilistic learning* framework carries all the probabilistic models and
even if there are many ways of implement it, there are three main approaches
that given a set of observations $X$ and the model structure can be used to
learn.

- *Bayesian Learning*: it considers all the possible hypotheses and performs a
  weighted average over them, returning the most probable answer for the query
  $Y$:

  $ P(Y | X) = integral_theta P(Y | theta) dot P(theta | X) d theta $

  but it has clear tractability issues due to the integral computation.
- *Maximum Likelihood (ML)*: in case we don't have prior knowledge we can
  consider uniform priors and focus on find $theta$ that maximizes the
  likelihood of data:

  $ arg max_theta P(X | theta) $

  In this way is possible to increase the overall posterior probability of the
  inference problem of learning, by optimizing just one term.
- *Maximum a-Posteriori (MAP)*: in case we have prior knowledge we can maximize
  the whole numerator of the inference problem:

  $ arg max_theta P(X | theta) dot P(theta) $

  This also adds a *regularization* effect because, in low density of data
  scenarios, the prior drives the learning process to not overfit the few samples
  we have.

While the bayesian learning is a _special_ case, ML and MAP are like point-wise
estimations of bayesian learning, since they provide the post probable
hypothesis (according to the posterior computation).

Also, given a distribution, its parameters are modelled by its *conjugate prior*
distribution, that is very useful for the MAP framework. The resulting
distribution of the multiplication of a distribution by its conjugate prior has
again the form of the conjugate prior (with a combination of their parameters).
This means that we can compute the posterior in close form because the resulting
distribution of likelihood by the prior is still a valid and known distribution.

#align(center)[
  #table(
    columns: 3,
    inset: (y: 7.3pt),
    align: center,
    [*Domain*], [*Data Distribution*], [*Conjugate Prior Distribution*],
    [Bernoulli], [$x in {0, 1}$], [Beta],
    [Multinomial], [$x in {1, dots, K}$], [Dirichlet],
    [Univariate Gaussian], [$x in RR$], [Normal Inverse Gamma],
    [Multivariate Gaussian], [$x in RR^k$], [Normal Inverse Wishart],
  )
]

So depending on data nature we can use one of these distributions and their
conjugate priors to optimize the posterior in closed form.


== Fully Observable Variables

The first case of probabilistic model we can think of is the one that want to
learn distribution parameters of random variables for which we have *complete
observable data*.

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

== Latent Variables

The other and most common case is the one where some variable is completely not
observed (*latent*). And this typically brings computational issues due to the
fact that if we know that there is latent variable that is necessary to model
data but we don't have access to any observation of it, we need to marginalize
it and consider all of its possible values.

= Inference

In general, *inference* is a process where, given some _evidence_ (data in our
case), we want to answer a _query_ on how probable is a fact (or what is the
most probable answer), exploiting the Bayes rule:

$
  P("cause" | "evidence")
  = (P("evidence" | "cause") dot P("cause")) / P("evidence") \
  P("cause" | "evidence") prop P("evidence" | "cause") dot P("cause")
$

or in another formulation

$ "Posterior" prop "Likelihood" dot "Prior" $

The marginal probability of the evidence is often omitted because we are not
interested in valid and normalized probability but just a _score_.

= Generative Process

In general, for every probabilistic model we also have to consider its
*generative process*, given by the posterior. In other words we ask the model,
given the parameters $theta$, how it would generate $X$. The generative process
tells a lot on the flexibility of the model and it's crucial to determine the
right learning algorithm.
