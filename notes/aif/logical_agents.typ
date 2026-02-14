= Logical Agents
<logical-agents>
A popular type of agents are #strong[logical agents];, also called
#strong[knowledge-based] agents, which, as the name suggest, maintain a
#emph[knowledge base] (KB) on the environment in the form of
#strong[logic sentences];.

Typically they start with a general knowledge of the rules of the
environment, but through perceptions they can add new knowledge and,
most important, they can generate new knowledge by #strong[inference];.

This time we have a #strong[declarative approach];, were the agent has a
representation of the world which says what it knows, not what it does.

== Entailment
<entailment>
To understand how logical agents are able to infer new knowledge is
necessary to define what a #strong[possible model] (#strong[world];) is.
A possible model is a mathematical abstraction with a fixed truth value
for each relevant sentence.

If a sentence $alpha$ is true in a model $m$ we say that $m$
#strong[satisfies] $alpha$ and $M (alpha)$ is the set of all models of
$alpha$.

The first piece for inference is the concept of #strong[entailment];,
that is defined as a relationship between sentences that is based
semantically when a sentence logically follows another.

More formally we say that $alpha$ #strong[entails] $beta$:

$ alpha tack.r.double beta $

that is equivalent to say that for every model where $alpha$ is true
then also $beta$ is true. In this sense $alpha$ is a stronger assertion
than $beta$ as it rules out more possible models.

#figure(image("entailment.png"),
  caption: [
    Entailment
  ]
)

Entailment itself is defined semantically over all possible models, but
in practice agents use inference rules to derive conclusions without
enumerating models explicitly. In this way, inference allows the agent
to restrict the possible worlds to those consistent with its knowledge.

== Inference
<inference>
Now we want an #strong[inference algorithm] capable of use entailment
and classical logic laws, in order to generate new knowledge
automatically. But first some definitions

- #strong[Equivalence];: $alpha equiv beta$ if and only if
  $alpha tack.r.double beta$ and $beta tack.r.double alpha$.
- #strong[Validity];: a sentence is valid if it is true in all models.
- #strong[Satisfiability];: a sentence is #strong[satisfiable] if is
  true in some model. It is unsatisfiable if it is never true.

If a sentence $alpha$ is #emph[derived] from KB by the the inference
algorithm $i$, then we can say that KB #emph[infers] $alpha$:

$ K B tack.r_i alpha $

An inference algorithm can be

- #strong[Sound];:
  $K B tack.r_i alpha arrow.r.double.long K B tack.r.double alpha$
- #strong[Complete];:
  $K B tack.r.double alpha arrow.r.double.long K B tack.r_i alpha$

In simple words, the soundness says that everything that can be derived
syntactically is also semantically true. While the completeness says
that everything that is semantically true can also be derived
syntactically.

=== Model Checking
<model-checking>
The simplest way to verify entailment is via #strong[model checking];,
which consists in enumerating all the possible models and check whether
$alpha$ is true in all models in which KB is true.

We enumerate all the possible models where KB is true, and all the
possible models where $alpha$ is true, considering also what we already
know about the environment.

#figure(image("wumpus_entailment1.png"),
  caption: [
    Entailment on Wumpus World|400
  ]
)

If the knowledge base rules out the sentence $alpha$, then we obtain the
possible models where the sentence is true and where all the knowledge
is still true. In other words the intersection between the two
represents all the possible realizations of sentences in the actual
environment (based on the KB); what is outside the intersection cannot
be true with respect to the KB.

Let’s notice that the KB models where $alpha$ is true must be a subset
of $alpha$ in order to conclude that the sentence is true also for KB.

#figure(image("wumpus_entailment2.png"),
  caption: [
    Entailment on Wumpus World|400
  ]
)

If the models of KB are not contained in the models of $alpha$, the
entailment does not hold. This is like saying that there are possible
models where the sentence is true but, based on the KB and the
perceptions, there are no guarantees that they will realize concretely.

The simplest form for model checking is via #strong[truth tables];, that
tries to check if $K B tack.r.double alpha$ by

+ Generating, for all the symbols in both KB and $alpha$, all the
  possible assignments.
+ Search for assignments that let KB be true and check if $alpha$ is
  also true.

#figure(image("truth_table_model_checking.png"),
  caption: [
    Truth Table|600
  ]
)

Doing inference by enumeration is sound and complete but it costs
$O (2^n)$ in time and space.

=== Resolution Inference
<resolution-inference>
Another way to proving a fact is via #strong[inference rules];, that can
be applied starting from the KB to derive the goal.

Before seeing the algorithm a useful thing to do is convert any
propositional logic statement in #strong[conjunctive normal form]
(#strong[CNF];). In the CNF a #strong[clause] is a disjunction of
literals and the CNF itself is formed by conjuctions of clauses. Let’s
point out that is always possible to convert to CNF.

Once converted in CNF is possible to use inference rules to inference
some facts, the most important rules are

- #strong[Unit resolution];: that is used to delete a couple of
  complementary literals
  $ frac(l_1 or dots.h.c or l_k , #h(0em) m, l_1 or dots.h.c or l_(i - 1) or l_(i + 1) or l_k) $
  where $l_i$ and $m$ are complementary literals ($A and not A$).
- #strong[Full resolution];: that is used to delete multiple
  complementary literals
  $ frac(l_1 or dots.h.c or l_k , #h(0em) m_1 or dots.h.c or m_n, l_1 or dots.h.c or l_(i - 1) or l_(i + 1) or dots.h.c or l_k or m_1 or dots.h.c or m_(j - 1) or m_(j + 1) dots.h.c m_n) $
  where $l_i$ and $m$ are complementary literals (e.g.~$A$ and $not A$).

So we can now apply inference rules in order to be able to say if
$K B tack.r.double alpha$ by showing that $K B and not alpha$ is
unsatisfiable.

+ Convert $K B and not alpha$ to CNF.
+ For all pairs of clauses
  - Apply resolution clauses to generate new clauses
  - If the #emph[empty clause] is generated then
    $K B tack.r.double alpha$ since we have generated a contradiction.
+ If no new clauses are generated we can conclude that $K B ⊭ alpha$.

Resolution is sound and complete for propositional logic.

#figure(image("resolution_inference.png"),
  caption: [
    Resolution Inference|700
  ]
)

=== Horn Clause Inference
<horn-clause-inference>
A particular CNF is called #strong[Horn form] and is defined, as a
classical CNF, as a conjuctions of clauses, with at most one positive
symbol in each clause:

$ (A or not B) and (not A or not C or D) $

Unfortunately is not always possible to convert in Horn form. The
algorithm proceeds by creating a chain of implications by using
#emph[Modus Ponens];. This algorithms has linear complexity in time with
respect to the size of the KB.

There are two possible ways to run this algorithm: #strong[forward
chaining] and #strong[backward chaining];:

- In the #emph[forward chaining] we start from the fact, like from
  literals and their truth values. Going on this process let us
  inference other facts; the algorithm continues until it generates the
  goal sentence $alpha$. If it did not generate $alpha$ yet and there
  are no more steps we can do, then we can conclude that $K B ⊭ alpha$.
- In the #emph[backward chaining] we start from the goal sentence and
  try to prove only what it needs to our sentence to be true.

The first is like a breath-first search: we start from facts but we
don’t know what is necessary to be proven in order to inference $alpha$.
At some point, if that’s the case, we will conclude that
$K B tack.r.double alpha$.

The second is like a depth-first search: we start from the sentence and
so we now what it needs to be proven. So we can ignore other branches
and continue until we encounter facts that make our sentence true (or
until we reach a contraddiction).

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
