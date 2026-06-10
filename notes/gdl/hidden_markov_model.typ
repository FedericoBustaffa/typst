#import "@local/note_template:0.1.0": *
#show: doc => note_template([Hidden Markov Model], doc)

#title()

A probabilistic model for sequential data that is an evolution of Markov chains
is the *hidden Markov model (HMM)*, which is designed to find latent structures
in sequences.

= Markov Chain

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
  The current state only depends on the previous.
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

      edge(a, "-|>", b, bend: 10deg)
      edge(b, "-|>", a, bend: 10deg)
      edge(b, "-|>", c, bend: 10deg)
      edge(c, "-|>", b, bend: 10deg)
      edge(c, "-|>", a, bend: 10deg)
      edge(a, "-|>", c, bend: 10deg)
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

= Structure

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

= Generative Process

For simplicity we can think that everything is modelled by multinomial
disitributions. There is one multinomial that generates latent states, then
depending on the sampled latent, another multinomial is selected to generate an
observable.

+ Generate the first latent state $S_1 tilde P(S_1)$.
+ Use it to generate the first observable $Y_1 tilde P(Y_1 | S_1)$.
+ Iteratively repeat
  - Use the previous hidden state to sample the next $S_i tilde P(S_i |
      S_(i-1))$.
  - Use the sampled hidden state to _emit_ new observables $Y_i tilde P(Y_i |
      S_i)$.

Only the first hidden state is sampled independently from everything else.

