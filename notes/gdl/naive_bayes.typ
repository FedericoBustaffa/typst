#import "@local/note_template:0.1.0": *
#show: doc => note_template([Naive Bayes], doc)

#title()

The simplest case for a probabilistic model is when all variables are
*observed*. In particular we can think of a classifier, for which we have
features and targets: the *Naive Bayes*.

#figure(
  image("images/naive_bayes.png", width: 20%),
  caption: [ Naive Bayes ],
) <fig-naive-bayes>

This models assumes that features of a sample are _"caused"_ by their class
label, since typically samples with same label are grouped together.

= Generative Process

The model's *generative process* can be thinked as

+ Sample a class label from a multinomial distribution.
+ Sample every feature of that sample from a distribution (also multinomial in
  our case) given the label from the previous step.

So in practice we can think of a multinomial distribution that produces class
labels, and a bunch of other distributions (one for feature), each generating a
piece of information about the sample.

This model is typically involved in classification tasks in which features are
considered effects and the target class is considered the cause. Each input
sample is defined as a set of attributes:

$ x = chevron.l a_1, dots, a_L chevron.r $

and we have a *target classification function*

$ f : X --> C $

where $X$ is the feature space and $C$ is the class label space. The model wants
to know the probability of each possible class, given an input pattern

$
  P(c_j | a_1, dots, a_L) =
  frac(P(a_1, dots, a_L | c_j) dot P(c_j), P(a_1, dots, a_L))
$

that under the Naive Bayes conditional independence assumptions becomes

$
  P(c_j | a_1, dots, a_L) =
  frac(P(c_j) dot product_(i=1)^L P(a_i | c_j), P(a_1, dots, a_L))
$

or in more compact and _proportional_ form

$ P(c_j | a_1, dots, a_L) prop P(c_j) dot product_(i=1)^L P(a_i | c_j) $

where the right term is the joint probability of the training data

$ P(c_j) dot product_(i=1)^L P(a_i | c_j) = P(a_1, dots, a_L, c_j) $

Now this is the classification function used for inference. The way in which we
can train this model is by learn the parameters $theta$ of the joint
distribution of the whole dataset.

$ P(theta | c_j, a_1, dots, a_L) prop P(c_j, a_1, dots, a_L | theta) P(theta) $

with one of the three framework for learning.

== Maximum Log-Likelihood Learning

Let's focus on maximum log-likelihood for simplicity and let's also consider the
case where both class labels and features are categorical.


Class labels can have $K$ values, while the $l$-th feature can pick values from
a set $S_l$ of values. So we basically have a bunch of multinomial distributions
that model the data, hence the likelihood will be

$
  P(X, C | theta) & = P(C | theta) dot P(X | C, theta) \
                  & P(C | theta) dot P(X_1, dots, X_L | C, theta)
$

But for the conditional independence assumption the model does, we can write

$ P(X, C | theta) = P(C | theta) dot product_(l = 1)^L P(X_l | C, theta) $

that for every sample becomes

$
  P(X, C | theta) = product_(i = 1)^N [ P(c_i | theta)
    product_(l=1)^L P(x_(i l) | c_i, theta) ]
$

Now the class labels distribution is a plain multinomial of parameter $pi$, with
$K$ possible values, and the features distributions are also multinomials, each
of parameter $phi.alt_l$, we can rewrite the joint distribution like follows

$
  P(X, C | theta) = product_(k=1)^K pi_k^(N_k) dot
  product_(k=1)^K product_(l=1)^L product_(s=1)^S_l phi.alt_(k l s)^(N_(k l s))
$

where $N_k$ is the number of samples with class $k$ and $N_(k l s)$ is the
number of samples with classified as $k$ with value $s$ for the $l$-th feature.

A useful way of reformulating the problem is by the introduction of *indicator
variables*, defined as

$
  z_(i k) = cases(1 "if" c_i = k, 0 "otherwise") quad quad
  t_(i l s) = cases(1 "if" x_(i l) = s, 0 "otherwise")
$

In this way is possible to model the *likelihood* distribution as follow

$
  cal(L) (theta) & =
  product_(i=1)^N product_(k=1)^K P(c_i = k)^(z_(i k)) (product_(l=1)^L
    product_(s=1)^S_l (P(x_(i l) = s | c_i = k))^(t_(i l s)))^(z_(i k)) \
  & = product_(i=1)^N product_(k=1)^K pi_k^(z_(i k))
  (product_(l=1)^L product_(s=1)^S_l phi.alt_(k l s)^(t_(i l
    s)))^(z_(i k)) \
$

Now we can go in log-space and define the *log-likelihood* as follows

$
  log cal(L)(theta) & =
                      log(
                        product_(i=1)^N product_(k=1)^K pi_k^(z_(i k))
                        (product_(l=1)^L product_(s=1)^S_l
                          phi.alt_(l s)^(t_(i l s)))^(z_(i k))
                      ) \
                    & = sum_(i=1)^N sum_(k=1)^K z_(i k) log pi_k +
                      sum_(i=1)^N sum_(k=1)^K z_(i k)
                      (sum_(l=1)^L sum_(s=1)^S_l
                        t_(i l s) log phi.alt_(k l s))
$

So now is possible to optimize it by computing its derivative and set it to zero

$ (partial cal(L)) / (partial theta) = 0 $

we will obtain the update formula for $pi_k$ and $phi.alt_(k l s)$ that will
result in

$ pi_k = N_k / N quad quad phi.alt_(k l s) = N_(k l s) / N_k $

that now we can use to learn the data distribution.

== Inference

Once the model is trained we can perform inference by using the updated
posterior distribution.

$ P(C | X, theta) & prop P(X | C, theta) dot P(C | theta) $

which becomes

$ P(C = k | X_l = s, theta) = pi_k product_(l=1)^L phi.alt_(k l s) $

and so to classify $X$ we can compute

$ arg max_k pi_k product_(l=1)^L phi.alt_(k l s) $

that returns the most probable class $k$ given the input $X$. But in practice
also here is possible to use the logarithm:

$ arg max_k ( log pi_k + sum_(l=1)^L log phi.alt_(k l s) ) $

to avoid underflows in practical implementations.

== Sparse Data and Zero-Frequency

Can happen that a feature with value $s$ is never observed with class $k$ and so
$N_(k l s) = 0$ and the resulting probability will go to zero

$ P(x_l = s | c = k) = 0 $

because in this cases the Naive Bayes model confuses _unobserved_ with
_impossible_.

A classical remedy is to add *pseudo-counts* through a Dirichlet prior,
performing MAP learning.

