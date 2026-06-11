#import "@local/note_template:0.1.0": *
#show: doc => note_template([Hidden Markov Model], doc)

#title()

A direct successor of Markov chains for sequence modelling is the *hidden Markov
model (HMM)*, which uses the Markov chain as a component but this time to model
hidden states instead of observations.

This model introduces random variables assuming that there is an _hidden
process_ that regulates the generation of observations. For text in fact we do
not learn the language by memorizing which is the most probable word after a
given one, for each possible word we know.

So we need a model able to capture the underlying structure of a sequence, that
for text could be grammar or syntax structure. In this way the model can have
its own representation of nouns, verbs, adjectives and so on (hidden states),
_clustering_ each observed word, based on the previous.

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (s1, st, sT, y1, yt, yT) = (
        (0, 0),
        (1, 0),
        (2, 0),

        (0, 1),
        (1, 1),
        (2, 1),
      )

      node(s1, [$S_1$])
      node(st, [$S_t$])
      node(sT, [$S_T$])

      node(y1, [$Y_1$], fill: aqua)
      node(yt, [$Y_t$], fill: aqua)
      node(yT, [$Y_T$], fill: aqua)

      edge(s1, "-|>", st)
      edge(st, "-|>", sT)
      edge(s1, "-|>", y1)
      edge(st, "-|>", yt)
      edge(sT, "-|>", yT)
    },
  ),
  caption: [ Hidden Markov Model ],
) <fig-hmm>

The representation in @fig-hmm is actually the _unrolled_ version of an HMM,
which has a chain of hidden state that could be the same state but repeated. The
compact representation of an HMM would be like this

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let latents = (
        (0.5, 0),
        (1.5, 0),
      )
      let (s1, s2) = latents

      let observables = (
        (0, 1),
        (1, 1),
        (2, 1),
      )
      let (y1, y2, y3) = observables

      node(s1, [$S_1$])
      node(s2, [$S_2$])

      for i in range(observables.len()) {
        node(observables.at(i), [$Y_#i$], fill: aqua)
      }

      edge(s1, "-|>", s2, bend: 20deg)
      edge(s2, "-|>", s1, bend: 20deg)

      for i in range(latents.len()) {
        for j in range(observables.len()) {
          edge(latents.at(i), "-|>", observables.at(j))
        }
      }
    },
  ),
  caption: [ Hidden Markov Model (Compact) ],
) <fig-hmm2>

In this case we assumed only two possible latent variables and only three
possible observables.

As we can in see in @fig-hmm and @fig-hmm2, by focusing on the hidden state
part, we have a Markov chain, but this time is used to model hidden states
transitions. Yet it still holds the Markov assumption of Markov chains, but this
time is applied for hidden states

$ p(s_t | s_(1:t-1)) = p(s_t | s_(t-1)) $

From those hidden state an observation is _emitted_ at each time step and those
are the same observations that before composed the sequence.

= Generative Process

The generative process is not much different from a Markov chain, since HMMs are
based on it.

+ Generate the first latent state
  $ s_1 tilde "Categorical"(pi) $
+ Use the first state to condition the sampling for the next hidden state generation
  $ s_2 tilde "Categorical"(A, s_1) $
+ Use it as index to generate the first observation $y_1$ from a conditioned
  distribution
  $ y_1 tilde "Categorical"(B, s_1) $

Until the end we can use the same procedure in order to produce new hiddent
states and emitting the corresponding observations.

So this gives us the *joint probability distribution* of a sequence of states
$s$ and observations $y$:

$
  p(y, s | theta) = underbrace(p(s_1 | pi), "1st state") dot
  underbrace(p(y_1 | s_2, B), "1st observation")
  product_(t=2)^T p(s_t | s_(t-1), A) dot p(y_t | s_t, B)
$

that defines the generative process of a full sequence.

For simplicity we assume to use the model for text modelling, since it let us
work with categorical distributions only modelling $C$ possible values for
hidden states and a vocabulary of $K$ possible words:

$
  p(y, s | theta) = pi_(s_1) b_(s_1) (y_1)
  product_(t=2)^T A_(s_t s_(t-1)) b_(s t) (y_t)
$

where $b_(s_t)(y_t) = p(y_t|s_t, B)$ and $A_(s_t s_(t-1)) = p(s_t|s_(t-1), A)$.
But similarly to GMM, we are dealing with an latent state model, so the
*observed-data likelihood* is obtained by marginalization over all the latents
of the sequence:

$
  p(y | theta) = sum_s p(y, s | theta)
  = sum_(s_1 = 1)^C dots.c sum_(s_T = 1)^C pi_(s_1) b_(s_1) (y_1)
  product_(t=2)^T A_(s_t s_(t-1)) b_(s_t) (y_t)
$

But this can quickly become unfeasible for long sequences, having a time
complexity of $cal(O)(C^T)$.

= Forward-Backward

The *forward-backward* algorithm is crucial in HMM for many reasons; first of
all is divided in two main pieces

- *Forward*: efficiently computes $p(y | theta)$ in $cal(O)(T C^2)$ time, otherwise
  computed in exponential time in the sequence length.
- *Backward*: computes useful quantities for inference, like the probability of
  generating a certain _suffix_ for the given sequence, starting from the
  current time.

Both combined give the *forward-backward* algorithm implementation that is
crucial for learning.

== Forward

The *forward* algorithm uses _dynamic programming_ to ease the computation of
the likelihood at the cost of more memory usage, since it stores previously done
computation. As seen before the data likelihood is the following

$
  p(y | theta) = sum_s p(y, s | theta)
  = sum_(s_1 = 1)^C dots.c sum_(s_T = 1)^C pi_(s_1) b_(s_1) (y_1)
  product_(t=2)^T A_(s_t s_(t-1)) b_(s_t) (y_t)
$

but we can exploit the recurrent structure of the model to define a *recursive
formulation* for it, by noticing reused substructures. Let's start from the base
case of a sequence of length $T=1$, its data likelihood is

$
  p(y_1) = sum_(s_1=1)^C p(s_1) p(y_1 | s_1) = sum_(i=1)^C pi_i b_i (y_1)
  = sum_(i=1)^C alpha_1(i)
$

suppose now that we want to compute the data likelihood of a sequence of length
$T=2$, which is

$
  p(y_(1:2)) & = sum_(s_1=1)^C sum_(s_2=1)^C p(s_1) p(x_1 | s_1)
               p(s_2 | s_1) p(y_2 | s_2) \
             & = sum_(i=1)^C sum_(j=1)^C pi_i b_i (y_1) A_(j i) b_j (y_2) \
             & = sum_(j=1)^C b_j (y_2) sum_(i=1)^C alpha_1(i) A_(j i)
               = sum_(j=1)^C alpha_2 (j)
$

so we can start to find a recurrent pattern, that lets us define the following
recurrence

$
  cases(
    alpha_1 (i) = pi_i dot b_i (y_1) & "base",
    alpha_t (i) = b_i (y_t) sum_(j=1)^C A_(i j) dot alpha_(t-1) (j) & "general"
  )
$

In this way is possible to store the $alpha_t (i)$ we compute going forward in
the sequence.

== Backward

The other part of the algorithm is the *backward*, that is used to compute the
probability of generating a certain suffix, starting from the current sequence
state $s_t$.

Intuitively sounds more like an inference problem in which we are trying to
predict the next word. In fact this is similar to the posterior computation for
GMMs, that is needed, since HMM is a latent variable model, to perform learning
by _expectation maximization_.

== Smoothing

= Viterbi

= Learning
