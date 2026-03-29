#import "@local/note_template:0.1.0": *
#show: doc => note_template([Probabilistic Learning], doc)

#title()

Probabilistic models are carried by the *probabilistic learning* framework, that
basically solves the _inference_ problem of finding the right parameters of a
distribution, given the data and, if possible, some prior knowledge.

In general, *inference* is a process where, given some _evidence_ (data in our
case), we want to answer a _query_ on how probable is a fact, exploiting the
Bayes rule:

$
  P("cause" | "evidence") = (P("evidence" | "cause") dot P("cause")) / P("evidence") \
  P("cause" | "evidence") prop P("evidence" | "cause") dot P("cause")
$

or in another formulation

$ "Posterior" prop "Likelihood" dot "Prior" $

The marginal probability of the evidence is often omitted because we are not
interested in valid and normalized probability but just a _score_.

In the case of machine learning we want to _learn_ distribution parameters, and
this translate to the inference problem:

$ P(theta | cal(D)) = (P(cal(D) | theta) dot P(theta)) / P(cal(D)) $

where $theta$ are the set of parameters of the distributions involved and
$cal(D)$ is the set of data and where

- *Posterior* $P(theta | cal(D))$: probability of $theta$ being the true set of
  parameters that have generated $cal(D)$.
- *Likelihood* $P(cal(D) | theta)$: if $theta$ is the true set of parameters,
  how likely is to see $cal(D)$.
- *Prior* $P(theta)$: probability of parameters $theta$ (encode beliefs or
  experts knowledge).

Now, supposing we have a trained model and a fact $X$ on the world we are
modelling, we want to ask our model how probable is the fact $X$, or out of
multiple possible choices, we want to know which is the most probable.

But of course we have to first train the model and we have three possible ways
of doing it:

- *Bayesian*: the bayesian learning doesn't really find the best parameters
  $theta$, it makes a weighted average of all of them and returns the most
  probable answer:
  $ P(X | cal(D)) = integral_theta P(X | theta) dot P(theta | cal(D)) d theta $
  but it has clear tractability issues due to the integral and the fact that the
  posterior could be intractable.
- *Maximize the likelihood (ML)*: in case we don't have prior knowledge we can
  consider every prior $P(theta)$ equiprobable and so by finding $theta$ the
  maximizes the likelihood
  $ arg max_theta P(cal(D) | theta) $
  we can increase the posterior probability.
- *Maximize the posterior (MAP)*: in case we have prior knowledge we can
  maximize the whole numerator
  $ arg max_theta P(cal(D) | theta) dot P(theta) $
  This also adds a *regularization effect* because, in low density of data
  scenarios, the prior drives the learning process to not overfit the few samples
  we have.

Once we have $theta$ we have the parameters of distributions that most likely
model our data and so it's possible to answer queries by just plug the sample
$X$ in the probability or density function found and seed how probable is.

Similarly to classical discriminative models, where we have to guess the family
of the function we are trying to fit, in probabilistic learning we have to
assign to each feature a distribution, _aligned_ to its domain.

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
