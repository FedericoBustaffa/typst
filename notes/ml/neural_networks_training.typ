#import "note_template.typ": *
#show: note_template

#title("Neural Networks Training")

With neural networks achieving a good training is not so complex but there are
many aspects to take care of. This is because the model often has a lot of
parameters that have to be nicely set, in order to a have a fast, yet stable
training, that of course should lead to a model good at generalize the problem.

= Starting Values <starting-values>

The first thing to set up usually are the weights, and this can be very simple
because most of the, especially for simple problems, a random initialization
with small weights (near $0$) is enough.

If we initialize the weights to $0$ then we fall in the *symmetry problem*,
where basically all the gradients will be the same and so the network will not
really learn.

Another technique is the so called #strong[fan-in] that initializes the weights
via the following formula:

$ upright("range") dot.op 2 / upright("fan-in") $

where $upright("fan-in")$ is the number of inputs to a hidden unit.

Another method is the #strong[Glorot] where the biases are all initialized to
$0$ and the weights are sampled from a uniform distribution in the interval

$ [frac(- 1, a) , frac(+ 1, a)] $

where usually $a = sqrt(upright("fan-in"))$.

An aspect to take care of when the network is small is that can have strong
dependencies with respect to the weights initialization.

= Multiple Minima <multiple-minima>

The loss function of a neural network is generally #strong[not convex] and so
there are many local minima in which the gradient can #emph["fall"];.

The local minima found in training depends on the starting point and so, in
order to find a good configuration is necessary to train the model multiple
times with different initialization of the weights.

Generally after multiple training there are two options in order to choose the
final network, but in general there is the need to compute the #strong[mean of
  errors];, so that is directly comparable and also take a look at the
#strong[variance] in order to have an idea on the error values fluttuations.
Then is possible to:

- Pick the best set of weigths that lead to the best training/validation
  results.
- Try to take advantage of different endpoints by #emph[averaging] the results.

If the training stops with high training error is no big deal because is always
possible to start again with new weights.

In general is worth notice that we are not so interested in finding a local or
global minima for the $R_(upright("emp"))$ function, because we are actually
trying to find them for the $R$ function, which is not possible. Often the
algorithm stops in points that are not even #emph[null] gradient points.

Also the network build a #strong[variable-size hypothesis space] because it
increases the VC-dimension in training phase, reducing the empirical risk, but
increasing the network complexity, leading to overfitting.

= On-line vs Batch <on-line-vs-batch>

In order to have a stable and fast training is also necessary to address the
problem of choosing between #strong[on-line] and #strong[batch] training:

- #strong[Batch];: all the patterns are presented to the network, that make the
  prediction and so the error is accumulated. Only in the end the weigths are
  updated with backpropagation.
- #strong[On-line or Stochastic] (#strong[SGD];): for each pattern presented to
  the network the weights are immdiately updated based on that specific pattern
  error. The method cycles through every pattern (an #strong[epoch];), and then
  starts over again until convergence.

The first method is usually more stable, but also slower in terms of
convergence, while the second one is usually really unstable but faster to
converge.

The second can do big #emph[jumps] due to the fact that consecutives patterns
may be very different and so lead to a big error, helping to avoid local minima.
In order to not always cycle through the dataset in the same order is common to
shuffle it after an epoch.

== Mini-Batch <mini-batch>

A good compromise between the two is the so called #strong[mini-batch] that is
basically an hybrid approach that uses the stochastic version but on small sets
of training examples.

In this way the gradient is more accurate, and the convergence is faster than a
complete batch approach.

Of course now we have one more hyper-parameter to care about, that is the size
of the mini-batch, usually denoted with $upright("mb")$.

= Learning Rate <learning-rate>

One very important hyper-parameter is the #strong[learning rate] $eta$, between
$0$ and $1$, also with respect the previous method update the weights:

- In case of batch training, the average error is usually lower and decreases in
  a more stable way; this permits higher values of $eta$ to speed up the
  convergence.
- On the other hand, for a stochastic training, there is the need for a lower
  value of $eta$, in order to stabilize the convergence.

Usually, by plotting the #strong[learning curve] (error trend over time) is
often very clear if the training is nice and smooth or very unstable.

A common way to tune $eta$ is with respect to the number of patterns $l$.

For example if using batch approach, in order to normalize the total error, we
divide all the gradients by $l$, but this is equivalent to have a learning rate
of $eta \/ l$.

For SGD, the learning rate must be very small to have a stable convergence and
in case of mini-batch is possible to divide by $upright("mb")$ but in this case
also $eta$ must be tuned again in order to be proportional to the batch case.

Dividing by $l$ is always a good choice but can lead to very little value of
$eta$.

== Momentum <momentum>

A very popular improvement for the learning rate to be more flexible is the
#strong[momentum];, which involve the inclusion of $eta$ in $Delta w$, so that
now the learning rule becomes

$ w_(upright("new")) = w + Delta w_(upright("new")) $

and then another term is added

$
  w_(upright("new")) = w + Delta w_(upright("new")) + alpha Delta
  w_(upright("old"))
$

with $alpha$ that is a new hyper-parameter and $Delta w_(upright("old"))$ that
is the gradient computed at the previous step. Of course after the computation
we update

$ Delta w_(upright("old")) = Delta w_(upright("new")) $

This method creates an #emph[inertia effect] that allows higher $eta$ values
because stabilizes the gradient in directions that oscillate in sign and also
results faster in plateaus.

An important thing to notice is that if we use the momentum in batch, there are
no big issues, but in SGD, $Delta w_(upright("old"))$ is the gradient computed
on a different pattern and so it smooths the gradient over _different patterns_
(same reasoning for mini-batch).

A particular variant of this method is the #strong[Nesterov momentum] which
evaluates the gradient #emph[after] the momentum is applied:

+ Apply the momentum on the current weights:
  $underline(w) = w + alpha Delta w_(upright("old"))$.
+ Evaluate the new gradient on $underline(w)$.
+ Compute and apply the $Delta w$ to the #emph[original] $w$.

This is usually done to improve the rate of convergence for the batch mode and
not for the SGD.

== Variable Learning Rate <variable-learning-rate>

Using mini-batch the gradient does not decrease to zero close to a minimum as
the exact gradient, hence #emph[fixed] learning rate should be avoided.

A possibility is to make the learning rate decay (linearly for example) for each
step until some iteration $tau$

$ eta_s = (1 - gamma) dot.op eta_0 + gamma dot.op eta_tau $

with $gamma = s \/ tau$ and $s$ that is the current step; after $tau$ iterations
we stop and use $eta_tau$ until the end.

Again we introduce new hyper-parameters like $tau$ or the starting learning rate
$eta_0$ that must be tuned in the model selection phase.

== Adaptive Learning Rate <adaptive-learning-rate>

With this method we want to automatically adapt the learning rate during the
training, in order to reduce as much as possible the fine-tuning phase of this
hyper-parameter.

= Stopping Criteria <stopping-criteria>

In order to stop our training algorithm we need a #strong[stopping criteria]
that can be one of these three types:

- #strong[Error];: for example we want to reduce the error under a given
  threshold but usually we have to know the data tolerance and often we don’t
  have this info. For classification we can use the accuracy or error rate, but
  again we may suffer from the same problem as before.
- #strong[Internal criteria];: we can stop when the weights change is very small
  and not relevant anymore, or when we reach a point in which the gradient norm
  is near zero. This approach may be premature and so it’s usually applied by
  observing $k$ epochs.
- #strong[Max iterations];: this is used to avoid an excessive number of
  iterations but also fixing an arbitrary number of iterations is not that good.

= Over-fitting <over-fitting>

Very important, expecially for flexible models as neural networks to avoid
#strong[over-fitting];, in order to have a good *generalization capability* also
on unseen data. There are three main techniques in this regard

- #strong[Early stopping];: use a validation set to see when the error
  increases.
- #strong[Regularization]
- #strong[Pruning methods]

== Regularization <regularization>

During training the units tend to saturate, and so there is an increase in the
VC-dimension that can lead to over-fitting.

In order to optimize the loss function while keeping the weight values as small
as possible (at least a part of them), it’s possible to introduce
#strong[regularization];.

The simplest regularization technique comes from #strong[Tikhonov theory] and
consists in adding a #strong[penalty term] to the error function:

$ upright("loss") (w) = sum_p (y_p - o (x_p))^2 + lambda parallel w parallel^2 $

that is basically a sum over all the weights in the network

$ parallel w parallel^2 = sum w_i^2 $

this creates a #strong[weight decay effect] by basically adding a negative term
to the learning rule

$ w_(upright("new")) = w + eta dot.op Delta w - 2 lambda w $

Of course now we have a new hyper-parameter $lambda$, that generally is very low
like $0.01$, that can be choose in the model selection phase.

Keep attention to the fact that now the loss is changed in order to train the
model, but to evaluate it the MSE function should be used, because it gives a
real estimation of model performances on data.

Some important detail is that often the bias $w_0$ is omitted from the
regularization because its the bias simply moves the function up or down and
this let the model to find first the right #emph["altitude"] and then shaping
the function in order to fit the data.

Penalize the bias means not letting the model "#emph[focus];" the problem, what
we are interested penalize are the weights, that are multiplicative terms for
input features and so they are the ones that truly shape the function.

A common situation is to mix all this techniques that modify the learning rule
but, depending on how the this is done we can obtain different behaviors.

For example, to mix momentum and regularization, usually we apply the momentum
to a regularized loss:

$
  Delta w = - eta frac(partial upright("loss") (w), partial w) + alpha Delta
  w_(upright("old"))
$

and not the error function like in the simple implementation of momentum.

#important(title: "Decoupling effects")[
  Check better also how to make $eta$, $lambda$ and $alpha$ independent
]

If instead we want to keep separation between the three parameters $eta$,
$lambda$ and $alpha$, it’s possible to compute the gradient as in the basic case
and apply the momentum to it

$ Delta w = eta delta_t o_u + alpha Delta w_(upright("old")) $

then we apply the regularization to the result to get the new weights

$ w_(upright("new")) = w + Delta w - lambda w $

so that now the three hyper-parameters are #emph[independent];.

= Preprocessing <preprocessing>

Usually a good thing to do before training the model is *data preprocessing*
because it put features on the same scale of magnitude, preventing some feature
to be predominant over others, while in reality they are all equally meaningful.

The fact the a feature has bigger absolute values does not mean that its more
important, it simply lives in a different (more or less big) space.

In order to make the features equally meaningful is good practice to
#strong[normalize] them via

- #strong[Standardization];: for each feature $x_i$ we obtain the new values by
  $ x_i' = frac(x_i - mu_i, sigma_i) $
  where $mu_i$ is the feature mean and $sigma_i$ is its standard deviation. In
  this way the new feature has mean equal to $0$ and standard deviation equal to
  $1$.
- #strong[Rescaling];: for each feature $x_i$ we obtain the new values by
  $ x_i' = frac(x_i - min (x_i), max (x_i) - min (x_i)) $
  rescaling the feature in $[0 , 1]$ range of values.

== Categorical Features <categorical-features>

Another aspect is with respect to #strong[categorical features];, that in some
cases don’t have an #emph[order] and so cannot be mapped like $1 , 2 , dots.h ,
k$ because we are implicitly saying that the value $k$ is more #emph[heavy] than
$1$.

In this case the $1$-of-$k$ method is applied, enlarging the input size with
#emph[boolean] like features. For example, for a feature #emph[color] that can
have two values: #emph[red] and #emph[blue];, the input changes from a single
feature that can have only #emph[red] or #emph[blue] value to two different
features, that can only have $0$ or $1$ values. In this way if we have a
#emph[red] value we have that $x_1 = 1$ and $x_2 = 0$ (of course is the opposite
in case of #emph[blue];).

== Missing Data <missing-data>

Particular attention goes to cases were #strong[data is missing];: a missing
data should be correctly encoded as such; setting the feature to $0$ does not
mean that is missing.

There are many techniques like discard the incomplete data, or try to inference
it by looking at the distribution of complete data.

= Output of The Network <output-of-the-network>

The #strong[output of the network] can change based on the task (regression or
classification) and also based on the number of output we need.

For example in regression the output is a #strong[linear unit] that gives a real
number. Add more units for multiple quantitative responses.

For classification instead we have a singular unit for binary classification
where the activation function is a sigmoid, for which we can decide a threshold
to assign the class.

In case of multi-class problems we need a $1$-of-$k$ encoding and $k$ outputs
nodes, each with the activation function that is a #strong[softmax];, basically
saying the probability that input $x$ is class $i$ (repeated for each class).

= Number of Units <number-of-units>

In general there isn’t a way to know how many units and layers are optimal for
the problem; typically this is addressed with model selection where many
architectures are compared.

In alternative there are other methods to find a good architecture
*automatically* like *constructive approaches* and *pruning methods*.

The first tries to build the network, starting from few units and adding them
during the training; a popular approach is #strong[cascade correlation];.

The other one, starting from a relatively big network, remove units, also having
a regularization effect.

= References <references>

- Neural Networks
- Backpropagation
- Activation Functions
- Cascade Correlation
