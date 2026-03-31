#import "@local/note_template:0.1.0": *
#show: doc => note_template([Linear Mappings], doc)

#title()

*Linear mappings* are basically functions from a vector space to another (or the
same). As for the basic operations like vector sum or multiplication by a
scalar, where the result is still a vector, we want to preserve this property
also for linear mappings. More formally, given two vector space $V$ and $W$ and
a mapping $Phi : V -> W$, it preserve the vector space structure if

$ Phi(x + y) = Phi(x) + Phi(y) \ Phi(lambda x) = lambda Phi(x) $

for all $x, y in V$.

#important(title: [ Linear Mapping ])[
  Given two vector spaces $V$ and $W$ and a mapping $Phi : V -> W$ is called
  *linear mapping* if

  $ Phi(lambda x + psi y) = lambda Phi(x) + psi Phi(y) $

  $forall x, y in V$ and $forall lambda, psi in RR$ it holds
]

A linear mapping can also have three main properties:

- *Injective*: if $forall x, y in V$, it holds that
  $ Phi(x) = Phi(y) ==> x = y $
- *Surjective*: if every element of $W$ can be reached, starting from $V$
  $ Phi(V) = W $
- *Bijective*: if it is both injective and surjective and this makes the
  linear mapping also *invertible*
  $ exists Psi : W -> V | Psi compose Phi(x) = x $
  and usually $Psi$ is denoted with $Phi^(-1)$.

From these definitions can be defined special cases of linear mappings:

- *Isomorphism*: $Phi : V -> W$ is linear and bijective.
- *Endomorphism*: $Phi : V -> V$ is linear.
- *Automorphism*: $Phi : V -> V$ is linear and bijective.
- *Identity*: $id_V : V -> V$ is defined as $x |-> x$.

#important(title: [Theorem])[
  Finite dimensional vector spaces $V$ and $W$ are *isomorphic* if and only if

  $ dim(V) = dim(W) $
]

This theorem implies that vector spaces with same dimension are very similar and
so we can map a vector from $V$ to $W$ without any information loss.
