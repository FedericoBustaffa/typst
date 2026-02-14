= Bias Variance
<bias-variance>
When we train a model on a given dataset, even though the model is able
to generalize well, its final free parameters will be dependent on the
training set. In other words, if we train the model on a different
dataset, its free parameters will be different.

In this sense a specific training set is one possible realization from
the universe of data.

Usually the aim is to train the model in a way that it will not be
sensible to change of dataset (or at least not much), while keeping a
good generalization capability. Of course there will be always a
difference in a model trained on different datasets.

Depending on the training error, the test error and the difference
between models trained on different datasets it is possible (at least in
theory) to measure how much our model is sensible to data. This also let
us understand if the model error is due to overfitting, underfitting or
noise in the data.

In order to understand what is the cause it’s necessary to compute the
so called #strong[bias-variance decomposition] of expected error at a
point $x$:

- #strong[Bias];: quantify the discrepancy between the true function and
  $h$
- #strong[Variance];: quantify the variability of the response of model
  $h$ for different realizations of the training data.
- #strong[Noise];: irriducible error due to random factors.

In general we have an high bias when our model is too simple and cannot
approximate accurately enough the real function. We have instead an high
variance if the model trained on different datasets always find much
different $h$; and so $h_1 (x)$ will be much different from $h_2 (x)$.

== Decomposition
<decomposition>
Let’s for example take a linear model involved in a regression task and
suppose to have a training set composed by examples
$angle.l x , y angle.r$ where the true function is

$ y = f (x) + epsilon.alt $

where $epsilon.alt$ is a Gaussian noise with zero mean and standard
deviation $sigma$ and the error is the classic MSE.

Let’s now suppose that every training set is built from the same
probability distribution $P$ and so we want to train the same model on
#emph[all] the possible realizations of the training set. Theoretically,
this can give us the #strong[expected prediction error] on a given point
$x$.

$ E_P [(y - h (x))^2] $

that is basically the mean of all the errors produced by all the
different trained models. Now we can decompose this expectation in
#emph[bias];, #emph[variance] and #emph[noise] in order to measure them.

In order to do that let’s recall that, given a random variable $Z$, with
possible values $z_i$ for $i = 1 , dots.h , l$ and a probability
distribution $P (Z)$

- The #strong[expected value] or #strong[mean] of $Z$ is
  $ overline(Z) = E_P [Z] = sum i = 1^l z_i dot.op P (z_i) $
- The #strong[variance] of $Z$ is
  $ upright("Var[Z]") = E [(Z - overline(Z))^2] = E [Z^2] - overline(Z)^2 $

So now is possible to decompose the expected value formula like follows

$ E_P [(y - h (x))^2] & = E_P [h (x)^2 - 2 y h (x) + y^2]\
 & = E_P [h (x)^2] + E_P [y^2] - 2 E_P [y] E_P [h (x)] $

Let now $overline(h) (x)$ be the mean prediction of all the hypothesis
on the $x$ value. We also have that, for definition of variance that

$ E_P [h (x)^2] = E_P [(h (x) - overline(h) (x))^2] + overline(h) (x)^2 $

For $E_P [y]$ we can notice that

$ E_P [y] = E_P [f (x) + epsilon.alt] = f (x) $

for the second term we can apply again the definition of variance:

$ E_P [y^2] = E_P [(y - f (x))^2] + f (x)^2 $

We can now put everything together

$ E_P [(y - h (x))^2] & = & E_P [(h (x) - overline(h) (x))^2] + overline(h) (x)^2 & \
 &  & - 2 f (x) overline(h) (x) & \
 &  & + f (x)^2 + E_P [(y - f (x))^2] & \
 & = & E_P [h (x) - overline(h) (x)^2] + & upright(" (variance)")\
 &  & (overline(h) (x) - f (x))^2 + & upright(" (bias)")^2\
 &  & E_P [(y - f (x))^2] & upright(" (noise)")^2\
 $

and so is possible to rewrite the formulation of the expetcted error on
a given data point as

$ E_P [(y - h (x))^2] & = upright("Var") [h (x)] + upright("Bias") [h (x)]^2 + E_P [epsilon.alt^2]\
 & = upright("Var") [h (x)] + upright("Bias") [h (x)]^2 + sigma^2 $

So now it’s possible to see which of the three is a major component of
error on a given $x$ point.

#horizontalrule

In practice is not possible to have all the possible realizations of a
given distribution, but is possible to train the model on a finite (yet
statistically relevant) number different datasets, in order to have an
empirical expected error.

== References
<references>
- \[\[machine\_learning\]\]
- \[\[statistical\_learning\_theory\]\]
- \[\[validation\]\]
