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

For simplicity we assume to use the model for text modelling, since it let us
work with categorical distributions only modelling $K$ possible values for
hidden states and a vocabulary of $V$ possible words.

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
  p(y, s | theta) = underbrace(p(s_1 | pi), "1st state")
  underbrace(p(y_1 | s_2, B), "1st observation")
  product_(t=2)^T p(s_t | s_(t-1), A) p(y_t | s_t, B)
$

