#import "note_template.typ": *
#show: note_template

#title("Statistical Learning Theory")

The #strong[statistical learning theory] (#strong[SLT];) provides the basics for
model complexity and risk analysis. It formalizes what a machine learning model
does in the learning phase with respect to the training set, its complexity and
the true distribution of data.

= Inductive Bias <inductive-bias>

When a model learn search through an #strong[hypothesis space] $H$ the best
hypothesis $h$ to fit the training data. The hypothesis space is defined by the
complexity of the model: the more the model is complex and flexible, the more
the hypothesis space is big.

#note(title: "Consistent Hypothesis")[
  An hypothesis $h$ is #strong[consistent] with the training set if, for each
  example $chevron.l x , y chevron.r$ in the training set it holds
  $ h (x) = y $
]

In order to define and search into $H$ we need a #strong[biased learner] (our
model) that must have an #strong[inductive bias];, that provides in a sense an
heuristic to shrink the space of possible models to something that can be
searched more efficiently. The two main types of inductive biases are

- #strong[Language bias];: that put constraints on the model. Just choosing a
  family of models can be a language bias, but for example in neural networks is
  not the case (universal approximation). Limiting the model flexibility is
  another language bias, for example by searching in the space of linear model
  regressor, only the linear regressors.
- #strong[Search bias];: put constraints on the learning algorithm. For example
  the regularization leads to models with lower weigths.

Typically we are interested in the second because the first basically defines
the hypothesis space $H$.

= True and Empirical Risk <true-and-empirical-risk>

If we would have access to the true function that models our data as a black-box
it should be possible to sample as many points as we want without noise even
without knowing the function. So it could be possible to build a perfect dataset
(possibly infinite) on which testing our model. The mean error of the model on
that dataset get the name of #strong[true risk] $R$, and that’s what machine
learning aims to minimize. The actual definition of $R$ is the mean risk on the
true data distribution:

$ R = integral L (y , h (x)) #h(0em) d P (x , y) $

The problem is that we of course don’t have the function neither in a black-box
form, neither its actual formula. The only thing we have are data coming from
measurements, that can (and most likely will be) noisy.

The error our model does on this dataset is called #strong[empirical risk]
$R_(upright("emp"))$ that can be used to evaluate the model, knowing that it is
an estimation of $R$ based only on the observed data.

So we can shift the problem into the fitting of this empirical data, trying to
capture the underlying behavior that is the true function. The aim is still to
minimize $R$ and, more important is not to minimize $R_(upright("emp"))$,
because minimizing it means fitting also the noise (over-fitting).

What misses is a nice and reliable relation between $R$ and $R_(upright("emp"))$
because, we can’t say anything about them. They could be the same because the
sampling is very accurate (no noise) or because the level of precision is low
enough. Or they can be different:

- If $R > R_(upright("emp"))$ it means that the model is in over-fitting and so
  it will not be able to generalize well.
- If $R < R_(upright("emp"))$ it means that the model generalizes well but of
  course perform worse on noisy data.

There is the need to introduce a new term in order to set an inequality that
somehow defines a bound on $R$ because the ideal case is the one in which

$ R lt.eq R_(upright("emp")) $

for noisy dataset. This is because often the approach to machine learning is
#strong[empirical risk minimization] (#strong[ERM];), which focuses on reducing
the error on the training data, in order to have better performances on unseen
data.

= VC-Dimension <vc-dimension>

The VC-dimension is a value that #emph[evaluates] $H$, providing a measure of
its #strong[complexity];. The VC-dimension can be thinked, by restricting on the
classification case, as the number of points that $H$ can correctly discriminate
for every possible labeling.

In order to better formalize this concept lets introduce the concept of
#strong[shattering];. Let be

- $X$: input space.
- $N$: the size of the input space.
- $H$: the hypothesis space.
- A binary classification problem.

We can define a #strong[dichotomy] as a particular partition or labeling of the
$N$ points. So the same set of points can has $2^N$ possible dichotomies.

A particular dichotomy is #strong[represented] in $H$ if there exists an
hypothesis $h in H$ that realizes the dichotomy.

#note(title: "Shattering")[
  The hypothesis space $H$ #strong[shatters] $X$ if and only if $H$ can
  represent all the possible dichotomies on $X$.
]

In other words $H$ #emph[shatters] $X$ if and only if, for every labeling of the
points there exists an hypothesis $h in H$ that can label them correctly.

#important(title: "VC-Dimension")[
  The #strong[VC-dimension] of a class of functions $H$ is the maximum
  cardinality of a set of points in $X$ that can be shattered by $H$.
]

In practice to see if $H$ has VC-dimension at least $k$ we need to find at least
one disposition of $k$ points, for which each dichotomy is represented in $H$.
Doesn’t matter if there exists one disposition in which a dichotomy is not
represented. In this case we can say that

$ V C (H) gt.eq k $

On the other hand, when for every possible arrangement of $k$ points, there
exists always at least one dichotomy that is not represented in $H$. And so

$ V C (H) < k $

In general the VC-dimension of a class of linear separators (LTU) in a
$n$-dimensional space is $n + 1$, in fact, for points in $bb(R)^2$ the
VC-dimension is $3$.

Let’s also notice that the number of free parameters is not a measure for the
VC-dimension. It’s related because, generally speaking, if paired with the input
dimension gives an hint on how flexible the model is. But we can’t directly
calculate the actual VC-dimension based on that.

== VC-Bound <vc-bound>

Now that we have a definition (at least for a class of problems) of
VC-dimension, we can relate it with the number of examples our model is trained
on. What we want to do now is to define a term $epsilon$ for which the
inequality

$ R lt.eq R_(upright("emp")) + epsilon $

is true, at least with high probability. This term is called
#strong[VC-confidence] and is defined as

$
  epsilon (V C , N , delta) = sqrt(
    frac(
      V C dot.op (ln frac(2 N, V C) + 1) - ln
      delta / 4, N
    )
  )
$

We will not go in detail on why is formulated like this. What is interesting is
observing how this term behaves with respect to its three parameters.

- $V C$: is the VC-dimension and if it grows, the whole term grows.
- $N$: is the number of patterns for the training and the higher it is, the
  lower the VC-confidence will be.
- $delta$: is a confidence term that indicates the probability for the
  inequality to be respected. To be precise the probability is $1 - delta$ for
  every $V C < N$. This is a parameter defined by the user in order to have a
  stronger or weaker relation: a small $delta$ means an high level of confidence
  that the inequality will be respected.

In other words, an higher VC-dimension means a more complex model, and so a
model that could over-fit. This is mitigated by the number of samples $N$,
because the higher the number of samples is, the lower is the uncertainty. In
the end we have $delta$ that is our level of confidence that the bound will be
respected.

We can now finally define the #strong[VC-bound] on the true risk $R$ of our
model, with respect to the number of data and the complexity of the model:

$ R lt.eq R_(upright("emp")) + epsilon (V C , N , delta) $

in particular the right side of the inequality is called *guaranteed risk*.

= Structural Risk Minimization <structural-risk-minimization>

So now we have two terms that define the upper bound on the true risk $R$, and
so it’s possible to model another approach, different from ERM (that only aims
to minimize $E_(upright("emp"))$), that instead tries to minimize both
$E_(upright("emp"))$ and $epsilon (V C , N , delta)$.

This approach is called #strong[structural risk minimization] (#strong[SRM];)
and uses the VC-dimension as a controlling parameter for minimizing the
generalization bound on $R$. Also assuming finite VC dimension we can define a
nested structure of hypothesis spaces according to the VC dimension:

$
  H_1 subset.eq dots.h.c subset.eq H_n arrow.r.double.long V C (H_1) lt.eq
  dots.h.c lt.eq V C (H_n)
$

The structural risk minimization find a trade-off between empirical error and
VC-confidence in order to reduce the VC-bound on the true risk.

#figure(
  image("images/vc-bound.png", width: 70%),
  caption: [ VC-Bound ],
)

In other words, when we perform a model selection we choose the model
with the best bound on the true risk. However this is in practice very
difficult to use because

- It can be too conservative.
- The VC-dimension of some hypothesis space is difficult to compute.
- As an upper bound is over pessimistic and may not suitable for
  reliable evaluation of the model’s generalization capabilities.
- Regularization heuristics (Tikhonov) already provide an implicit SRM
  implementation.

On the other hand this approach provides theory driven development of new models
as SVMs, that in the learning process try to minimize the empirical error and
the VC-confidence automatically.

= References <references>

- Machine Learning
- Support Vector Machine
