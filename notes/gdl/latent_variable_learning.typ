#import "@local/note_template:0.1.0": *
#show: doc => note_template([Learning with Latent Variables], doc)

#title()

There are cases in which the model is built under the assumption that there are
*hidden (or latent) variables* that have contributed in some way to generate
data. The thing is that of course we don't have any observation about them, we
only know the possible values they can assume.

This brings computational issues since we have to marginalize latent variables,
that in the best case are discrete with few values (little sum) and in the worst
are continuous (big integral).

But let's see the general situation assuming $X$ being the observables and $Z$
being the latent. Independently of the model we want to model the joint
distribution $P(X, Z)$ but since $Z$ is latent we need to marginalize it out:

$
  P(x) & = sum_z P(x | Z = z) P(Z = z)          &   " for discrete" Z \
  P(x) & = integral_z P(x | Z = z) P(Z = z) d z & " for continuous" Z \
  P(x) & = EE_P(Z = z) [P(x | Z = z)]           &         " for both"
$

Which for the whole dataset results in the following joint distribution:

$ P(X) = product_(i=1)^N P(x_i) $

In general, once defined the joint we want to perform parameter learning with
one of the three methods, but let's focus only on maximum likelihood. The above
formulation actually defines the *incomplete likelihood* and since we want to
work in log-space we define the *incomplete log-likelihood* as follows:

$
  log P(X) & = sum_(i=1)^N log (sum_z P(x_i | Z = z) P(Z = z))
  & " for discrete" Z \
  log P(X) & = sum_(i=1)^N log (integral_z P(x_i | Z = z) P(Z = z) d z)
  & " for continuous" Z \
  log P(X) & = sum_(i=1)^N log (EE_P(Z = z) [P(x_i | Z = z)])
  & " for both"
$

but as we can see we end up having this akward form with a logarithm of a sum
that is not particularly nice to optimize directly (yet is possible).

With all observations available we would have the *complete (log-)likelihood*
that instead factorizes nicely so the idea is to pretend to have observations
also for $Z$

$ P(X, Z) = P(Z | X) P(X) $

and find a way to optimize it instead of optimize the incomplete.

= Expectation Maximization

The main problem with the complete likelihood is that of course we don't have
any observation about the latents so we cannot optimize it directly.

The *expectation maximization* algorithm is an _iterative_ approach that aims to
overcome this issue. The idea is that since we don't have any observations of
the latents, we can randomly initialize the parameters, in order to make
inference with the posterior and compute the likelihood w.r.t. the randomly
guessed parameters.

The idea is to use the posterior we would use to make predictions in the end

$ P(Z | X, theta^((k))) $

and compute the so called *responsabilities*. In practice we want to know how
probable is each value of the latent w.r.t. the sample $x_i$ realization
(considering the current $theta^((k))$).

#note[
  Responsabilities are computed as function of *fixed distribution parameters*
  $theta^((k))$, not the distribution parameters $theta$ we are trying to
  optimize. This makes responsabilities fixed values that must be treated as
  such when we take the derivative of the $Q$ function.
]

This must be reconnected with the complete log-likelihood in order to perform some
optimization and this can be done by the following function:

$
  Q(theta | theta^((k))) = EE_P(Z | X, theta^((k))) [log P(X, Z | theta)]
$

that puts together two concepts:

- The probability that the $i$-th sample is generated given that $Z = z$ for
  each possible value $z$ of $Z$.
- The likelihood of the situation given the current parameters $theta^((k))$.

The algorithm performs in facts two steps at each iteration:

+ *E-step*: posterior computation in order to get responsabilities by
  exploitation of the Bayes rule:
  $ P(Z | X, theta^((k))) = frac(P(X | Z) P(Z), P(X)) $
  that of course can be bringed in log-space as well and if we notice the
  incomplete likelihood appears again, but this time is only computed and not
  optimized.
+ *M-step*: maximization of $Q$ since we want to maximize the probability that
  current parameters explain data
  $ pdv(Q, theta^((k))) = 0 $
  from which we get the new parameters to use in the next iteration:
  $ theta^((k+1)) = arg max_theta Q(theta | theta^((k))) $

The iterative process updates $theta^((k))$ until some convergence criterion is
met.

