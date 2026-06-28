#import "@local/note_template:0.1.0": *
#show: doc => note_template([Autoencoders], doc)

#title()

An *autoencoder* is a model trained to reconstruct its input, after passing it
through some sort of *latent bottleneck*. In this sense autoencoders learn a way
to compress data e reconstruct it, capturing the most relevant informations.

Usually the autoencoder is composed by an *encoder*, which projects the input
data onto a *latent space* and a *decoder* that tries to reconstruct the
original input from the _latent code_.

#figure(
  image("images/autoencoder.png", width: 80%),
  caption: [ Autoencoder ],
)

There are many types of autoencoder that can differetiate on each other either
by architecture or by end goal. In general they have in common to learn two
functions:

$ z = f_theta (x) quad quad tilde(x) = g_theta (z) $

hopefully obtaining $x approx tilde(x)$, by minimizing a reconstruction loss

$ min_theta sum_(x in cal(D)) L (x, g_theta (f_theta (x))) $

which can change depending on nature of data.

= Manifold Hypothesis

Autoencoders main assumption is the *manifold hypothesis* which tells that data
usually organize near a lower-dimensional nonlinear *manifold* embedded in a
high-dimensional space. Like they were naturally projected in an organized way
that just by looking at the raw input is not clear.

If data lie near a manifold $cal(M)$ of much lower dimension, then a good
representation should preserve directions along that manifold, while suppressing
irrelevant ones.

In other words the autoencoder should be sensitive to perturbations tangent to
the manifold while be relatively insensitive to perturbations perpendicular to it.

= Bottlenecks Implementations

There are many ways to create the bottleneck in such a way that is non-trivial
and let the model learn meaningful latent representations.

== Dimensionality Reduction

One simple method just creates the bottleneck forcing the high-dimensional data
to a much lower-dimensional space.

$ K << D $

In this way the autoencoder compresses the input before try to reconstruct it.
This is simple but if the bottleneck is to narrow then the model will struggle
reconstruct the original input and the reconstruction loss might be very high.

On the other end the bottleneck could be to wide, leaving the model too much
freedom, resulting in a learned transformation that is very close to the
identity.

== Sparse Autoencoders

Another way is to enforce sparsity while projecting the data to a much
higher-dimensional space.

$ K >> D $

Of course we need to add a penalty term in order to avoid learning trivial
identity transformations. One popular choice is to add to the loss an L1 penalty
term

$ min_theta sum_(x in cal(D)) L(x, g(f(x))) + lambda norm(z)_1 $

which encourage sparsity over the latent space by turning off weaker directions.

Projecting data to an higher dimension sounds counterintuitive but allow the
model to have more expressive power.

We can think of the model to learn how to map data into different zones of the
high-dimensional latent space using only few directions, while most of the
latent code is zero. In this way is possible to create many bottlenecks, one for
each _cluster_ of data.

#example[
  If our data is $10$-dimensional we can project it to a $20$-dimensional space
  and hopefully the model will use only a few (let's say $2$) of those directions
  to generate the latent code.
]

In this way is in theory possible to let the model use more of the latent space
if needed and most important is not constrained to use the same bottleneck for
the full dataset.

A probabilsitic interpretation could be something like a MAP learning with a
Laplace distribution as a prior over $z$.

== Denoising Autoencoders

A type of autencoder strictly related to the manifolds hypothesis defined before
is the *denoising* autoencoder. These models are trained to reconstruct input
that is manually perturbed, usually with a gaussian noise

$ hat(x) = x + epsilon " with " epsilon tilde cal(N) (vb(0), sigma^2 I) $

The encoder receives $hat(x)$, while the target remains the original $x$.

The model learns a way to fix the corruption, or in other words, a *vector
field* that points towards the manifold where data should lie.

A more involved point of view is that the DAE learns a *conditional denoising
distribution* of input data

$ p(x | hat(x)) $

by minimizing the MSE or equivalently by maximizing the conditional
log-likelihood

$ EE_(x, hat(x)) [log p(x | z = f(hat(x)))] $

This should give the idea that, given a probability density $p(x)$, we can
define a *score function* that is the gradient w.r.t. the input of the log-density

$ s(x) = pdv(log p(x), x) = nabla_x log p(x) $

so now we have that $log p(x)$ represents how likely a point is, while $nabla_x
log p(x)$ represents the direction of the steepest increase in that probability.

The DAE optimizes $EE_(x, hat(x)) [norm(x - g(f(hat(x))))_2^2]$ which has an
optimal minimizer when

$ g(f(hat(x))) = EE[x | hat(x)] $

For a small Gaussian noise we can use the *Tweedie's formula*:

$ EE[x | hat(x)] = hat(x) + sigma^2 nabla_(hat(x)) log p(hat(x)) $

If now use the minimizer and solve for the score we have

$ frac(g(f(hat(x))) - hat(x), sigma^2) = nabla_hat(x) log p(hat(x)) $

that is the vector field learned by the DAE.

An interesting implication is that if the model learns how to bring back to the
manifold data that is moderately corrupted, multiple iterations over a sample
with a stronger noise, could bring it back to the manifold.

== Contractive Autoencoders

Another way to create the bottleneck is represented by the *contractive
autoencoder*, which penalizes the Jacobian of the encoder by adding a term to
objective function:

$ sum_(x in cal(D)) L(x, tilde(x)) + lambda norm(pdv(f_theta, x))_F^2 $

that has the effect of making the learned transformation contractive in
directions that are not useful to build the latent code.

Considering a single hidden layer encoder

$ z = f_theta (x) = phi.alt (W x + b) $

then the Jacobian is

$ pdv(z, x) = diag(phi.alt' (W x + b)) W $

Hence the contractive penalty becomes

$ norm(pdv(z, x))_F^2 = norm(diag(phi.alt' (W x + b)) W)_F^2 $

making the penalty small when either the weights are small or the units are in
regions where the activation derivative is small.

= Deep Autoencoders

A simple way to make the autoencoder even more powerful is to make it *deep*,
just by stacking layers on both the encoder and the decoder:

$ x -> z_1 -> dots -> z_L -> tilde(z)_(L-1) -> dots -> tilde(z)_1 -> tilde(x) $

In this way the model learns intermediate and hierarchical representations,
encouraging organization in high level features.

== Layerwise Unsupervised Pretraining

An historical way of training autoencoders and more in general deep networks was
the *layerwise unsupervised pretraining*. This method was useful to train deep
architectures when it was difficult to optimize them end to end due to gradient
issues like gradient vanish.

The idea is to train one layer at a time to reconstruct the output of the
previous layer (the input for the first layer); once a layer is trained another
one is stacked on top of it and trained, while the older one keeps its weights
freezed. In this way the training is similar to that of reservoir computing and
there is no need for backpropagation, just gradient descent or direct methods on
the last layer.

Once all layers are trained is possible to fine tune the architecture by
backpropagation with the difference that now weights starts from much better
values to optimize. We can also stack an additional task-specific layer (for
example a classifier) that now learns from high-level features.

= Deep Belief Networks

An interesting link with probabilistic models and autoencoders is the fact that
an RBM has the structure of a neural network layer, therefore, seems legit to
stack multiple RBMs on top of each other, creating a *deep belief network (DBN)*

The problem is that RBMs are undirected graphical models and so an intermediate
layer is influenced by the previous and the next, which is not the same flow of
information we have in a deep autoencoder.

An implication of this is that some contributions may be counted twice and
that's also why a common technique is to divide them by 2.
