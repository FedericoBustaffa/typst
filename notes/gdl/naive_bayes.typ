#import "@local/note_template:0.1.0": *
#show: doc => note_template([Naive Bayes], doc)

#title()

The *Naive Bayes* model is maybe the simplest probabilistic model that can be
used in classical ML tasks like classification or in an _agent-based_
environment to make the agent _reason under uncertainty_.

Usually in a ML context, the goal is to represent the _joint distribution_ of a
set of random variables, typically something that can intuitively seen as

$ P ("causes" , "effects") $

Let's imagine to be a doctor and have to diagnose influence just by knowing

- The prior probability of get influence $I$.
- The conditional probability of having the influence, knowing three possible
  symptoms: fever $F$, cough $C$ and muscle pain $M$.

Assume also that every variable is observed for every patient. In other words
the dataset is composed by 3D vectors, with every component that can be $0$ or
$1$.

A patient come and presents all three symptoms, so we have to compute

$ P(I | F, C, M) $

By applying the Bayes rule we obtain

$
  P(I | F, C, M) = (P(F, C, M | I) dot P(I)) / P(F, C, M) =
  (P(F, C, M, I)) / P(F, C, M)
$

Now we can just look at the joint probabilities of numerator and denominator to
obtain the probability of that patient to have gotten the influence:

$
  P(I | F, C, M) = (P(F, C, M, I)) / P(F, C, M) =
  (P(F, C, M, I)) / (P(F, C, M, not I) + P(F, C, M, I))
$

This is the pure statistic approach where we basically model the joint
distribution of every possible outcome of the three variables and the class
together, assuming a possible dependency between them. The result is a table
with $2^4 = 16$ rows (since we have binary variables and label).

= Observed Variables

The Naive Bayes model assumes conditional independence among the symptoms, given
the cause (in this case $I$), so now the conditional probability of

$
  P(I | F, C, M) & = (P(F, C, M | I) dot P(I)) / P(F, C, M) \
                 & = (P(F | I) dot P(C | I) dot P(M | I) dot P(I)) / P(F, C, M)
$

so now we need the different conditional probabilities at the numerator that can
be modelled independently from other effects. This means for example modelling
$P(F | I)$ like

#align(center, grid(
  columns: 3,
  gutter: 0.5cm,
  {
    table(
      columns: 2,
      align: center,
      [$F$], [$P(F | I)$],
      [$0$], [$0.7$],
      [$1$], [$0.05$],
    )
  },
  {
    table(
      columns: 2,
      align: center,
      [$C$], [$P(C | I)$],
      [$0$], [$0.1$],
      [$1$], [$0.01$],
    )
  },
  {
    table(
      columns: 2,
      align: center,
      [$M$], [$P(M | I)$],
      [$0$], [$0.8$],
      [$1$], [$0.2$],
    )
  },
))

Of course we don't need to represent everything because half of the table is
easily derivable. Another more compact representation is by a *graph* where
there is a node that is the _cause_ and its children the effects:

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (I, F, C, M) = ((0, 0), (-1, 1), (0, 1), (1, 1))
      node(I, [$I$])
      node(F, [$F$])
      node(C, [$C$])
      node(M, [$M$])

      edge(I, "->", F)
      edge(I, "->", C)
      edge(I, "->", M)
    },
  ),
  caption: "Discrete Time Markov Chain",
) <fig-dtmc>

So now instead of having one big table we have $3$ tables of $2$ rows and one
table containing the marginal probability of the cause ($I$) of one row, for a
total of $7$ rows.

It seems nothing but scaled with many variables can largly reduce the
computational cost. Just to have an idea, the same problem but with $20$
possible symptoms, in the first case is modelled by a table of $2^21$ rows
(greater than $2.000.000$), while the Naive Bayes just uses $20$ tables of $2$
rows each, for a total of $41$ rows (also considering the prior of $I$).

Of course the conditional independence assumption is an approximation of the
real world so also the probabilities can change, but typically, for this kind of
problem Naive Bayes works well.

= Hidden Variables

Can also happen that one or more variables are *hidden*, for example a patient
comes with only two specified symptoms instead of three. So now for example we
have to compute

$ P(I | F, C) = (P(F, C | I) dot P(I)) / P(F, C) $

that without Naive Bayes assumption is

$ P(I | F, C) = P(F, C, I) / P(F, C) $

but in the model we built before we don't have these joint probabilities, and so
we need to marginalize the hidden one (in this case $M$).

$ P(F, C, I) = sum_m P(F, C, I, M = m) $

and also for the denominator

$ P(F, C) = sum_i sum_m P(I = i, F, C, M = m) $

Under the Naive Bayes assumptions instead we don't even have to marginalize

$
  P(I | F, C) & = (P(F, C | I) dot P(I)) / P(F, C) \
              & = (P(F | I) dot P(C | I) dot P(I)) / P(F, C)
$

because the marginalization of $M$ simplifies

$ sum_m P(M = m | I) = 1 $

while at the denominator we still have to marginalize but only for values of
$I$, because now, under the assumptions of conditional independence we have

$ P(F, C) = sum_i sum_m P(I = i, F, C, M = m) $

and expand it, we obtain

$
  P(F, C) & = sum_i sum_m P(I = i, F, C, M = m) \
          & = P(I = 0, F, C, M = 0) + P(I = 0, F, C, M = 1) \
          & P(I = 1, F, C, M = 0) + P(I = 1, F, C, M = 1) \
$

but as long as the factored representation of the joint distribution is

$ P(F | I) dot P(C | I) dot P(M | I) dot P(I) $

the actual denominator is just

$ P(F, C) = sum_i P(I = i, F, C) $

for a final conditional probability

$ P(I | F, C) = (P(F | I) dot P(C | I) dot P(I)) / (sum_i P(I = i, F, C)) $

So in practice, the Naive Bayes handles well cases were there are hidden
variables by marginalization and conditional independence.

= Joint Distribution Representation

The key concept to understand is the *joint distribution representation*; a
probabilistic model make assumptions on the joint distribution in order to make
inference and reduce the amount of computation.

In practice for the previous example of influence, without any prior knowledge
we cannot (at least not easily) assume conditional independence between two
variables from data.

Let's take the previous problem, without prior knowledge we cannot assume
conditional independence given the cause. This means that knowing the patient
has influence does not automatically means that symptoms are independent from
each other.

Without observing anything we only have marginal probabilities, but if we
observe fever, the probability of influence grows and if it grows, also the
probability of cough grows. In this case we can say that fever and cough are
marginally dependent.

By looking instead at the cause we can say that if the patient has influence and
the influence causes fever, what can we say about cough? Maybe the fever can
directly cause cough or maybe there is an hidden and *unmodeled variable* that
relates fever to cough. In this case there is no conditional independence among
effects given the cause.

The Naive Bayes assumes there is conditional independence even if in the real
world there is some form of dependence. In this case, knowing the patient has
influence explains the fever and the cough independently. So now we only need to
know if the patient has influence to know the probability for him to have cough
or fever.

In this sense Naive Bayes makes a mistake on the real joint distribution in
order to model less possible worlds. Anyway, even if it results more _corse
grained_ in modelling the world, it often works quite well in many scenarios.
