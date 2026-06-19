#import "@local/note_template:0.1.0": *
#show: doc => note_template([Gated Recurrent Networks], doc)

#title()

The first attempt to solve the problems of vanilla RNNs, is that to introduce
*gates*: a mechanism that, at each time step decides either to forget, retain or
expose information about the past through neurons able to modulate signals.

The general idea is to have a linear neural layer followed by a sigmoid
activation function, that will produce an output $g$ in $[0, 1]$ used to regulate
another signal $s$ element-wise:

$ h = sigma(a) dot.o s = g dot.o s $

In this way is possible to modulate signals from _complete suppression_ to
_completely preservation_.

= Long Short Term Memory

The idea of gates gives birth to a more structure type of RNN, the *long short
term memory (LSTM)* model that tries to solve the problem with RNN with constant
error propagation.

#figure(
  image("images/lstm.svg", width: 80%),
  caption: [ LSTM ],
) <fig-lstm>

This design choice preserves gradients but has the problem that in the forward
direction is not selective enough to discard unrelevant of redundant
informations.

The first added gate is called *input gate* and simply modulate how much of the
current input $x_t$ and previous hidden state $h_(t-1)$ keep:

$ i_t = sigma(W_(i h) h_(t-1) + W_(i x) x_t + b_i) $

This quantity regulates in fact an intermediate memory representation called
*candidate memory*:

$ g_t = tanh(W_(g h) h_(t-1) + W_(g x) x_t + b_g) $

that basically is what in RNNs was $h_t$. So a first interesting quantity is
given by

$ i_t dot.o g_t $

The second important gate is the *forget gate* that let the network to
selectively forget unrelevant information:

$ f_t = sigma(W_(f h) h_(t-1) + W_(f x) x_t + b_f) $

This time the gate modulates a new quantity $c_(t-1)$ that is the previous
*internal memory* that now we are going to compute for the current element as

$ c_t = i_t dot.o g_t + f_t dot.o c_(t-1) $

This is very different from what happened before with gradient vanish where the
network forgets unconditionally.

The last piece, the *output gate*, _filters_ the current state memory in order
to produce the current *hidden state* $h_t$ to be exposed to the next element of
the sequence

$
  o_t & = sigma(W_(o h) h_(t-1) + W_(o x) x_t + b_o) \
  h_t & = o_t dot.o tanh(c_t)
$

Talking about gradient issues of this architecture the main goal is to see if
information can propagate properly as in constant error propagation RNNs; so we
are mostly interested in the current memory representation:

$ c_t = i_t dot.o g_t + f_t dot.o c_(t-1) $

that is clearly a combination of retained memory from previous input and new
candidate information. If we differentiate w.r.t. $c_(t-1)$

$ pdv(c_t, c_(t-1)) = diag(f_t) $

that when $f_t$ is close to one behaves like the identity

$ pdv(c_t, c_(t-1)) approx I $

Meaning that if needed, the network can propagate previous memory information
unchanged.

== Regularization

LSTMs are powerful yet prone to overfitting, especially with hidden large
capacity. The first technique to regularize the network is *dropout* that
randomly removes units during training to discourage co-adaptation. Another
similar way is *drop connect*, where individual weights are randomly suppressed.

Another regularization technique is *activity regularization* that tries to
prevent activation units saturation, enforcing the input to stay in the central
portion of the activation.

$ alpha norm(M dot.o h_t)_2^2 $

where $M$ is a mask of dropped units so that only active ones are penalized. In
a similar way is possible to have a *temporal smoothness* regularization effect:

$ beta norm(h_t - h_(t+1))_2^2 $

that encourage two consequent hidden states to be similar, giving _temporal
consistency_.

== Training Issues

The main problem with recurrent models is the computational aspect, since scales
with sequence length. Aside from mini-batch, a practical way of training these
models on long sequences is the *truncated backpropagation through time* that
truncates gradient propagation to a finite window.

The idea is process $K$ elements of the sequence, backpropagate then continue
but with updated weights. This reduce computation and memory usage at the price
of a narrower context window, that might not be able to give credits to
long-range assignments.

But we need to remember that the hidden states and memory contains summaries of
the past, so if well designed, the model might not need to look to far in the
past.

= Gated Recurrent Units

A similar gate is the *gated recurrent unit (GRU)*, that is simpler yet still
competitive gated architecture. The GRU uses only two gates, so it has less
parameters to optimize but at first glance might seem less intuitive how it
works.

#figure(
  image("images/gru.svg", width: 80%),
  caption: [ Gated Recurrent Unit ],
)

The first gate is the *update gate*

$ z_t = sigma(W_(z h) h_(t-1) + W_(z x) x_t + b_z) $

that more or less couples input and forget mechanism of LSTM. The other gate is
the *reset gate*:

$ r_t = sigma(W_(r h) h_(t-1) + W_(r x) x_t + b_r) $

that controls how strongly the past contributes when computing the new candidate
memory

$ tilde(h_t) = tanh(W_(h h) (r_t dot.o h_(t-1)) + W_(h x) x_t + b_h) $

while the actual exposed hidden state is

$ h_t = (1 - z_t) dot.o h_(t-1) + z_t dot.o tilde(h_t) $

The GRU interpretation is that we want something this time that produces an
hidden state that fuses the previous and an intermediate representation which
keeps only a portion of it. Notice also that the previous tanh is replaced by
the trick of using $z_t$ in a complementary way.

= Autoregressive Sequence Generation

In a basic autoregressive setup is possible to use gated models for *sequence
generation* by trying to predict the next element of a sequence then feeding its
own prediction back as future input.

A common technique is called *teacher forcing*: the true previous target is
provided as the next-step input. During generation, this is no longer possible,
so the model must use its own previously generated output.
