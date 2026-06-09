#import "@local/note_template:0.1.0": *
#show: doc => note_template([Probabilistic Models], doc)

#title()

In contrast with _discriminative models_ like neural networks or SVMs, a
relevant field of machine learning is occupied by *probabilistic models*, which
instead of learning functions (regressors) or trying to separate data
(classifiers), they directly try to model the data distribution that is most
likely to have generated the data.

They are mostly based on *probability theory* (frequentist or bayesian view) and
use *inference* as core mechanism to learn and make predictions. So its all
about finding a way to update a _posterior belief_ in order to make predictions.

The key idea behind probabilistic models is that we want to reconstruct the
generative process that have generated the data, that is typically something
more complex than sample from a points from some distribution. This is because
natural data is not i.i.d. and there is usually some structure and relations
between data we need capture.

This is particularly powerful compared to discriminative models because

- *Generative*: since the model is built to represent the generative process of
  data, once trained, is possible to sample from the obtained conditional
  distribution and get a meaningful sample.
- *Uncertainty*: Probabilistic models come with _builtin uncertainty_; we can in
  fact ask for how probable (or how likely) is a fact given some evidence (now
  the answer is a valid probability).

#note[
  Of course a probabilistic model can be used as a discriminative one by asking
  the most probable fact given some evidence.
]

But of course in quality of machine learning models they need to be trained and
be able to perform predictions. Since we are in a probabilistic setting, both
are addressed by solving an inference problem:

- *Learning*: find the most probable hypothesis $theta$ that better describe the
  generative process of data:
  $ P(theta | cal(D)) = frac(P(cal(D) | theta) dot P(theta), P(cal(D))) $
- *Prediction*: given some evidence, get in return a value, a label or whatever
  is meaningful for the task:
  $ P(y | x) = frac(P(x | y) P(y), P(x)) $

To make all of this less abstract we also need to model the *joint probability
distribution* in such a way that is useful to make predictions. As said in fact
we want to update our _belief_ over some fact, given data and this is crucial to
define how the learning is done and since most models are bayesian networks, or
Markov random fields, they come with useful conditional independence assumptions
to ease the computation.

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

In general, a probabilistic model is bayesian network that defines relations
between random variables, and adds assumptions in order to simplify the *joint
probability distribution*

$ P(X_1, dots, X_n | theta) $

from which we obtain the posterior needed to perform inference.

== Conjugate Priors

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

The first and most simple case of probabilistic model we can think of is the one
that want to learn distribution parameters of random variables for which we have
*fully observable data*.

Once defined the generative process, we want to define the joint probability of
the model, factorize the joint probability distribution with the chain rule and
apply the conditional independence assumptions:

$ P(X, Y) = P(Y) dot P(X | Y) = P(Y) dot product_(i=1) P(x_i | Y) $

from which we obtain the likelihood for the paremeter learning inference
problem.

#note[
  In the formula above we assume that all the $x_i$ are conditionally
  independent given $Y$ but it's not true in general, it depends on the model.
]

Once we have the joint we can define the posterior on the data in order to make
predictions:

$
  P(Y | X) = P(X, Y) / P(X) = (P(Y) dot P(X | Y)) / P(X)
  = (P(Y) dot product_(i=1) P(x_i | Y)) / P(X)
$

This is a different posterior than the one considered for the learning process
$P(theta | X)$, but we will see that in other contexts it will be useful also
for training other types of models.

== Latent Variables

The other and most common case is the one where some variable is completely not
observed (*latent*). And this typically brings computational issues due to the
fact that if we know that there is latent variable that is necessary to model
data but we don't have access to any observation of it, we need to marginalize
it and consider all of its possible values.

The process is more or less the same but since we cannot compute some
probabilities we typically start from a random guess for the parameters, and
through an iterative process (*EM algorithm*) we converge to the solution that
most likely have generated the data. Depending on the distributions we are
dealing with the process could still be intractable and so we rely on
approximations like *variational inference* or *sampling*.

This approach is typical of clustering or quantization algorithms in which
typically we miss the target values, we only have unlabeled observations and we
want to find recurrent meaningful structures.
