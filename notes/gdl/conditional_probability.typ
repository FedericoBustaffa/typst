#import "@local/note_template:0.1.0": *
#show: doc => note_template([Conditional Probability], doc)

#title()

In probabilistic models there is a large use of *probability* and *conditional
probability*. The main concepts that these models exploit are

- Random Variables (distributions)
- Probability functions
- Joint probability
- Conditional probability
- Chain rule of probability (product rule)
- Bayes rule
- Independence
- Conditional independence
- Expectation

With these concepts we can define and train models like

- Naive bayes
- Bayesian networks
- Causal bayesian networks
- Structural causal models
- Hidden markov models

These are the model at the base of probabilistic reasoning and generative
learning.

= Random Variables

A *random variable* is a function that describes the outcome of a random process
by assigning unique values to all possible outcomes of the experiment.

Typically in ML context every RV models an aspect (feature) of the data, for
example age, height or weight.

All possible outcomes live in the so called *sample space* $Omega$, and the RV
maps every outcome to a *state* in the so called *measurable space* $cal(S)$.
The number of possible occurences of certain state divided by the number of
possible outcomes gives us the *probability* of an event to happens.

#figure(
  image("images/probability_spaces.png", width: 70%),
  caption: [ Probability Spaces ],
)

For *discrete RVs* we have a finite list of countable values, while for
*continuous RVs* we have infinitly many values.

== Probability Functions

As stated before, random variables are functions, in particular *probability
functions* that describe the probability of a certain outcome.

For discrete RVs we have a *probability function* $P(X = x) in [0, 1]$ measuring
the probability of the variable $X$ to be assigned with value $x$. For those the
*sum rule* is defined as

$ sum_(x in Omega) P(X = x) = 1 $

For continuous RVs instead we have a *density function* $p(t)$ that is the
*relative likelihood* of an RV to take the value $t$. In this case the sum rule
is defined as

$ integral_Omega^t p(t) d t = 1 $

The density function computed in $t$ could not have a value in $[0, 1]$, in fact
to compute $P(X = x)$ we have to compute the integral of the density function
from $-infinity$ to the desired value:

$ P(X <= x) = integral_(- infinity)^x p(t) d t $

Of course is not possible to compute the probability of obtaining exactly $x$
because, for continuous variables, we have infinitely many possible outcomes and
so the result would be always $0$.

= Joint and Conditional Probability

The *joint probability* of two variables is defined as follows:

$ P(x_1 and x_2) = P(x_1 | x_2) dot P(x_2) $

that of course means that the *conditional probability* of $x_1$ given $x_2$ is
defined as

$ P(x_1 | x_2) = P(x_1 and x_2) / P(x_2) $

For discrete random processes described by a *set of variables* ${ X_1, dots,
  X_N }$ the *joint probability* is defined as

$ P(X_1 = x_1, dots, X_N = x_n) = P(x_1 and dots.c and x_n) $

while the *conditional probability* of $x_1, dots, x_n$ given $y$

$ P(x_1, dots, x_n | y) $

measures the effect of the realization of an event $y$ on the occurrence of
$x_1, dots, x_n$.

#figure(
  grid(
    rows: 2,
    gutter: 0.2cm,
    image("images/conditional_discrete.png", width: 100%),
    image("images/conditional_continuous.png", width: 100%),
  ),
  caption: [ Discrete and Continuous Conditional Distributions ],
)

In order to compute conditional probability when many variables are involved we
can use the *chain rule*, defined for the standard case:

$ P(x_1, dots, x_n) = product_(i=1)^N P(x_i | x_1, dots, x_(i-1)) $

and for the _conditional_ case:

$ P(x_1, dots, x_n | y) = product_(i=1)^N P(x_i | x_1, dots, x_(i-1), y) $

when instead we are interested in computing the probability of certain outcome
we can use the *marginalization*:

$
  P(X = x) & = sum_y P(X = x | Y = y) P(Y = y) \
           & = sum_i P(X = x, Y = y)
$

that basically sum up all the conditional probabilities between $X_1 = x_1$ and
every other variable's possible values probabilities.

== Bayes Rule

One of the most useful rules is the *Bayes rule*, which let us _invert_ the
conditional probability and this will be useful to update our belief on the
world. For example, given an _hypothesis function_ $h_i in H$ and a set of
observations $d$, it holds

$
  P(h_i | d) = (P(d | h_i) P(h_i)) / P(d) =
  (P(d | h_i) P(h_i)) / (sum_j P(d | h_j) P(h_j))
$

where

- $P(h_i)$ is the *prior* probability of $h_i$ being the true function.
- $P(d | h_i)$ measures the *likelihood* of observing $d$ if $h_i$ were really
  the true function.
- $P(d)$ is just the empirical data distribution.
- $P(h_i | d)$ is the *posterior* probability of $h_i$ being the true function,
  observing the data $d$.

The _posterior_ is what a probabilistic model computes in order to update its
prior on $h_i$.

= Independence

While the _Bayes rule_ is central in order to train the model and update our
belief on the world or data, the *independence* among random variables is a tool
to simplify the computation, in some cases paying a drop in accuracy.

This is because what is typically done is to assume independence where maybe
there is some sort of dependency. In general, exploiting independence let us
reduce the amount of operations that can easily explode.

In general two RVs $X$ and $Y$ are *independent* if knowledge about $X$ does not
change the uncertainty about $Y$ and viceversa:

$
  I (X, Y) <==> P(X, Y) & = P(X | Y) P(Y) \
                        & = P(Y | X) P(X) = P(X) P(Y)
$

The _shorthand_ notation typically is $X perp Y$ for $I(X, Y)$.

Two RVs are instead *conditionally independent* given $Z$ if the realization of
$X$ and $Y$ is an independent event of their conditional probability
distribution given $Z$:

$
  I(X, Y | Z) <==> P(X, Y | Z) & = P(X | Y, Z) P(Y | Z) \
                               & = P(Y | X, Z) P(X | Z) = P(X | Z) P(Y | Z)
$

with the _shorthand_ notation $X, Y perp Z$ for $I(X, Y | Z)$.

= Expectation

The last main concept is *expectation* that is basically the mean or expected
value we should obtain by sampling multiple times from the distribution.

For discrete RV $X$ with $n$ possible realizations:

$ bb(E)_(x tilde p (X)) [f(x)] = sum_(i=0)^n p(x_i) f(x_i) $

If $n$ is finite, the expectation can be computed in *closed form*.

For a continuous RV $X$ instead we have

$ bb(E)_(x tilde p(X)) [f(x)] = integral p(x) f(x) d x $

and in this case, if an _analytical_ solution does not exist, we need numerical
approximations.

In the *multivariate* case we have

$
  bb(E)_(x, y tilde p(X, Y)) [f(x, y)] = integral integral p(x, y) f(x) d x d y
$

Let's also list some valid properties of the expectation

$
  bb(E)_x [k] & = k \
  bb(E)_x [k dot f(x)] & = k bb(E)_x [f(x)] \
  bb(E)_x [f(x) + g(x)] & = bb(E)_x [f(x)] + bb(E)_x [g(x)] \
  bb(E)_(x, y) [f(x) dot g(x)] &
  = bb(E)_x [f(x)] dot bb(E)_y [g(y)] " if " x perp y \
$

because it is a *linear operator*.
