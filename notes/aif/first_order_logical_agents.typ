= First Order Logical Agents
<first-order-logical-agents>
A more powerfull type of logical agent, with respect to propositional
logical agents, are #strong[first order logical agents];, that exploit
#strong[first order logic] (#strong[FOL];) constructs in order to be
more general.

Propositional logic is only able to model #emph[facts];, while in the
FOL, is possible to model objects and relations or properties of them.
If a property has only one value for each input, then it can be seen has
a function.

In FOL the syntax is composed by

- #strong[Constants];: $5$, #emph[John]
- #strong[Predicates];: #emph[brotherOf]
- #strong[Functions];: #emph[sqrt]
- #strong[Variables];: $x$, $y$
- #strong[Connectives];: $not$, $and$, $or$
- #strong[Equality];: $=$
- #strong[Quantifiers];: $exists$, $forall$

Typically in the FOL we have #strong[sentences];, formed by

- #strong[Terms];: logical expressions referring to an object, like
  functions, constants o variables.
- #strong[Atomic sentence];: defined by a predicate $p$ or a term
  equality.
- #strong[Complex sentences];: atomic sentences linked by connectives.

A sentence is true with respect to a given #strong[model] and
#strong[interpretation];, where

- A #strong[model];, that contains one or more domain elements (objects)
  and their relations.
- An #strong[interpretation] associates a concrete referent to each
  constant (object), predicate and function (relations).

A model with an interpretation is a model in the propositional logic.

== Computational Issues
<computational-issues>
A common assumption for FOL agents is the #emph[closed world
assumption];: atomic sentences that are not known to be true or false
are assumed false. This allows to get rid of boilerplate stuff that
handles incomplete information. In this kind of agents we assume one
unique referent of each constant, predicate or function.

However with the introduction of quantifiers, entailment via model
checking is very expensive or impossible. For example if we have a
variable $x$ that can be every real value in $[1 , + oo]$ the
computation never stops.

In case of #emph[universal quantification];, a statement in the form

$ forall x thin P $

is true in a model if and only if the sentence $P$ is true for every
possible object associated with $x$ in the model. In propositional logic
it is a possibly infinite conjunction of instances of $x$.

In case of #emph[existential quantifiers];, a statement in the form

$ exists x thin P $

is true in a model if and only if the sentnces $P$ is true for at least
one object associated with $x$ in the model. In propositional logic is a
possibly infinite disjunction of instances of $x$.

== Knowledge Base
<knowledge-base>
In order to build a FOL agent we need to build a #strong[FOL knowledge
base] and this is typically done by

+ Identify questions.
+ Assemble the relevant knowledge.
+ Decide on a vocabulary predicates, functions and constants.
+ Encode general knowledge about the domain.
+ Encode a specific description of the problem instance.
+ Ask queries to the inference algorithm to get answers.
+ Debug and evaluate the knowledge base.

For example in the Wumpus World we want to have an interface #emph[ask]
and #emph[tell];; the agent perceives a #emph[breeze] at $t = 5$, so

- #emph[Tell (KB, Percept(\[Smell, Breeze\], 5))]
- #emph[Ask (KB, $exists a$ Action($a$, 5))]

And the answer should be #emph[$a$ = Shoot];.

A useful construct is the #strong[substitution] operator $sigma$ and it
works by assigning (or substituting) a term value to a variable. For
example we can have a predicate

$ S = upright("Smarter") (x , y) $

and a substitution

$ sigma = { x \/ upright("Mario") , y \/ upright("Luigi") } $

the resulting sentence is

$ S sigma = upright("Smarter") (upright("Mario") , upright("Luigi")) $

This is used when the agent query the KB, for example #emph[Ask(KB,
$S$)];; the answer will be some or all substitutions $sigma$ such that
$K B tack.r.double S sigma$.

== Quantifiers Instantiations
<quantifiers-instantiations>
The #strong[universal instantiation (UI)] tells us that any sentence
obtained by replacing a #emph[universally quantified] variable with a
#strong[ground term] can be inferred.

$ frac(forall v #h(0em) a, sigma ({ v \/ g } , thin a)) $

that applies for every variable $v$, sentence $a$ and ground term $g$.

The #strong[existential instantiation (EI)] tells us that from a
sentence that confirms the existance of something we can infer a
sentence with a new constant $k$, called #strong[Skolem constant];.

$ frac(exists v #h(0em) a, sigma ({ v \/ k } , thin a)) $

that applies for every variable $v$, sentence $a$ and constant symbol
$k$ that does not belong to any other object.

Applying UI repeatedly means #strong[adding] new sentences to the KB,
but the resulting KB is logically equivalent to the initial KB. If we
apply the UI for every possible sentence in order to remove every
$forall$, we #emph[propositionalize] the KB.

Applying EI repeatedly means #strong[replacing] the existential
quantification with a new sentence. In this case the resulting KB is not
logically equivalent to the initial and it is satisfiable if and only if
the initial was.

== Unification
<unification>
Usually the process of propositionalization generates a lot of useless
stuff. Taking also into account that if we have $p$ predicates that are
$k$-ary and $n$ constants, we can generate $p n^k$ possible instances.

The trick is to find a way to make different logical expression
identical, such that we reduce the number of possible instances. For
this purpose, #strong[unification] can be use to #emph[unify] two
different expressions:

$ upright("unify") (alpha , beta) = theta $

if $alpha theta = beta theta$, with $alpha$ and $beta$ sentences and
$theta$ substitution.

If for example we have

$ alpha & = upright("Knows") (upright("John") , x)\
beta & = upright("Knows") (upright("John") , upright("Jane")) $

the unifier will be

$ theta = { x \/ upright("Jane") } $

because
$alpha theta = upright("Knows") (upright("John") , upright("Jane"))$
that is equivalent to $beta$.

=== Generalized Modus Ponens
<generalized-modus-ponens>
The unification let us define the #strong[generalized Modus Ponens
(GMP)] as follows

$ frac(p_1' , dots.h , p_2' , #h(0em) (p_1 and dots.h.c p_n arrow.r q), q theta) $

where for all $i$ $p_i' theta = p_i theta$ and $p_i'$ and $p_i$ are
#emph[atomic];.

The GMP lifts the Modus Ponens, adding the minimal amount of complexity
needed to make it work in FOL, obtaining a #emph[sound] algorithm.

== Chaining
<chaining>
Since we are dealing with definite clauses we are not covering the
entire FOL, but this is often sufficient to most of the real world
cases.

The #strong[forward chaining];, starting from the known facts, triggers
all the possible applicable rules and add the conclusions to the facts.
When the query is generated, it returns true, otherwise, if no new facts
are generated, returns false. The #emph[forward chaining] is sound and
complete.

The #strong[backward chaining] starts from the query $q$, generates all
the terms connected to $q$ until it generates the premise to infer $q$.
The #emph[backward chaining] is sound but not complete in case of
infinite space or loops.

== Resolution in FOL
<resolution-in-fol>
What is needed for an inference algorithm with FOL is #strong[resolution
rule];:

$ frac(p_i or dots.h.c or p_k , #h(0em) m_1 or dots.h.c or m_n, p_1 or dots.h.c or p_(i - 1) or p_(i + 1) or dots.h.c or p_k or m_1 or dots.h.c or m_(j - 1) or m_(j + 1) or dots.h.c or m_n) theta' $

where

$ theta = upright("unify") (p_i , not m_j) $

we can then apply resolution steps to
$upright("CNF") (K B and not alpha)$ to prove it is unsatisfiable.

Resolution in FOL is complete and if $K B tack.r.double alpha$ then
resolution inference will derive $alpha$ by contraddiction. It is also
#emph[semidecidable] because it will find proof for a true statement,
but for a false statement might never stop.

== Questions
<questions>
- What is an object?
  - An element of the domain like a constant.
- What is a relation?
  - A set of tuples of objects for which a predicate is true.
- What is a referent?
  - A symbol that links to an actual thing in the domain.
- What the interpretation actually does?
  - A map that links FOL syntax to the model semantics. For example
    assigns a objects to every constant or a relation to every
    predicate.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
- \[\[logical\_agents\]\]
