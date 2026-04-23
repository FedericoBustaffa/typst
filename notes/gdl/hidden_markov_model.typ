#import "@local/note_template:0.1.0": *
#show: doc => note_template([Hidden Markov Model], doc)

#title()

A probabilistic model for sequential data that is an evolution of Markov chains
is the *hidden Markov model (HMM)*, which is designed to find latent structures
in sequences.

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

