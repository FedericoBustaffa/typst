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

= Kernel and Image

The two main subspaces for a linear mappings are the *kernel* and the *image*,
which give us information about the transformation we are dealing with.

#important(title: [ Kernel ])[
  For $Phi : V -> W$ we define the *kernel* as

  $ ker(Phi) := Phi^(-1) (0_W) = { v in V : Phi(v) = 0_W } $

  the set of vectors that the linear mapping $Phi$ maps into the $0$ vector.
]

#important(title: [ Image ])[
  For $Phi : V -> W$ we define the *image* as

  $ Im(Phi) := Phi(v) = { w in W | exists v in V : Phi(v) = w } $

  the set of vectors in $W$ that are reachable from $V$ through the linear
  mapping $Phi$.
]

These two subspaces have some interesting properties like:

- $Phi(0_V) = 0_W$ is always true, therefore $ker(Phi)$ is never empty (it
  contains at least the $0$ vector).
- $Im(Phi) subset.eq W$ and $ker(Phi) subset.eq V$.
- $Phi$ is injective if and only if $ker(Phi) = { 0 }$.
- For $A = [a_1, dots, a_n]$ where $a_i$ are the columns of $A$, it holds

  $
    Im(Phi) = { A x : x in RR^n }
    = { sum_(i=1)^n x_i a_i : x_1, dots, x_n in RR }
    = "span" [a_1, dots, a_n] subset.eq RR^m
  $

  so the image of $Phi$ is called *column space* of $A$ and is a subset of
  $RR^m$ where $m$ is the _height_ of the matrix.
- $rank(A) = dim(Im(Phi))$.
- The kernel is the general solution the homogeneous system $A x = 0$ and is a
  subspace of $RR^n$ where $n$ is the _width_ of the matrix.

#important(title: [ Rank-Nullity Theorem ])[
  Given $V$, $W$ and $Phi : V -> W$, it holds that

  $ dim(V) = dim(ker(Phi)) + dim(Im(Phi)) $
]
