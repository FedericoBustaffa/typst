#import "@local/note_template:0.1.0": *
#show: doc => note_template([Convolutional Neural Networks], doc)

#title()

The motivation behind *convolutional neural networks (CNN)* is to work with the
inductive bias that assumes data with strong *spatial* or *sequential*
organization.

The key idea is to treat nearby locations of the input as strongly related one
another. In other words the network tries to capture local relations among
inputs so that they can be reused to recognize the same pattern in different
positions.

For images we want to learn what a specific subject is regardless its position
or scaling w.r.t. to the image frame. A multi-layer perceptron instead learns
absolute patterns that are difficult to generalize to different locations,
scaling or rotations, other than that it has to optimize a large number of
parameters if the input for example is an high resolution image.

A CNN solve this problems by local connectivity, weight sharing and hierarchical
composition.

We mostly refer to CNN in the context of image processing, since it is the most
popular field of application.

= Images Representation

An image $x$ can be represented as a matrix:

$ x in RR^(W times H) $

and if it has colors, as a 3-dimensional tensor to represent RGB channels

$ x in RR^(W times H times 3) $

If we flatten this representation to a 1-dimensional vector of dimension $W H
C$, a dense layer computes

$ h = W x + b $

where $W$ is a dense parameter matrix with each row of dimension $W H C$ and the
number of column equal to the number of neuron of that layer.

= Convolutional Layers

A CNN replaces dense matrix multiplication with *convolutions*, enforcing sparse
local connectivity and parameter sharing. We can say that a convolutional layer
replaces a neuron with a *filter* or *kernel* $K$, applied to the image.

The convolution with kernel $K$ applied at spacial location $(i, j)$ is defined
as

$ (x convolve K) (i, j) = sum_m sum_n x(i-m, j-n) K(m, n) $

and what a CNN actually does is to apply the same kernel to each location of the
input, enabling _parameter sharing_ that gives the CNN *translational
invariance*.

Usually a kernel used for images can have free dimension of width and height but
must have the same channel size of the image. In order to make the convolutional
layer more powerful we can just run multiple kernels on the image.

A nice thing to notice is that the convolution is basically a scalar product
between weights of the kernel and a portion of the image if they were 1-D
vectors:

$ a_(i, j) = w^TT x_(i, j) + b $

where $x_(i, j)$ is the element $x_(i j)$ of the matrix and its neighborhood,
whose dimension depends on the kernel dimension.

This also gives us the intuition of sparse connectivity because, bringing
further this idea reveals that a kernel applied to an image is equivalent to
sparse matrix multiplication by a matrix with special structure.

// expand this idea for the backpropagation

In general for multi-channels images, we use 3-D kernels with the channel
dimension equal to channel dimension of the input. The number of those kernels
in a layer defines the channel dimension of the output since they will be all
stacked.

$
  a_(i, j) = sum_(c=1)^(C_"in") sum_(m=1)^K_w sum_(n=1)^K_h
  x_(i+m, j+n, c) K_(m,n,c) + b
$

When all kernels of the layer are applied we obtain a tensor with shape

$ a in RR^(W' times H' times C_"out") $

== Stride

The basic convolution application moves the kernel of one cell at a time that is
equal to have a stride $S = 1$. The thing is that the stride is an
hyperparameter that can be greater than $1$, that however changes the dimension
of the output feature map. In general we have that the dimension of a feature
map is given by the formula

$
  W' = floor(frac(W - K + 2 P, S)) + 1 quad H' = floor(frac(H - K + 2 P, S)) + 1
$

which assumes a squared kernel and stride in every direction to be the same
(stride can different on horizontal and vertical axes). Therefore, the stride
reduces the number of multiplications and implements a form of downsampling,
similarly to a dense layer that has less units than input dimension.

== Padding

A usual technique to avoid downsampling the image after a convolution is to add
*padding* around it (usually zeros). A common choice to preserve spatial size with
odd kernels and stride $1$ is

$ P = (K - 1) / 2 $

== Nonlinearity

As in multi-layer perceptron, after the linear transformation a *non-linear*
function is applied element-wise:

$ h = phi.alt (a) $

that typically is a ReLU, to reduce gradient vanishing effect.

= Pooling Layers

Another layer that is a novelty with respect to multi-layer perceptron
architecture is the *pooling* layer.


The most popular choice is the so called *max-pooling* which can be thinked as a
kernel as before, that simply keeps tha max activation among the ones on its
local window.

A pooling kernel of size $2 times 2$ is applied to 4 nearby pixel of the image
and returns in output only the one with maximum value.

It reduces spatial resolution but provides a different form of translation
invariance, since a feature that is detected slightly shifted can be captured
the same way by the pooling operator.

= Sparsity

A convolutional layer can be interpreted as *sparse* alternative to dense
layers, in fact supposing to have 1-dimensional inpute sequences and a filter of
length $3$, the output at position $t$ of the convolution is

$ h_t = a x_(t-1) + b x_t + c x_(t+1) $

As we can see each output depends only on a local neighborhood (sparse
connectivity) and reuse the same weights (weight sharing), drastically reducing
the number of parameters to optimize.

To have a more clear idea let's take a case in which inputs are images of size
$H times W times C_"in"$ and let we use $C_"out"$ kernels. Then the number of
trainable weights is

$ K^2 dot C_"in" dot C_"out" $

that if we have for example kernels $3 times 3$ and $C_"out" = 32$ and RGB
images, we would have

$ 3 dot 3 dot 5 dot 32 = 1440 $

and if we can see the size of images never appears in the formulation, so
increasing resolution doesn't increase the number of weights.

For a dense layer instead with $32$ neurons and fixed image sizes like $28 times
28$ like MNIST dataset, we would have

$ 28 times 28 times 32 = 25088 $

weights to optimize for such small images.

= Receptive Field

An important concept with CNNs is how their *receptive field* evolves with
depth. In general it grows with depth since, the first layer has a receptive
field as large as the kernel dimension. But we must account that the ouput of
that convolution is a linear combination of the input cell in which the
convolution is centered and its neighbors.

A deeper convolutional layer will apply the convolution centered in a feature
that, just on its own, is a mix of multiple inputs, and combines it with other
features obtained the same way.

This and the fact that we can stack multiple kernels in a single layer, explains
why small kernels are usually preferred to bigger ones.

#figure(
  image("images/cnn_receptive_field.png", width: 40%),
  caption: [ Receptive Field ],
) <fig-rf>

Talking about the receptive field without pairing it with weight sharing is not
particularly interesting. In fact an MLP has a maximal receptive field at every
level, but doesn't have weight sharing. CNNs instead enlarge the receptive field
letting local small kernel to learn more complex structures that can detected
also in other positions.

= Training

The training in CNNs is still done by backpropagation but the problem now can be
how to derive the convolution operator, also taking weight sharing into account.

To have a better understanding of what is going on we can simply think about a
small sequence

$ x = vec(x_1, x_2, x_3) $

on which the simplest kernel possible (a scalar $w$) is applied with a
convolution:

$ x convolve w = vec(x_1 w, x_2 w, x_3 w) = vec(y_1, y_2, y_3) $

If we now suppose to have a target vector $d$ we can use some loss function to
know the error we made:

$
  cal(L) (y, d) = norm(y - d)_2^2
  & = (y_1 - d_1)^2 + (y_2 - d_2)^2 + (y_2 - d_3)^2 \
  & = (x_1 w - d_1)^2 + (x_2 w - d_2)^2 + (x_2 w - d_3)^2
$

So now we can just compute the derivative w.r.t. $w$:

$
  pdv(cal(L), w)
  & = 2 (x_1 w - d_1) x_1 + 2 (x_2 w - d_2) x_2 + 2 (x_3 w - d_3) x_3 \
  & = delta_1 x_1 + delta_2 x_2 + delta_3 x_3 = delta convolve x
$

So in other words we can obtain the gradient of a convolutional layer by running
a convolution between the previous layer outputs and the backpropagated portion
of the error from next layer.

== Batch Normalization

A common phenomenon is the so called *internal covariate shift*, that happens
when the network becomes deeper and is trained with batch or mini-batch is that
the distribution of the activations can vary significantly across epochs due to
weights update.

A way to stabilize the activations distribution of a mini-batch is called *batch
normalization*, which applies a gaussian normalization (standardization) to it:

$
  mu_B = 1 / N_B sum_(i=1)^(N_B) h_i, quad
  sigma_B^2 = 1 / N_B sum_(i=1)^(N_B) (h_i - mu_B)^2 \
  hat(h)_i = frac(h_i - mu_B, sqrt(sigma_B^2 + epsilon))
$

This process changes activations in order to have mean $0$ and variance $1$.
What can be done after is to rescale and shift the normalized activations with
learnable parameters $gamma$ and $beta$:

$ h_i' = gamma hat(h)_i + beta $

so that the network can decide either to keep activations normalized, bring
everything back or a compromise between the two.

This is a common technique that often improves optimization and stability during
training.

== Residual Connections

A common trick used especially in very deep networks is the *residual
connection*, which adds a connection that jumps one or more layers in order to
propagate the input as it is even in deeper layers.

In other words the network doesn't have to try to learn

$ y = G(x) $

but more something like

$ y = F(x) + x $

The intuition behind this is that if the transformation to be learned is similar
to the identity, the network must learn only the difference.

The more interesting aspect of this implementation is related to gradients and
backpropagation, in fact is also a counter-measure (in some sense) to gradient
vanish. If the output is

$ y = F(x) + x $

than its gradient is

$ pdv(y, x) = I + pdv(F, x) $

that in backpropagation means that

$ pdv(L, x) = pdv(L, y) (I + pdv(F, x)) $

So if $pdv(F, x)$ vanish, there is always a strong term $pdv(L, y)$ that instead
is backpropagated.

= Advanced Convolutions

There are cases in which data has temporal meaning, therefore we might not want
to look in the future of a sequence. This brings the idea of *causal
convolutions* in which output at time $t$ depends only on positions up to $t$.

Another similar idea similar to causal convolutions is called *dilated
convolutions*, which enlarge the receptive field faster. It basically inserts
gaps between kernel elements with a *dilation factor* $d$:

$ (vb(x) convolve_d vb(K)) (i, j) = sum_m sum_n x(i + d m, j + d n) K(m, n) $

The result is similar to increase the stride without reducing the feature map
dimensionality and without increasing the number of parameters.
