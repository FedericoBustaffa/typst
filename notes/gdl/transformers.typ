#import "@local/note_template:0.1.0": *
#show: doc => note_template([Transformers], doc)

#title()

One of the most popular deep learning architecture, used to solve many problems
from sequence modelling to image processing is the *transformer*, which are
entirely based on attention.

In particular they use a special type of attention, called *self attention*,
which is very powerful to obtain meaningful representation, high expressive
power, low inductive bias and massive parallelization.

Considering in particular the recurrent encoder-decoder architecture with
attention, we can say that it solve the problem for which a global context is
biased towards the last processed sequence token.

However the model is still biased towards the idea that sequences are generated
following some recurrent time dynamic. Same thing for a CNN, which assumes that
images have some strong spatial local properties.

Transformers can catch global dependencies with a weight sharing mechanism
fusing what MLPs are good at with higher-inductive bias models like RNNs and
CNNs.

= Self Attention

The *self attention* mechanism wants to catch global dependencies directly from
input data, while maintaing the process parallelizable.

The first conceptual shift is that in recurrent encoder-decoder architecture,
attention is used to build a context. In general we can use attention to build
feature-rich *embeddings*.

The core building block is the introduction of three projections: *queries*,
*keys* and *values*. Given an input token embedding $x_i in RR^D$ we compute
three vectors

$ q_i = Omega_q x_i quad quad k_i = Omega_k x_i quad quad v_i = Omega_v x_i $

where

$
  Omega_q in RR^(d_k times D) quad quad
  Omega_k in RR^(d_k times D) quad quad
  Omega_v in RR^(d_v times D)
$

Queries and keys must have compatible sizes since they are meant to be paired:
queries ask what kind of contextual information the current token is looking
for, while keys are the contextual information exposed by that token.

They are separated because they model asymmetric queries, one token can query
another one, but the other one may not be interested in the starting token
exposed information.

Values are instead very similar in meaning to the old $h_i$ for recurrent
models, with the core difference that they are not influenced by previous
states and the corresponding projection does not model any time dynamic, the
only input is the plain token $x_i$.

== Scores

Queries and keys are used to build the scores by simply using the dot product:

$ e_(i j) = q_i^TT k_j $

which as we can see models compatibility between token $i$ and token $j$. A
simple schematic way to visualize it is that a token $x_i$ looks for some
information through the query $q_i$ and every other token $x_j$ exposes its key
$k_j$; intuitively the ones with higher values are the more compatible and so
higher score.

A nice common adjustment to make training more stable is to use another
formulation that scales the dot product as

$ e_(i j) = frac(q_i^TT k_j, sqrt(d_k)) $

which prevents the computation to produce values that are too large in
magnitude. The thing is that $q_i$ and $k_j$ are generally independent and so
with non negligible variance value, which cause the dot product to grow
proportionally with $d_k$. The scaling makes the the variance independent from
$d_k$.

== Softmax

The next step is to compute the softmax as usual using scores:

$
  alpha_(i j) =
  frac(
    exp(q_i^TT k_j slash sqrt(d_k)),
    sum_(l=1)^N exp(q_i^TT k_l slash sqrt(d_k))
  )
$

that are the usual attention weights.

== Aggregation

The aggregation mechanism takes in input the values $v_j$ produced by the
$Omega_v$ projection and rescales them by the attention weights $alpha_(i j)$

$ alpha_(i j) v_j $

and produce a context relative to token $x_i$ by sum

$ c_i = sum_(j=1)^N alpha_(i j) v_j $

This is actually a *contextual embedding* of the token $i$.

Putting all together in an expanded formula let us rewrite

$
  c_i = sum_(j=1)^N
  frac(
    exp(q_i^TT k_j slash sqrt(d_k)),
    sum_(l=1)^N exp(q_i^TT k_l slash sqrt(d_k))
  )
  v_j
$

== Matrix Form

A particularly elegant and compact formulation of self attention is *matricial
form*. Let

$ X in RR^(N times D) $

a full sequence of $N$ tokens and $D$ features. Then we can also have queries,
keys and value represented as

$ Q = X W_Q quad quad K = X W_K quad quad V = X W_V $

with

$
  W_Q in RR^(D times d_k) quad quad
  W_K in RR^(D times d_k) quad quad
  W_V in RR^(D times d_v)
$

Therefore, the full attention weights matrix becomes

$ A = "softmax"(frac(Q K^TT, sqrt(d_k))) $

where the softmax is applied row-wise. The final contextual embedding output
matrix can be written as

$ C = A V $

leading to the formulation of the famouse formulation

$ "Attention"(Q, K, V) = "softmax"(frac(Q K^TT, sqrt(d_k))) V $

showing why everything is parallelizable on many levels like token processing or
more fine-grained like with the scores computation.

== Contextual Embeddings

The main novelty with self attention is that for sequence modelling we are not
interested in a compressed representation of the history.

Self attention computes embeddings for each token in the sequence, making it
interact with every other token directly, solving the problem of capturing
long-range dependencies.

== Multi-Head Attention

We can think of one attention module (head) as a neuron of an attention layer,
so we can compose multiple attention heads (*multi-head attention*) in order to
capture different types of features.

Since self attetion is memory consuming there are many flavours of attention
which reduce the number of keys and values stored grouping them among different
elements, losing expressive power.

= Model Architecture

The original transformer architecture is still of the type *encoder-decoder* but
not recurrent or convolutional.

#figure(
  image("images/transformer.webp", width: 50%),
  caption: [ Transformer ],
)


Each component is built from attention and
feedforward layers.

== Encoder

Given an input sequence $X in RR^(N times D)$, one encoder block performs

+ Multihead self attention $ H = "MultiHead"(X) $
+ Residual connection and layer normalization
  $ H' = "LayerNorm"(X + H) $
  where
  $ "LayerNorm"(x) = frac(x - mu, sqrt(sigma^2 + epsilon)) dot.o gamma + beta $
  where $mu$ and $sigma$ are computed per input.
+ Position-wise feedforward
  $ Z = "FFN"(H') $
  where a typical feedforward implementation is
  $ "FFN"(x) = W_2 phi.alt (W_1 x + b_1) + b_2 $
+ Another residual connection and layer normalization
  $ Y = "LayerNorm"(H' + Z) $

== Decoder

The decoder works similary but with *masked self attention* to enforce
causality by not looking into the future. The masking is implemented my a matrix
$M$ structured as follows

$
  M_(i j) = cases(
    0 & " if " j <= i,
    1 & " if " j > i
  )
$

In this way future positions receive zero probability from the softmax.
Therefore the self attention module becomes

$ "Attention"(Q, K, V) = "softmax"(frac(Q K^TT + M, sqrt(d_k))) V $

The self attention is used over previous output tokens, while, in order to
relate encoder representations with decoder outputs.
