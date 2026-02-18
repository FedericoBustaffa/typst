#import "@local/note_template:0.1.0": *
#show: note_template

#title("Deep Learning Techniques")

In order to train a deep neural networks standard appraches and techniques are
not enough. In the past training was done by pre-training but nowadays there are
better way to train a model end-to-end for a specific task.

The main issues with deep neural networks are related to the gradient, that can
become too small or too big depending on weights magnitude. Multiplication
through many layers can cause these issues causing the failure of training.

= Exploding Gradient <exploding-gradient>

When the model backpropagate the error through many layers, when the weights are
big, the gradient magnitude grows exponentially, causing very unstable training
and overflows.

== Gradient Clipping <gradient-clipping>

During the optimization, the model could encounter cliffs in the cost function,
causing a big variation in the gradient and causing big jumps in the
optimization process.

#figure(
  image("images/gradient_clipping.png", width: 70%),
  caption: [ Loss Function Cliff ],
)

In order to avoid this and mantain a smooth stable training, is possible to
#strong[clip] the gradient if its norm exceeds a threshold $v$, so if $parallel
g parallel > v$, where $g$ is the gradient vector, the new gradient becomes

$ g = v dot.op frac(g, parallel g parallel) $

Take into account that the clipping can be done layer by layer during
backpropagation or #emph[globally] in a single step:

- #strong[Layer wise];: during backpropagation each layer computes its gradient
  vector and clip it if necessary. Can be finer for each layer but can modify
  proportions between layers.
- #strong[Global];: each layer computes its gradient vector. The clipping is
  based on the norm of the global gradient vector of each layer. This is more
  stable and preserve relative gradient directions through layers.

The standard for most libraries is the global approach.

= Gradient Vanish <gradient-vanish>

If weights are small can happen that the gradient for first layers is too small
and the update is almost zero. This usually happens for sigmoidal activation
functions that reach saturations and produce very small gradient.

Also repetition of multiplication of small quantities through many layers leads
to exponentially small gradients going towards input layer.

This problem can be addressed in many ways, for example with #strong[ReLU]
activation function (and its variants) or with #strong[batch normalization];.

== Batch Normalization <batch-normalization>

An interesting technique is called #strong[batch normalization] at it consists
in normalizing each batch through a standardization, keeping $w x + b$ with mean
to 0 and variance to 1.

This helps stabilize sigmoids activation functions that now will saturate less
easily and it adds a regularization effect due to the introduced noise.

= Dropout <dropout>

Another interesting technique for deep learning is #strong[dropout] that
basically randomly selects a subset of the network during training.

Basically a mask is applied the entire network, turning on and off some neurons
and train them for an epoch. Typically the number of #strong[subnet] is fixed
(like 10-20) and some configuration might not be valid: there isn’t a path from
input to output.

#figure(
  image("images/dropout.png", width: 50%),
  caption: [ Dropout ],
)

This has the effect of training multiple models potentially with different input
parts (like a bootstrap) but for the same task. In practice this is an ensemble
(in particular a bagging) of networks that in the end make their prediction
based on a majority vote (or a mean for regression).

Of course this introduces noise and act like a regularization technique, like
for every ensemble model; high variance models can perform well on average.

Typically there is an hyperparameter that defines the probability of sampling a
mask value of 1. Each unit not included is multiplied by 0 ("drop out").

Of course can happen that some unit is present in multiple subnets, causing an
implicit weights sharing among them. This also brings a side effect for each
shared unit: now an hidden unit is not just a good feature, but a good feature
in many contexts.

= References <references>

- Deep Learning
- Neural Networks
- Neural Networks Training
