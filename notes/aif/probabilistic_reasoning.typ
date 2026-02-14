= Probabilistic Reasoning
<probabilistic-reasoning>
A direct evolution of the #emph[naive bayes model] is the
#strong[bayesian network];, which is a #strong[direct acyclic graph];,
representing dependency among variables. Each node of the graph
represents a random variable, each depending on its parents:

$ P (X divides upright("parents") (X)) $

For easy problems we can employ a simple #strong[conditional probability
table (CPT)] that gives the value of $X$ for each combination of values
of its parents. The advantage of bayesian networks is that, once the
structure of the network is defined, information about each conditional
distribution is sufficient to specify the full joint distribution,
mititgating the combinatorial explosion of terms.

A bayesian network defines the full joint distribution as the product of
the local conditional distributions:

$ P (x_1 , dots.h , x_n) = product_i P (x_i divides upright("Parent") (X_i)) $

More in general, each node $X$ is conditionally independent of its
#strong[#emph[non-descendants];] given its parents and that’s why is
possible to easily factorize the joint distribution.

Another concept is the #strong[Markov blanket];, which says that each
node $X$ is conditionally independent of any other node given its Markov
blanket $upright("MB")$:

$ upright("MB") (X) = upright("Parents") (X) + upright("Children") (X) + upright("Parents") (upright("Children") (X)) $

To build a bayesian network using the chain rule of probability we can
follow this algorithm:

+ Identify the variables $X_1 , dots.h , X_n$.
+ Choose an ordering of the variables. Any order will work but better
  that causes precede effects to have a more compact network.
+ For each variable $X_i$
  + Add $X_i$ as a node of the network.
  + Select the minimal set of parents from $X_1 , dots.h , X_(i - 1)$
    such that
    $ P (X_i divides upright("Parents") (X_i)) = P (X_i divides X_1 , dots.h , X_(i - 1)) $
  + Insert a link from $X_i$ to all $upright("Parents") (X_i)$ and fill
    the CPT.

The chain rule is used considering that we need to compute
$P (X_1 , dots.h , X_n)$:

$ P (X_1 , dots.h , X_n) = product_i P \( X_i divides X_1 , dots.h , X_(i - 1) $

after we exploit the local semantics (conditional independence) to
obtain

$ product_i P \( X_i divides X_1 , dots.h , X_(i - 1) = product_i P \( X_i divides upright("Parents") (X_i) $

== Compact Conditional Distributions
<compact-conditional-distributions>
In case random variables are continuous, CPTs become of infinite size
and also grows exponentially with the number of parents. To compactly
define infinite cases we can exploit the #strong[canonical
distributiion] in three ways

- #strong[Deterministic nodes];: let $f$ be a function, the variable $X$
  is defined as $ X = f (upright("Parents") (X)) $
- #strong[Context specific independence];: $X$ can be conditionally
  independent of some of its parents given certain values of other
  parents.
- #strong[Noisy-OR] models multiple, non-interacting causes (binary
  variables), reducing the CPTs size from
  $cal(O) (2^(upright("#parents")))$ to $cal(O) (upright("#parents"))$

=== Noisy OR
<noisy-or>
The #strong[noisy-OR] is based on two assumptions

+ Parents include all causes. If not is possible to add a #strong[leak
  node] that covers all other causes.
+ The causal relationship between cause and effect can be
  #strong[inhibited] and the #strong[inhibition probability] $q_i$ is
  independent of inhibition of other causes.

The second assumption implies that a given effect is false if and only
if its true parents are inhibited.

Then, the CPT for a given node with parents $U$ under the previous
assumptions can be computed compactly via

$ P (X divides U_1 , dots.h U_j , not U_(j + 1) , dots.h , not U_k) = 1 - product_(i = 1)^j q_i $

The parents that are false (inhibited) do not contribute to the
probability mass; only the inhibition probability of the true parents
counts.

== Hybrid Bayesian Networks
<hybrid-bayesian-networks>
Can happen that some nodes are discrete and some are continuous.
Continuous values can be discretized in ranges, leading to possibly
large CPTs and numerical errors.

In order to implement #strong[hybrid bayesian networks] is necessary to
specify

- Conditional distribution of continuous variable given discrete or
  continuous pasrents.
- Conditional distribution of discrete varaible given continuous
  parents.

If a network contains only continuous variable with linear gaussian
distributions, then the joint distribution is gaussian (multivariate
over all variables).

If there are discrete variables as parent, then, given any assignment of
the discrete variable, the distribution over continuous ones is Gaussian
(multivariate over all continuous variables).

In case of $P (B divides C)$ with $B$ being a boolean and $C$
continuous, is often employed a #strong[soft threshold function] like a
sigmoid with $c$ as a threshold

$ f (c) = frac(1, 1 + e^(- c)) $

so that the decision switches around a given threshold.

== Inference
<inference>
To compute the posteriors in a bayesian network there is the need of

- A set of #strong[query variables];.
- A set of #strong[evidence variables] which receive value assignments
  based on observed events.
- A #strong[query];: $P (Y divides e)$
  - Multiple query variables can be decomposed with the chain rule.

Making use of unobserved, hidden variables

$ H : P (Y divides e) = frac(P (Y , e), P (e)) = alpha P (Y , e) = alpha sum_(h in H) P (Y , e , h) $

is possible to make #strong[inference by enumeration] where

- The joint probability can be computed efficiently via bayesian
  network.
- Results in sums of products of conditional probabilities, where
  - Sums are loops over variables’ assignments for a given conditional
    distribution.
  - Products combine different conditional distributions.

The resulting tree can be inefficient due to repeated computations; a
depth-first enumeration has complexity $cal(O) (d^n)$ in time and
$cal(O) (n)$ in space.

=== Variable Elimination
<variable-elimination>
A good optimization to avoid recomputation is #strong[variable
elimination];, where summations are carried out right to left and
intermediate results are stored.

For this optimization is necessary to define the #strong[factors];, for
example $f (A)$ is a matrix depending only on the variable $A$. Then we
can procede with a point wise product of #emph[factors];:

$ f (X_i , Y_j) times g (Y_j , Z_k) = h (X_i , Y_j , Z_k) $

=== Approximate Inference
<approximate-inference>
In order to reduce again the computational cost, is possible to perform
an #strong[approximate inference] with a Monte-Carlo approach, called
#strong[direct sampling];:

+ Draw $N$ samples from the sampling distribution defined by the
  bayesian network.
+ Compute the #strong[approximate posterior] $Q$.

The $Q$ quantity converges to the true posterior as $N$ approaches
infinity, because the sampling computes a #strong[consistent estimate]
of the posterior.

In other words after $N$ trials is possible to compute the posterior
considering that $N (X = x_1 , dots.h , x_n)$ is the number of times the
event $X$ occurred over the $N$ trials.

Counting how many times the query occurred out of all $N$ trials and
that is the answer.

Another approach is called #strong[rejection sampling];, that

+ Generates samples from the network distribution as before.
+ Rejects all the samples that do not match the evidence.
+ Estimates the probability $P (X = x divides e)$ by counting the
  frequency of $X$ having value $x$ in the remaining samples.

Also rejection sampling returns consistent estimates and convergence
depends on the evidence probability $P (e)$.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
- \[\[uncertainty\]\]
