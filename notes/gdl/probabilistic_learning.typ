#import "@local/note_template:0.1.0": *
#show: doc => note_template([Probabilistic Learning], doc)

#title()

Probabilistic models are carried by the *probabilistic learning* framework, that
basically solves the _inference_ problem of finding the right parameters of a
distribution, given the data and, if possible, some prior knowledge.

In general, *inference* is a process where, given some _evidence_ (data in our
case), we want to answer a _query_ on how probable is a fact. To answer there
are three main ways: *bayesian*, *maximum a-posteriori* and *maximum
likelihood*, all exploiting in a way or another the Bayes rule:

$
  P("cause" | "evidence") = (P("evidence" | "cause") dot P("cause")) / P("evidence") \
  P("cause" | "evidence") prop P("evidence" | "cause") dot P("cause")
$

or in another formulation

$ "Posterior" prop "Likelihood" dot "Prior" $

In the case of machine learning we want to _learn_ distribution parameters, and
this translate to the inference problem:

$ P(theta | cal(D)) = (P(cal(D) | theta) dot P(theta)) / P(cal(D)) $

where $theta$ are the set of parameters of the distributions involved and
$cal(D)$ is the set of data and where

- $P(theta | cal(D))$: probability of $theta$ being the parameters of the generating
  distribution of data $d$.
- $P(cal(D) | theta)$: how probable is to seed the data $cal(D)$, given that
  $theta$ are the parameters of the generating distribution.
- $P(theta)$: the prior probability of parameters $theta$ (encode beliefs or
  experts knowledge).
- $P(cal(D))$ the marginal probability of data (the empirical distribution).

The *bayesian learning* does not really find the best parameters, but compute a
weighted average over all possible $theta$ and returns the most probable answer
to the given query

$ P(X | cal(D)) = integral_theta P(X | theta) dot P(theta | cal(D)) d theta $

this is the most accurate but with clear tractability issues due to the fact
that integrals could not be computable in closed form and numerical solutions
can be very expensive.

But looking at the Bayes rule formula is clear that we can maximize the
posterior probability by manipulating the numerator of the right side. To do
that we can

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
