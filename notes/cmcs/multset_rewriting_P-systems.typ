#import "@local/note_template:0.1.0": *
#show: doc => note_template([Multiset Rewriting and P-Systems], doc)

#title()

Another formalism useful to model stuff like chemical reactions behavior is
*multiset rewriting*. Let's begin by saying that a *multiset* is a variant of
the mathematical notion of set in which elements can be repeated, for example

$ { A, A, A, B, B, C, C, C } $

is a multiset. A chemical solution can be seen as a multiset of symbols
representing molecules and the idea of _rewriting_ encodes the fact that every
time a chemical reaction occurs, the multiset is updated and *rewrites* itself

= Representation

Given a support set $Sigma$ (vocabulary) of the multiset $M$, the usual ways of
representig $M$ over $Sigma$ are

- *Set of pairs*: the first pair element contains a symbol and the second
  contains the number of instances of the symbol. Formally a pair is an element
  of $M subset.eq Sigma times NN$; for example

  $ M = { (A, 3), (B, 2), (C, 3) } $
- *Mapping*: basically a function that maps each symbol to the number of
  instances $M : Sigma -> NN$; for example

  $ M(A) = 3 quad M(B) = 2 quad M(C) = 3 $
- *Strings*: concatenation of symbols in the multiset in which order does not
  matter:

  $ A A A B B C C C = A B C A B C A C $

  and for which we can use a compact notation like

  $ A^3 B^2 C^3 $

This last setting let us use some useful facts about formal grammars like the
fact that, given an alphabet $Sigma$, the set of all possible multisets is
$Sigma^*$ (*Kleene closure* of the alphabet), that is

$ union.big_(i in NN) Sigma^i $

where $Sigma^i$ is the set of all possible strings of length $i$. Is also
possible to easily represent multiset unions as string _concatenation_.

= Rewriting Rules

Now that we have an alternative way of representing chemical solution molecules,
we have to represent chemical reactions as *rewriting rules*, because as said,
we want to model a reaction like a set that rewrites itself every time a rule is
applied (a reaction took place).

#important(title: [ Multiset Rewriting Rule ])[
  A *multiset rewriting rule* is a pair $(u, v)$ with $u, v in Sigma^*$, usually
  denoted as $u |-> v$.
]

The idea is to consider a set of chemical reactions as a *multiset of rewriting
rules*. When one of these rules is applied to a multiset $w in Sigma^*$ such that
$u subset.eq w$ we obtain the same multiset but with $u$ replaced by $v$.

#important(title: [ Multiset Rewriting ])[
  A *multiset rewriting (MSR) system* is a pair
  $ S = chevron.l Sigma, cal(R) chevron.r $
  where $Sigma$ is an alphabet of symbols and $cal(R)$ is a set of multiset
  rewriting rules.
]

For example we can have

$ S = chevron.l {A, B, C}, {A B |-> C, C |-> A B } chevron.r $

Therefore, is now possible, given a multiset in $Sigma^*$ we can use the
mechanism of rewriting rule application to compute *traces* of the multiset
rewriting system.

$ A^3 B^2 C^3 -> A^2 B^1 C^4 -> A C^5 -> A^2 B C^4 $

that is one possible behavior, starting from an initial state.

= Interleaving Semantics

If we remember the case of SSA algorithm, a reaction was chosen in a stochastic
way, in this context formalized by the *interleaving semantics*, that basically
formalize the fact that one non-deterministically chosen rule is applied.

#important(title: [ Interleaving Semantics ])[
  The *interleaving semantics* of a MSR system $iprod(Sigma, cal(R))$ is the
  transition system $(Sigma^*, ->)$ where $-> subset.eq Sigma^* times Sigma^*$
  is the least transition relation satisfying the following inference rule

  $ frac(u |-> v in cal(R), u w -> v w) $
]

If we incorporate stochastic rates in a MSR we obtain a *stochastic MSR* with
*stocahstic rewritng rules*

#important(title: [ Stochastic Rewriting Rule ])[
  Given an alphabet $Sigma$, a stochastic multiset rewriting rule is a tuple

  $ (u, v, r) $

  where $u, v in Sigma^*$ and $r in R^+$, usually denoted with $u |->^r v$
]

#important(title: [ Stochastic Multiset Rewriting System ])[
  A stochastic MSR system is a pair $S = iprod(Sigma, cal(R))$ where $Sigma$ is
  an alphabet of symbols and $cal(R)$ is a set of stochastic multiset rewriting
  rules.
]

#important(title: [ Stochastic Multiset Rewriting Semantics ])[
  The semantics of stochastic MSR systems is the CTMC $(Sigma^*, ->)$ where
  $-> subset.eq Sigma^* times RR^+ times Sigma^*$ is the least stochastic
  transition relation satisfying the following inference rule:

  $ frac(u |->^r v in cal(R), u w -->^(r dot f(u, u w)) v w) $

  where $f(u, u w)$ gives the number of instances of $u$ in $u w$.
]

== Alternative Semantics

With the defined language is possible to define variants involving parallel
application of rewriting rules.

An example is the simple parallelism semantics in which one or more rewrite
rules are applied at each step.

#important(title: [ Parallel Semantics ])[
  The *parallel semantics* of a MSR system $iprod(Sigma, cal(R))$ is the
  transition system $(Sigma^*, ->)$ where $-> subset.eq Sigma^* times Sigma^*$
  is the least transition relation satisfying the following inference rules

  $
    frac(u |-> v in cal(R), u -> v) quad
    frac(w -> w', w u -> w' u) quad
    frac(w_1 -> w'_1 quad w_2 -> w'_2, w_1 w_2 -> w'_1 w'_2)
  $

]

Another example is the maximally parallelism semantics in which as many rules as
possible are applied at each step.

#important(title: [ Maximally Parallel Semantics ])[
  The *maximally parallel semantics* of a MSR system $iprod(Sigma, cal(R))$ is
  the transition system $(Sigma^*, =>)$ where $=> subset.eq Sigma^* times
  Sigma^*$ is the least transition relation satisfying the following inference
  rules (with $-> subset.eq Sigma^* times Sigma^*$ auxiliary transition
  relation)

  $
    frac(u |-> v in cal(R), u -> v) quad
    frac(w_1 -> w'_1 quad w_2 -> w'_2, w_1 w_2 -> w'_1 w'_2) quad
    frac(w -> w' quad u arrow.not, w u => w' u)
  $

]

== P-Systems

If we ignore ordering of symbols in the words of a language we obtain a set of
multisets of terminal symbols and it is called a *multiset language* that is
less expressive than a language that instead considers ordering.

However is possible to define the so called *P-Systems*, which have a *maximal
parallelism semantics* and that can give more expressive power to multiset
languages. In particular they are able to generate any recursively enumerable
language.

P-systems are *parallel computing devices* inspired by cells, in fact they have
three main components:

- *Membranes*: compartments used to distribute computations.
- *Multisets*: abstractions of chemical solutions.
- *Evolution (rewriting) rules*: abstraction of chemical reactions.

A P-system $Pi$ is given by

$ Pi = (V, mu, w_1, dots, w_n, R_1, dots, R_n) $

where

- $V$ is an alphabet of _objects_.
- $mu subset NN times NN$ is a *membrane structure*, such that $(i, j) in mu$
  denotes that the $j$-th membrane is contained in the $i$-th membrane.
- $w_i$ are strings from $V^*$ representing multisets associated with $i$-th
  membrane.
- $R_i$ are finite sets of evolution rules associated with the membranes of
  $mu$.

Evolution rules like $u -> v$ consists of a multiset of objects $u$ (reactants)
and a multiset of messages $v$ (products). They usually have a form that
basically says in which membrane each object go. These rules can be classified
in *non-nooperative* and *cooperative* depending on the type of reactions.

