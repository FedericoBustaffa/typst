#import "@local/note_template:0.1.0": *
#show: doc => note_template([Causal Models], doc)

#title()

There are cases were we need to model *causality* over *independence*, and this
can be done by *causal models*. A little bit more formally we can say that a
random variable *causes* another if a _*manipulation*_ on the former alters the
distribution of the latter. A direct consequence of this is that a set of
completely different _causal structures_ can entail the same set of conditional
independences and dependences.

#important(title: [Reichenbach's Common Cause Principle])[
  Let $X$ and $Y$ be two variables such that $X$ and $Y$ are statistically
  dependent, then it holds:

  - $X$ is indirectly causing $Y$, or
  - $Y$ is indirectly causing $X$, or
  - There is a possibly unobserved common cause $Z$ that indirectly causes both
    $X$ and $Y$.
]

The principal assumes that we can perfectly identify stastical dependence from
data, but in general a special care is needed to work correctly.

A *causal model* represent _causal relations_ and the results of
*interventions* among random variables. While different probabilistic models can
express the same conditional distributions, different causal models entail
different *interventional distributions*.

An example of causal model are *causal bayesian networks*, that are bayesian
networks but now the edge direction represents causality.

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (Y1, Y2, Y3) = ((0, 0), (1, 0), (2, 0))
      node(Y1, [$Y_1$], fill: color.aqua)
      node(Y2, [$Y_2$], fill: color.aqua)
      node(Y3, [$Y_3$], fill: color.aqua)

      edge(Y1, "-|>", Y2)
      edge(Y2, "-|>", Y3)

      let (Y1, Y2, Y3) = ((0, 1), (1, 1), (2, 1))
      node(Y1, [$Y_1$], fill: color.aqua)
      node(Y2, [$Y_2$], fill: color.aqua)
      node(Y3, [$Y_3$], fill: color.aqua)

      edge(Y2, "-|>", Y1)
      edge(Y3, "-|>", Y2)
    },
  ),
  caption: [ Causal Bayesian Networks ],
) <fig-causal-bayesian-net>

For example in @fig-causal-bayesian-net, $Y_1 --> Y_2$ means that $Y_1$ directly
causes $Y_2$. Let's also point out that the two graphs represent the same
bayesian network but different causal bayesian networks.

= Hard Interventions

Given a variable $Y$ and a value $k$, we denote an *hard intervention* as

$ "do"(Y := k) $

The intervention replaces the variable of the model with the constant value

$ P(Y_2 | Y_1 = k) != P(Y_2 | "do"(Y_1 := k)) $

Of course in this case we are still interested in representing a joint
distribution but now we have to deal with an *joint interventional
distribution*, that can be defined with a set of variables $V$ and a set of
values $k$ such that

$
  P(Y_1, dots, Y_n | "do"(V := k)) =
  product_(Y_i in.not V) P(Y_i | "Pa"(Y_i)) dot product_(Y_j in V) II (Y_j = k_j)
$

where $II (Y_j = k_j)$ is a boolean value that is true when the assignment is
true, so that the resulting joint distribution has probability $0$ if the
assignment are not respected. This basically means that a wrong assignment
should not exists.

= Causal Identifiability

A useful tool to study *causal effects* is the *average treatment effect*,
defined as the difference of expectations of a variable, given an intervention
to another variable

$ "ATE"(Y_1, Y_2) = EE [Y_2 | "do"(Y_1 := T)] - EE [Y_2 | "do"(Y_1 := F)] $

with $Y_1$, a binary treatment variable $Y_1$ and an outcome variable $Y_2$. In
order to estimate the ATE of a treatment of an outcome is fundamental to
distinguish between _conditioning_ and _intervening_ on random variables, and in
general, conditionining is not a measure of causal effect.

#figure(
  diagram(
    node-shape: "rect",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (R, V, I, A) = ((0, 0), (-0.75, 1), (0.75, 1), (0, 2))
      node(R, [Region], fill: color.aqua)
      node(V, [Vaccine], fill: color.aqua)
      node(I, [Infection], fill: color.aqua)
      node(A, [Arm Pain], fill: color.aqua)

      edge(R, "-|>", V)
      edge(R, "-|>", I)
      edge(V, "-|>", I)
      edge(V, "-|>", A)
    },
  ),
  caption: [ Conditioning $!=$ Intervening ],
) <fig-conditioning-intervening>

Observing a painful arm increase the probability of observing an infection,
because

$ EE [I | A = 1] - EE [I | A = 0] > 0 $

but punching an arm does not increase the same probability:

$ EE [I | "do"(A := 1)] - EE [I | "do"(A := 0)] = 0 $

Because the two expectations are the same. In general to answer the second type
of question we need to identify the causal effect.

#important(title: [Identifiable Causal Effect])[
  The causal effect of a treatment $Y_1$ on an outcome $Y_2$ is *identifiable*
  whenever there exists an *adjustment set* $Z$ such that
  $ P(Y_2 | "do"(Y_1)) = P(Y_2 | Y_1, Z) $
]

To find adjustment sets we can exploit:

- The *do-calculus*: a complete system.
- The *back-door* criterion to handle observable confounders.
- The *front-door* adjustment to handle latent confounders.

Another property introduced by causal models is *sufficiency* that is sufficient
but not necessary to identify causality.

#important(title: [Causal Sufficiency])[
  A causal model is *causally sufficient* whenever

  - All confounders are observed.
  - There is no selection bias in the data.
]

As for Markov property and faithfulness, it is an assumption on our model.

== Back-Door Adjustment

In the *back-door adjustment* a set of variables $Z$ satisifies the *back-door
criterion* for the causal effect of $Y_1$ on $Y_2$ if

- No node in $Z$ descends from $Y_1$.
- $Z$ blocks every path between $Y_1$ and $Y_2$ that contains an edge entering
  $Y_1$

then it holds

$ P(Y_2 | "do"(Y_1)) = sum_z P(Y_2 | Y_1, Z = z) P(Z = z) $

#figure(
  image("images/back-door.png", width: 40%),
  caption: [ Back-Door Adjustment ],
)

The back-door criterion defines some but not all adjustments sets so it's
*correct* but *not complete*. Different adjustments lead to different
*asymptotic variance* of the ATE estimator.

In a know graph the *optimal adjustment set* is

$ *O*(X, Y) = "Pa"("Med"(X, Y)) backslash ("Med"(X, Y) union {X}) $

where $"Med"(X, Y)$ is the set of *mediators* from $X$ to $Y$, including $Y$ but
excluding $X$.

== Front-Door Adjustment

In the *front-door adjustment* a set of variables $Z$ satisfies the *front-door
criterion* for the causal effect of $Y_1$ on $Y_2$ if

- $Z$ intercepts all directed paths from $Y_1$ to $Y_2$.
- There is no unblocked back-door path from $Y_1$ to $Z$.
- All back-door paths from $Z$ to $Y_2$ are blocked by $Y_1$

then it holds

$
  P(Y_2 | "do"(Y_1)) =
  sum_z P(Z = z | Y_1) sum_y'_1 P(Y_2 | Y_1 = y'_1, Z = z) P(Y_1 = y'_1)
$

#figure(
  image("images/front-door.png", width: 30%),
  caption: [ Front-Door Adjustment ],
)

= Structural Causal Models

There are cases when is natural to make queries we retrospectively reason on
alternative outcomes after an intervention (*counterfactual queries*). Questions
in the form of "what if the intervention would have been another one?"; bayesian
networks cannot answer to counterfactual queries and so we need to introduce
*structural causal models*.

$ M = (Y, U, f, P(U)) $

specifies the *deterministic mechanism* $f$ of a set of *endogenous variables*
$Y$ given a set of *exogenous variables* $U$ with distribution $P(U)$. Formally

$ Y_j = f_j (Y_"Pa"(Y_j), U_j) $

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (Y1, Y2, Y3, U1, U2, U3) = (
        (0, 0),
        (1, 0),
        (2, 0),
        (0, 0.85),
        (1, 0.85),
        (2, 0.85),
      )
      node(Y1, [$Y_1$], fill: color.aqua)
      node(Y2, [$Y_2$], fill: color.aqua)
      node(Y3, [$Y_3$], fill: color.aqua)

      node(U1, [$U_1$])
      node(U2, [$U_2$])
      node(U3, [$U_3$])

      edge(Y1, "-|>", Y2)
      edge(Y2, "-|>", Y3)
      edge(Y1, "-|>", Y3, bend: 50deg)

      edge(U1, "-|>", Y1)
      edge(U2, "-|>", Y2)
      edge(U3, "-|>", Y3)
    },
  ),
  caption: [ Structuiral Causal Model ],
) <fig-structural-causal-models>

A specific instance of SCM is the *linear additive noise model (ANM)*, where the
functional mechanisms are linear. Formally, given a matrix $W in RR^(n times
n)$,


$ Y_j = sum_(Y_i in "Pa"(Y_j)) w_(i j) Y_i + U_j $

#figure(
  diagram(
    node-shape: "circle",
    node-stroke: 1pt,
    edge-stroke: 1pt,
    {
      let (Y1, Y2, Y3, U1, U2, U3) = (
        (0, 0),
        (1, 0),
        (2, 0),
        (0, 1),
        (1, 1),
        (2, 1),
      )
      node(Y1, [$Y_1$], fill: color.aqua)
      node(Y2, [$Y_2$], fill: color.aqua)
      node(Y3, [$Y_3$], fill: color.aqua)

      node(U1, [$U_1$])
      node(U2, [$U_2$])
      node(U3, [$U_3$])

      edge(Y1, "-|>", Y2, $w_(1 2)$)
      edge(Y2, "-|>", Y3, $w_(2 3)$)
      edge(Y1, "-|>", Y3, $w_(1 3)$, bend: 50deg)

      edge(U1, "-|>", Y1, $1$)
      edge(U2, "-|>", Y2, $1$)
      edge(U3, "-|>", Y3, $1$)
    },
  ),
  caption: [ Linear Additive Noise Model ],
) <fig-linear-additive-noise-model>

Given a fully specified SCM, we can directly compute counterfactuals using the
following procedure:

+ *Abduction*: update the exogenous distribution $P(U | Y)$ given the evidence
  $Y$.
+ *Action*: intervene on the treatment applying $"do"(Y_1)$ on the SCM.
+ *Prediction*: infer the probability of the outcome given the new treatment as
  in
  $ P (Y_2 | "do"(Y_1), U) dot P(U | Y) $

In other words, these models are capable of changing a variable in the past,
reusing the same _world_.
