#import "@local/note_template:0.1.0": *
#show: doc => note_template([Biased Coin], doc)

#title()

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

