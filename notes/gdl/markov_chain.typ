#import "@local/note_template:0.1.0": *
#show: doc => note_template([Markov Chain], doc)

#title()

In the context of HMMs, the *Markov chain* is an elementary unit, used to model
dependecies over hidden states. But let's see why Markov chains do not work as
well as HMMs for sequence modelling. If we think about a sequence like the
following

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (y1, y2, y3) = (
        (0, 1),
        (1, 1),
        (2, 1),
      )

      node(y1, [$Y_1$], fill: aqua)
      node(y2, [$Y_2$], fill: aqua)
      node(y3, [$Y_3$], fill: aqua)

      edge(y1, "-|>", y2)
      edge(y2, "-|>", y3)
    },
  ),
  caption: [ Sequence ],
) <fig-sequence>

it already represents a probabilistic model whose joint probability is trivial
if we think about the generative process and the usual BNs factorization:

$ p(y_1, y_2, y_3) = p(y_1) dot p(y_2 | y_1) dot p(y_3 | y_2) $

that, more in general becomes

$ p(y_1, dots, y_T) = p(y_1) product_(t=2)^T p(y_t | y_(t-1)) $

that is basically a *first order* Markov chain.

#note(title: "Markov Assumption (1st order)")[
  The current state only depends on the previous:
  $ p(y_t | y_(1:t-1)) = p(y_t | y_(t-1)) $
]

Be aware of the fact that usually Markov chains are not DAGs; for example a
common representation for a Markov chains with three possible states ($A$, $B$
and $C$) is

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (a, b, c) = (
        (0, 0),
        (1, 1),
        (2, 0),
      )

      node(a, [$A$])
      node(b, [$B$])
      node(c, [$C$])

      edge(a, "-|>", b, bend: 15deg)
      edge(b, "-|>", a, bend: 15deg)
      edge(b, "-|>", c, bend: 15deg)
      edge(c, "-|>", b, bend: 15deg)
      edge(c, "-|>", a, bend: 15deg)
      edge(a, "-|>", c, bend: 15deg)
    },
  ),
  caption: [ Markov Chain ],
) <fig-markov-chain>

with the possibility of transitioning from one state to another and back to an
already visited state. If we think about it's not strange since, if we associate
each state to a word of a vocabulary, the same sentence can contain the same
word multiple times.

To have a valid BN we just need to unroll the sequence, obtaining a perfectly
valid BN like in @fig-sequence.

= Generative Process

The generative process of a Markov chain is not different from any other
probabilistic model: it just generates a chain of observations, starting from an
unconditioned sampling at first.

As in models like the Naive Bayes, we can think to an observation as an index to
choose the distribution from which we want to sample the next element. In this
sense we can think about one *initial distribution* that models the probability
of each possible value being the first in the sequence. Then, for each possible
value we have a *conditioned distribution* modelling the probability of each
possible value being after the current one.

#note(title: "Transition Matrix")[
  A *transition matrix* is a compact way (squared matrix) of collecting all the
  parameters of each categorical distribution, in a such a way that each row
  describes probabilities to go from the current state to every other state.

  The initial distribution is usually not part of the transition matrix and it
  is modelled with just a vector.
]

From now on we assume to work with discrete-valued observations like words in a
sentence, all coming from a vocabulary of $K$ possible words.

In this setting the generative process is described as follow:

+ Sample the first word of the sentence from the initial distribution:
  $ p(y_1) = product_(k=1)^K pi_k^z_k $
  with $z_k = 1$ if $y_1 = k$.
+ Sample the second word using the first one as index to find the right
  distribution to sample from:
  $ p(y_2 | y_1) = product_(k=1)^K product_(s=1)^K phi.alt_(k s)^(z_(k s)) $
  with $z_(k s) = 1$ if $y_1 = k$ and $y_2 = s$.
+ Repeat the second step until the end of the sequence $y_T$.
  $ p(y_t | y_(t-1)) = product_(k=1)^K product_(s=1)^K phi.alt_(k s)^(z_(k s)) $
  with $z_(k s) = 1$ if $y_(t-1) = k$ and $y_t = s$.

Gathering all together we obtain the joint distribution for a complete sequence
$y$ as seen at the beginning.

= Learning

Now that we have the generative process and the joint distribution we can train
the model by maximum likelihood for sequence generation. The *likelihood* of the
model for a single sequence is the previously written joint distribution:

$
  p(y) = p(y_1) product_(t=2)^T p(y_t | y_(t-1))
  = product_(k=1)^K pi_k^(z_k)
  product_(t=2)^T product_(k=1)^K product_(s=1)^K phi.alt_(k s)^(z_(t k s))
$

therefore, for the whole dataset becomes

$
  P(Y) = product_(i=1)^N product_(k=1)^K pi_k^(z_(i k))
  product_(t=2)^T_i product_(k=1)^K
  product_(s=1)^K phi.alt_(k s)^(z_(i t k s))
$

and since we work with the *log-likelihood* we can write it as

$
  log P(Y) = sum_(i=1)^N sum_(k=1)^K z_(i k) log pi_k +
  sum_(i=1)^N sum_(t=2)^T_i sum_(k=1)^K
  sum_(s=1)^K z_(i t k s) log phi.alt_(k s)
$

that now can be optimized with the constraints

$ sum_(k=1)^K pi_k = 1 quad quad sum_(s=1)^K phi.alt_(k s) = 1 $

obtaining the optimal parameters

$ pi_k = c_k / N quad quad phi.alt_(k s) = c_(k s) / (sum_(s'=1)^K c_(k s')) $

= Inference

In order to do inference so generate new sequences or just predict the next
token, given an initial sequence is straightforward since we can just use the
generative process steps.

For sequence generation we can just sample a token after the other, while for
prediction we may want to just peak the most probable one.

= Limitations

The big limitation of Markov chains is that they are not able to capture any
possible underlying structure in sequences. For example in text the next word
depends not only on the previous but is based on syntax and semantics rules of
the natural language.

In order for a vanilla Markov chain to perform well a lot of samples are needed
in order to compensate the lack of general structure, typical of natural
language.
