= Uncertainty
<uncertainty>
Real world problems contain #strong[uncertainty] due to partial
observability, nondeterminism or adversaries.

In large domain contexts we may fail to predict well what to do for
three main reasons:

- #strong[Laziness];: it is too much work to list the complete set of
  antecedents or consequents needed to ensure a rule without exceptions.
- #strong[Theoretical ignorance];: there is no complete theory for the
  domain.
- #strong[Practical ignorance];: even if all the rules are known,
  there’s still uncertainty due to the fact that all the necessary tests
  are not o cannot be done.

An agent has only a #emph[degree of belief] in the relevant sentences
and the rational decision depends on both the #strong[relative
importance] of various goals and the #strong[likelihood] that they will
be achieved.

== Bayesian Probability
<bayesian-probability>
In #strong[Bayesian probability theory];, probability represents an
agent’s #strong[degree of belief] of a certain set of sentences, and the
#emph[uncertainty] is summarized by a probability distribution.

In the #strong[Bayesian view] of probability there is an initial
#strong[belief] of an event (#strong[prior];) that is updated
(#strong[posterior];) based on observations (#strong[likelihood];).

More formally the #emph[prior] $P (H)$ is the initial belief on an
hypothesis, the #emph[likelihood] $P (E divides H)$ quantifies how much
the hypothesis explains the evidence, and the #emph[posterior]
$P (H divides E)$ is the updated belief after observing $E$:

$ P (H divides E) = frac(P (E divides H) dot.op P (H), P (E)) $

In this sense, this models #emph[learn] by updating their believes on
the world, not by searching for absolute truth.

An AI agent needs a preference among different possible outcomes of
various plans and so we come up with

- #strong[Utility theory];: every state has a #strong[degree of utility]
  and the agent will prefer the higher utility outcomes.
- #strong[Decision theory];: the choice is based on utility theory and
  probabilities.

An agent is #strong[rational] if and only if it chooses the action with
the highest expected utility, averaged over all the possible outcomes of
the action. In other words the agent will take into account the utility
of an outcome and the probability it will be true in the end.

This is called #strong[principle of maximum expected utility (MEU)] and
it is useful to move from a setting where an agent believes that a
proposition is either true or false, to a setting where it has a
#strong[continuous] degree of belief on a given proposition being true
or false.

#horizontalrule

We are considering a sample space $Omega$ that is the set of all
possible worlds (or models), that are #strong[mutually exclusive] and
#strong[exhaustive];. A probability model associates a numerical
probability $P (w)$ with each possible world.

The basic axioms of probability theory are that $P (w)$ must be between
$0$ and $1$ and that the sum of probabilities of all possible worlds
must be exactly $1$.

The #strong[unconditional probability] (#strong[prior];) represents the
degree of belief in a proposition, in absence of any other information.
Other useful relations are

- $P (not a) = 1 - P (a)$
- $P (a or b) = P (a) + P (b) - P (a and b)$

The #strong[conditional probability] of $a$ given $b$ is defined as

$ P (a divides b) = frac(P (a and b), P (b)) $

meaning that

$ P (a and b) = P (a divides b) dot.op P (b) $

If $a$ and $b$ are #strong[independent] random variables then it holds

$ P (a divides b) = P (a) $

bringing that, under the same independence assumption, it holds

$ P (a and b) = P (a divides b) dot.op P (b) = P (a) dot.op P (b) $

Generalizing conditional probability to more events we obtain the
#strong[chain rule of probability];:

$ P (a_1 and dots.h.c and a_n) = product_(j = 1)^n P (a_j divides a_1 and dots.h.c and a_(j - 1)) $

that will be useful in many cases.

#horizontalrule

So, in principle is possible to represent the world by a set of pairs
variable-value, where variables will be random variables and values
their assignment. In this way is possible to define a probability
distribution of all possible values of a random variable.

Now is possible to make inference by #strong[joint probability] of each
variable

$ P (A = a and B = b) $

or more concisely $P (a , b)$. Another useful thing is called
#strong[marginalization];, that defines the probability of a certain
outcome $A$ as

$ P (A) = sum_b P (A , B = b) $

More in general, we want the posterior distribution of the #strong[query
variables] $Y$ given the observed values of the #strong[evidence
variables] $E$.

Supposing we have unobserved, hidden variables $H$, we have

$ H = X - Y - E $

with $X$ being the total number of variables. The probability of $Y$
knowing that $E = e$ is

$ P (Y divides E = e) = alpha P (Y , E = e) = alpha sum_h P (Y , E = e , H = h) $

with $alpha$ a normalizing constant to ensure valid probabilities. This
probabilistic inference with $n$ variables and $d$ possible values per
variable has $O (d^n)$ complexity in time and space for the worst case
scenario (the joint distribution has $d^n$ entries).

#horizontalrule

Also reasoning in solving #emph[sub-problems] first can have a big
impact because, for the Bayesian probability, if $a$ and $b$ are
independent the following properties hold

$ P (a divides b) & = P (a)\
P (a and b) & = P (a) dot.op P (b) $

This greatly reduces the size of the joint probability, expecially if
all variables are mutually independent, it goes from $d^n$ to $d n$.

#horizontalrule

By applying the #strong[Bayes’ rule]

$ P (b divides a) = frac(P (a divides b) dot.op P (b), P (a)) $

the #emph[prior] probability $P (b)$ gets updated by becoming the
#emph[posterior] probability $P (b divides a)$ after observing the
#emph[likelihood] $P (a divides b)$ of the event $a$ when $b$ occurs. We
can interpret Bayes’ rule in a #strong[causal] sense

$ P (upright("cause") divides upright("effect")) = frac(P (upright("effect") divides upright("cause")) dot.op P (upright("cause")), P (upright("effect"))) $

where $P (upright("cause") divides upright("effect"))$ quantifies the
causal direction and $P (upright("effect") divides upright("cause"))$
quantifies the #emph[diagnostic] direction.

#horizontalrule

Another brick to add is #strong[conditional independence] that is
defined like follows: $A$ and $B$ are #strong[conditionally independent]
given $C$ if

$ P (A , B divides C) = P (A divides C) dot.op P (B divides C) $

or equivalently

$ P (A divides B , C) = P (A divides C) $

that in Bayes’ terms can be represented as

$ P (upright("effect")_1 , dots.h , upright("effect")_n divides upright("cause")) = product_j P (upright("effect")_j divides upright("cause")) $

that means that effects are conditionally independent given the cause.
To obtain the posterior of the cause we plug this into the Bayes
theorem:

$ P (upright("cause") divides upright("effect")_1 , dots.h , upright("effect")_n) = alpha P (upright("cause")) dot.op product_j P (upright("effect")_j divides upright("cause")) $

== Naive Bayes Model
<naive-bayes-model>
The #strong[naive Bayes model] is implemented by a graph that factorizes
nicely our world and probabilities if random variables are independent
and it scales linearly with the number $n$ of variables.

#figure(image("/files/naive_bayes_graph.png"),
  caption: [
    Naive Bayes Graph|400
  ]
)

There are no horizontal links between effects. For example given a cause
and two effects we have

$ P (upright("effect")_1 , upright("effect")_2 , upright("cause")) & =\
P (upright("effect")_1 , upright("effect")_2 divides upright("cause")) P (upright("cause")) & =\
P (upright("effect")_1 divides upright("cause")) P (upright("effect")_2 divides upright("cause")) P (upright("cause"))\
 $

and this means that we can deal with three small tables instead of one
giant table.

So now we can answer queries by applying marginalization, also based on
some assumption. But still the number of terms can be high due to the
fact that we need to take into account also probabilities of unknown
environment states.

Actually we don’t have to, and what is usually done is to keep in the
$K B$ only what we know, what is #emph[adjacent] to it is called
#strong[frontier] and we ignore the rest. This last step can usually be
done exploiting independence.

Now in order to answer a query on state in the frontier we have much
less computation to make.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
