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
easily derivable.

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
