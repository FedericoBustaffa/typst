#import "@local/note_template:0.1.0": *
#show: doc => note_template([Recurrent Neural Networks], doc)

#title()

One of the most famous models to process sequential data is the *recurrent
neural network (RNN)*, which takes in input some sequence

$ vb(x) = vecrow(x_1, dots, x_T) $

with each element $x_i in RR^m$. The dataset is composed by sequences that could
have different lenghts $T$ and this, similarly to CNNs is simply addressed by
*weight sharing*.

The insight of RNNs is that a sequence element $x_t$ is dependent on the past in
some way and RNNs try to summarize this past by a set of layer activations. In
particular the activation $h_t$ at time $t$ will summarize relevant information
in $x_1, dots, x_t$.

The problem of this approach could be that with a long sequence, the model could
try to capture and retain so many information about the past that in the end,
$h_t$ will be non that informative.

= Sequential Data Processing

Since RNNs architecture introduces new dynamics of data processing, also the
possible tasks increased:

- *Sequence-to-sequence*: map an input sequence to an output sequence.
- *Sequence-to-item*: produce a prediction after seeing a full sequence.
- *Item-to-sequence*: generate a sequence from a single input.
- *Item-to-item*: output one prediction per input step.

In this sense an RNN is *dynamical system* that evolves under influence of both
the past state and the current input.

= Vanilla Recurrent Neural Network

In the most simple formulation of RNN we can think about a very simple setting
in which the same linear layer and nonlinearity are applied to every sequence
element, producing an hidden state representation. For the first element of the
sequence is just

$ h_1 = tanh(W_"in" x_1 + b) $

Now we want to do the same with the next element of the sequence, but this time
making it dependent on the previous element hidden representation:

$ h_2 = tanh(W_h h_1 + W_"in" x_2 + b_h) $

A general formulation for hidden states updates is

$ h_t = tanh(W_h h_(t-1) + W_"in" x_t + b_h) $

with $h_0$ usually being a zero vector. Another thing we might want is to
produce an output at every step, but this is interesting only for tasks like
sequence labelling:

$ y_t = f(W_"out" h_t + b_"out") $

For sequence classification or regression instead we just need the hidden
representation $h_t$ at each step, the last step will produce $y$ based on the
whole story summary and the last sequence element:

$ y = f(W_"out" h_T + b_"out") $

It's important to notice that at each time step $W_h$ and $W_"in"$ are reused
(weight sharing) to produce a fixed size representation of the past, imposing a
form of *time-stationarity* dynamics. In other words the network assumes that
even if based on different data or past compressed representation, at each time
step, the _transition dynamics_ are the same.

This also gives us another insight: a simple neural layer followed by a
nonlinearity, applied repeatedly to each element of the sequence can be
_unrolled_ and be seen as a sort of deep MLP. In other words RNNs exhibit deep
learning dynamics even with just one recurrent layer.

= Backpropagation Through Time

To train these networks we need to account for weight sharing, so even if an
unrolled recurrent layer seems like an MLP, we have to take into account that
the weights at each level are the same.

Also we need to take into account the error contribution of each intermediate
hidden representation. One common approach is called *backpropagation through
time (BPTT)* that simply perform the complete forward step and the backward
update weights only when the first element of the sequence is reached.

// Let's assume to have a sequence of length $T=2$ of scalars:
//
// $ vb(x) = vec(x_1, x_2) $
//
// The linear layer is a scalar as well, so first element produces the hidden state
//
// $ h_1 = tanh(W_"in" x_1 + b_h) $
//
// that is also a scalar. The second element produces instead
//
// $ h_2 = tanh(W_h h_1 + W_"in" x_2 + b_h) $
//
// that in the end is used to produce an output
//
// $ y = f(W_"out" h_2 + b_"out") $
//
// As usual we can apply a loss function in the end:
//
// $ e = cal(L) (y) $
//
// Now we can backpropagate almost as usual to update $W_"out"$ and $b_"out"$
//
// $
//   pdv(cal(L), W_"out") = pdv(cal(L), f) pdv(f, "net"_"out")
//   pdv("net"_"out", W_"out")
// $
//
// that if $f$ is just the identity simply becomes
//
// $ pdv(cal(L), W_"out") = delta h_2 quad quad pdv(cal(L), b_"out") = delta $
//
// But the interesting part is how to update the time dynamics parameters $W_h$ and
// $b_h$ and this come from the fact that the final error also depends on $h_2$, in
// fact we can write
//
// $
//   pdv(cal(L), h_2) = pdv(cal(L), "net"_"out") pdv("net"_"out", h_2) = delta W_"out"
// $
//
// that we can call $delta_2$ and compute notice that

In this way we can apply backpropagation on the unrolled computational graph and
since the same parameters are reused at every step, the total gradient is a sum
of contributions from all time positions. In general, accounting for possible
tasks, we have that if a loss occurs at time $t$, the gradient w.r.t. to
recurrent parameters has the form

$
  pdv(cal(L)_t, W_h) = sum_(k=1)^t pdv(cal(L)_t, h_t) pdv(h_t, h_k) pdv(h_k, W_h)
$

where the key term is the one the middle because it measures how a perturbation
in the hidden state at time $k$ influences the hidden state at time $t$.
Actually after repeated application of the chain rule we have something like

$
  pdv(h_t, h_k) = pdv(h_t, h_(t-1)) pdv(h_(t-1), h_(t-2)) dots.c
  pdv(h_(k+1), h_k)
$

thus the gradient is governed by a product of many Jacobians.

It's clear from this perspective that if an error occurred at time $t$ but we
need to give credit to the hidden state or input at time $k << t$, this long
product of Jacobians can be a problem. This is because retaining information for
long time can become harder and harder since the hidden representation is finite
and has to summarize not only what happened at time $k$ but also everything
before.

= Jacobians in Recurrent Networks

A way to better analyze the situation is by considering the state

$ h_(t+1) = f(h_t, x_(t+1)) = phi.alt(W_h h_t + W_"in" x_(t+1) + b_h) $

The Jacobian w.r.t. the previous hidden state is

$ pdv(h_(t+1), h_t) = D_(t+1) W_h $

Let's focus on the activations Jacobian

$ D_(t+1) = diag(phi.alt'(g_(t+1, 1)), dots, phi.alt'(g_(t+1, m))) $

is a diagonal matrix containing the derivatives of the activation function at
time $t+1$. A common activation function in RRNs is the $tanh$, whose derivative
is

$ tanh'(x) = 1 - tanh^2 (x) $

and since this quantity is between $0$ and $1$, the $tanh$ activation is always
contractive, causing the gradients to *shrink*.

Similar reasoning for the case in which the previously seen large product of
Jacobians

$
  pdv(h_t, h_k) = pdv(h_t, h_(t-1)) pdv(h_(t-1), h_(t-2)) dots.c
  pdv(h_(k+1), h_k)
$

is consistently smaller than $1$; also in that case we can have norm
contractivity (or, if larger than $1$, norm-expansion) causing _gradient vanish_
(or _gradient exploding_).


== Bounding the Gradient

So makes sense to study the gradient to find a way to avoid those scenarios:

$
  pdv(cal(L)_t, h_k) = pdv(cal(L)_t, h_t) product_(l=k)^(t-1) pdv(h_(l+1), h_l)
  = pdv(cal(L)_t, h_t) product_(l=k)^(t-1) D_(l+1) W_h
$

A common way to study the gradient flow is based on *spectral properties* of the
Jacobians involved, so let's take the norm and see that

$
  norm(pdv(cal(L)_t, h_k)) & <=
  norm(pdv(cal(L)_t, h_t)) product_(l=k)^(t-1) norm(D_(l+1)) norm(W_h) \
  & approx norm(pdv(cal(L)_t, h_t)) norm(D)^(k-1) norm(W_h)^(k-1)
  approx norm(pdv(cal(L)_t, h_t)) rho(D)^(k-1) rho(W_h)^(k-1)
$

In general we have that after many steps, if the dominant singular values of
these Jacobians are consistently below 1, then the product is contractive, if
instead is greater than $1$, gradients tend to quickly grow.

The spectral radius of the Jacobian (the maximum eigenvalue) tells us how fast
the function grows in the direction of maximum growth.

The ideal scenario for error propagation in long-term learning is to avoid as
much as possible vanish or explosion of gradients. This can be achieved if

$ norm(pdv(h_(l+1), h_l)) approx 1 $

One way is to avoid using sigmoidal activations and just use the identity, that
will make the Jacobian become

$ pdv(h_(t+1), h_t) = W_h $

that lacks that extra diagonal shrinkage term that causes the gradient to vanish.

Another way is to choose a matrix of weights with nice properties like an
orthogonal one:

$ W_h^TT W_h = I $

and its singular values are all exactly $1$. For example with identity
activation and identity recurrence matrix we have

$ h_t = h_t + x_t $

and so the corresponding Jacobian is again

$ pdv(h_t, h_(t-1)) = I $

and so also

$ pdv(h_t, h_k) quad forall k < t $

Under the conditions of identity activation and orthogonal recurrence matrix,
the state transition function is norm preserving but in the meanwhile we lost a
lost of expressive power and now each state $h_t$ tends to contain everything,
since it does not have a way to efficiently discard irrilevant and redundant
informations.

= Forward Propagation

Another problem of RNNs is the *forward propagation* of information that can
cause long-term reasoning to fail if the information about some input fades from
the hidden state as time progresses.

The other quantity suggested to study this phenomenon is called *input
sensitivity* of the current memory to a past input, that again is studied with
the gradient:

$ pdv(h_t, x_l) = (product_(i=l+1)^t J_i) pdv(h_l, x_l) $

Where $J_i$ is the recurrent Jacobian, from which we can study the same spectral
properties as before. This time we have that singular values of $J_i$ being
lower than implies information to fade, while greater than one can cause
instability. As before the most stable and preferrable situation is to have
singular values close to $1$.

The first case in which information fades cause the memory to be *dissipative*
causing the model to forget older informations and the state become insensitive
to older inputs

$ norm(pdv(h_t, x_l)) = 0 $

On the other end, a Jacobian with large singular values can be good because it
strengthens information to travel forward. The problem is that some directions
of the space could grow so fast that the process leads to instability, also
risking to propagate noise:

$ norm(pdv(h_t, x_l)) = oo $

The desiderable regime is when memory is preserved in a stable way without
fading or become unstable.
