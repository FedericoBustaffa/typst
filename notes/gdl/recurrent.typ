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

It's important to notice that at each time step $W_h$ and $W_"in"$ are reused
(weight sharing) to produce a fixed size representation of the past, imposing a
form of *time-stationarity* dynamics. In other words the network assumes that
even if based on different data or past compressed representation, at each time
step, the _transition dynamics_ are the same.

This also gives us another insight: a simple neural layer followed by a
nonlinearity, applied repeatedly to each element of the sequence can be
_unrolled_ and be seen as a sort of deep MLP. In other words RNNs exhibit deep
learning dynamics even with just one recurrent layer.


