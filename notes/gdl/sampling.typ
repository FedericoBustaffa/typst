#import "@local/note_template:0.1.0": *
#show: doc => note_template([Sampling], doc)

#title()

One way to approximate exact distribution computations is *sampling*, which lets
us generate meaningful _realizations_.

This is useful because with probabilistic models we often deal with expectations
and posterior computations, which can involve sums or integrals over large state
space. Instead by sampling we can approximate the exact computation of something
like

$ EE_p [f(X)] $

with the empirical mean over samples drawn from $p(x)$.

In practice sampling procedure generates a finite set of realizations

$ cal(X) = {x^((1)), dots, x^((L))} $

with $x^((l)) tilde p(x)$ that are realizations of the random variable $X$. If
for example with are dealing with a multinomial distribution that models dice
tosses, we have something like

$ p(X = i) = 1 / 6 $

for which the expectation would be a sum of this form

$ EE_p [f(X)] = sum_(i=1)^6 i dot 1 / 6 = 3.5 $

In the same way is possible to obtain a approximate result by drawing enough
samples from the same multinomial distribution and running the empirical mean
over them:

#figure(
  image("images/dice_sampling.png", width: 60%),
  caption: [ Dice Sampling ],
)

that as we can see converges to expectation value after some drawings.

This is the basic of Monte Carlo approximation, which is very useful in all
those cases in which expectation computation is too expensive and when we don't
have closed form posteriors or conjugancy.

= Posterior Approximation

Since bayesian models, parameters are random variables and with latent variable
models we have to deal with posterior computation that can be intractable, we
can use sampling to approximate it. So if we have something like

$ p(theta, Z | cal(D)) $

that is intractable, we can draw samples

$
  (theta^((1)), z^((1))), dots, (theta^((L)), z^((L))) tilde p(theta, Z | cal(D))
$

and compute their mean. This also can be particulary useful also for prediction,
given a new observation $x^star$:

$
  p(z^star | x^star, cal(D)) = EE_p(theta | cal(D)) [p(z^star | x^star, theta)]
  approx 1 / L sum_(l=1)^L p(z^star | x^star, theta^((l)))
$

is a good approximation for the posterior for $L$ large enough.

= Sampler Quality

In order to measure the quality of a sampler we usually have to evaluate three
main aspects: empirical convergence, unbiasedness, low variance.

For the *empirical convergence* check we can consider a discrete variable, whose
empirical frequency of value $i$ is

$ 1 / L sum_(l=1)^L II[x^((l)) = i] $

where $II[dot]$ is the indicator function. The fundamental requirement of a good
sampler is that

$ lim_(L -> oo) 1 / L sum_(l=1)^L II[x^((l)) = i] = p(X = i) $

that in other words means that the empirical distribution should converge to the
target.

To check the *unbiasedness* we can say that a Monte Carlo estimator
$hat(f)_cal(X)$ is unbiased if

$ EE[hat(f)_cal(X)] = EE_p [f(X)] $

Meaning that samples are really distributed accordingly to $p(x)$, making their
mean unbiased as well.

The last fundamental property of a good sampler is *low variance*, because it
determines how much the estimate fluctuates from run to run.

= Multivariate Distribution Sampling
