#import "@local/note_template:0.1.0": *
#show: doc => note_template([Naive Bayes], doc)

#title()

The simplest case of probabilistic model is the one that assumes all variables
are fully observable, in particular one of the most know probabilistic
classifier is the *Naive Bayes*.

#figure(
  image("images/naive_bayes.png", width: 20%),
  caption: [ Naive Bayes ],
) <fig-naive-bayes>

Which relies on strong conditional independence assumptions to simplify both
learning and prediction, still obtaining good results in many fields.

The model structure involves a bunch of multinomials:

- A multinomial models the $K$ possible classes.
- For each of the $L$ features we have $K$ multinomials modelling the feature.

In total we have $L times K$ multinomials plus one. Let's also point out that
features could be continuous; in that case is sufficient the have $K$ gaussians
for the feature(s).

= Generative Process

The model assumes that the class of the sample is the "cause" of its features,
which makes sense if we think that usually, in a classification problem, samples
classified the same are clustered together.

This also helps defining the *generative process* with the following steps

+ Sample a class label from a the classes multinomial.
+ For each of the $L$ features:
  + Select the $k$-th multinomial of the $l$-th feature.
  + Sample the feature value.

So in practice we can think of a multinomial distribution that produces class
labels, and a bunch of other distributions ($K$ for feature), each generating a
piece of information about the sample.

= Learning

To solve the learning inference problem let's write the joint probability of
this model for one sample $(x, y)$ applying the conditional independence
assumptions given by the model:

$ P(vb(x), y) = P(x_1, dots, x_L, y) = P(y) product_(l=1)^L P(x_l | y) $

that, since they are all multinomials, can be written as

$ P(vb(x), y) = pi_k product_(l=1)^L product_(s=1)^(S_l) phi.alt_(k l s) $

with $pi_k = P(y = k)$ and $phi.alt_(k l s) = P(x_l = s | y = k)$. So now is
possible to write the joint distribution for the whole dataset assuming that
samples are i.i.d.

$
  P(X, Y | theta) = product_(k=1)^K pi_k^(N_k)
  product_(k=1)^K product_(l=1)^L product_(s=1)^(S_l) phi.alt_(k l s)^(N_(k l s))
$

with $N_k$ the number of samples classified as $k$ and $N_(k l s)$ the number of
samples classified as $k$ whose $l$-th feature has value $s$.

== Maximum Likelihood

So now is possible to train the model by *maximum likelihood*, since the joint
is the likelihood for the learning inference problem. Since is better to work in
log-space we obtain *log-likelihood* as follows

$
  log P(X, Y | theta) := cal(L) (theta)
  = sum_(k=1)^K N_k log pi_k +
  sum_(k=1)^K sum_(l=1)^L sum_(s=1)^(S_l) N_(k l s) log phi.alt_(k l s)
$

that we can maximize by setting

$ pdv(cal(L), theta) = 0 $

Since they are multinomials their parameters must satisfy the sum to 1
constraint, enforced with Lagrangian multipliers:

$ J(pi_k, lambda) = sum_(k=1)^K N_k log pi_k + lambda (sum_(k=1)^K pi_k - 1) $

so now we have to compute the following partial derivatives

$
  pdv(J, pi_k) = N_k / pi_k + lambda \
  pdv(J, lambda) = sum_(k=1)^K pi_k - 1
$

and solve the following system

$
  cases(
    N_k / pi_k + lambda = 0,
    sum_(k=1)^K pi_k - 1 = 0
  ) ==>
  cases(
    pi_k = - N_k / lambda,
    sum_(k=1)^K pi_k = 1
  ) ==>
  cases(
    pi_k = - N_k / lambda,
    - 1/lambda sum_(k=1)^K N_k = 1
  )
$

and since $sum_(k=1)^K N_k = N$ we get

$ pi_k = N_k / N $

The same process goes for $phi.alt_(k l s)$

$
  J(phi.alt_(k l s), gamma_(k l))
  = sum_(k=1)^K sum_(l=1)^L sum_(s=1)^(S_l) N_(k l s) log phi.alt_(k l s) +
  gamma_(k l) (sum_(s=1)^(S_l) phi.alt_(k l s) - 1)
$

for which we get the following partial derivatives

$
  pdv(J, phi.alt_(k l s)) = N_(k l s) / phi.alt_(k l s) + gamma_(k l) \
  pdv(J, gamma_(k l)) = sum_(s=1)^(S_l) phi.alt_(k l s) - 1
$

from which we get the following optimal parameter

$ phi.alt_(k l s) = N_(k l s) / N_k $

With this is possible to easily train the model but we have to take care to the
fact that we can have zero occurences of some feature value or class and that
will break the probabilities.

== Maximum a Priori

A practical of avoiding zero-valued probabilities is to start every counter from
one instead of zero. This works but can be generalized and corresponds in fact
to add a *Dirichlet prior*, performing *maximum a priori learning* with *pseudo
counts*.

So now we also have to model $P(theta)$ to solve the learning inference problem:

$ P(theta) = P(pi, phi.alt) $

for which we can have the same conditional independence assumptions we had for
data:

$ P(pi, phi.alt) = P(pi) product_(k=1)^K product_(l=1)^L P(phi.alt_(k l)) $

So now we can better define

$
  P(pi) = frac(product_(k=1)^K pi_k^(alpha_k - 1), B(alpha_1, dots, alpha_K)) \
  P(phi.alt_(k l)) = frac(
    product_(s=1)^(S_l) phi.alt_(k l s)^(beta_(k l s) - 1),
    B(beta_(k l 1), dots, beta_(k l S_l))
  )
$

that all together defines the prior:

$
  P(pi, phi.alt) = frac(
    product_(k=1)^K pi_k^(alpha_k - 1), B(alpha_1, dots, alpha_K)
  ) product_(k=1)^K product_(l=1)^L frac(
    product_(s=1)^(S_l) phi.alt_(k l s)^(beta_(k l s) - 1),
    B(beta_(k l 1), dots, beta_(k l S_l))
  )
$

so now we can obtain the *posterior* by multiplying the obtained prior with the
likelihood

$
  P(theta | X, Y) =
  product_(k=1)^K pi_k^(N_k)
  product_(k=1)^K product_(l=1)^L product_(s=1)^(S_l) phi.alt_(k l s)^(N_(k l s))
  frac(
    product_(k=1)^K pi_k^(alpha_k - 1), B(alpha_1, dots, alpha_K)
  ) product_(k=1)^K product_(l=1)^L frac(
    product_(s=1)^(S_l) phi.alt_(k l s)^(beta_(k l s) - 1),
    B(beta_(k l 1), dots, beta_(k l S_l))
  )
$

that is equal to

$
  P(theta | X, Y) = frac(
    product_(k=1)^K pi_k^(N_k + alpha_k - 1), B(alpha_1, dots, alpha_K)
  ) product_(k=1)^K product_(l=1)^L frac(
    product_(s=1)^(S_l) phi.alt_(k l s)^(N_(k l s) + beta_(k l s) - 1),
    B(beta_(k l 1), dots, beta_(k l S_l))
  )
$

Now we can transform it in log-space, take the derivative and optimize it as
before. The resulting values are pretty much the same but this time with the add
of _pseudo counts_:

$
             pi_k & = frac(N_k + alpha_k - 1, sum_(k=1)^K N_k + alpha_k - 1) \
  phi.alt_(k l s) & = frac(
                      N_(k l s) + beta_(k l s) - 1,
                      sum_(s=1)^(S_l) N_(k l s)+ beta_(k l s) - 1
                    )
$

So now we can also *regularize* the model by injecting prior knowledge.

= Inference

To make predictions about classes we must define the posterior via Bayes rule:

$
  P(y | x_1, dots, x_L) = frac(P(x_1, dots, x_L | y) P(y), P(x_1, dots, x_L)) =
  frac(P(y) product_(l=1)^L P(x_l | y), P(x_1, dots, x_L))
$

from which we have to compute

$
  arg max_k frac(P(y = k) product_(l=1)^L P(x_l | y = k), P(x_1, dots, x_L))
$

to have the most probable class given $x$.
