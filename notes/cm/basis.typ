#import "@local/note_template:0.1.0": *
#show: doc => note_template([Basis], doc)

#title()

Before introducing the concept of *basis* we need to define what is a generating
set of a vector space.

#important(title: "Generating Set")[
  Given a set $A = { x_1 , dots.h , x_n } subset.eq V$ of vectors, where $V$ is
  a vector space, if every vector in $V$ can be expressed as a linear
  combinations of the vectors in $A$, then $A$ is called a *generating set of*
  $V$.
]

A direct implication of the generating set is the _span_ of a set of vectors.

#important(title: "Span")[
  The *span* is the set of all possible linear combinations of a set of vectors.
]

In fact, if the span of a set $A$ of vectors is equal to a vector space $V$, we
say that $A$ _spans_ $V$. So of course a generating set $A$ of a vector space
$V$ _spans_ $V$.

Now we can define also a special case of generating set, the _minimal generating
set_ of $V$.

#important(title: "Minimal Generating Set")[
  A set of vector $A$ is a #strong[minimal generating set] for $V$ if and only
  if there is no other $hat(A)$ such that $ hat(A) subset.eq A subset.eq V $
  that _spans_ $V$.
]

So in other words $A$ has the minimum number of vectors to represent every
vector in $V$ as linear combinations of its vectors.

#important(title: "Basis")[
  If a set $B$ of linearly independent vectors is also a minimal generating set
  of $V$, then it’s called a *basis* of $V$.
]

This has some interesting implications like

- Every linear combination of $B$ is unique.
- $B$ is both a minimal generating set and also a maximal linearly independent
  set of vectors in $V$. In other words, adding a vector to this set will break
  the linear independence.

Even though a basis seems to have some unique properties, a vector space can
have multiple basis but all of the same cardinality.

Another interesting fact is that the #strong[dimension] of $V$, when $V$ is a
finite dimensional space, is the number of basis vectors of $V$.

= Change of Basis <change-of-basis>

A nice way to think about bases is coordinates system which give a sort of
reference to know where vectors of a certain vector space are. Intuitively the
canonical basis is the most simple to think about: it basically says how far a
vector is from the origin.

$
  B = mat(1, 0; 0, 1) quad
  v = vec(2, 1)
$

the coordinates of $v$ in the vector space spanned by $B$ can be found by solving
this linear system

$ mat(1, 0; 0, 1) vec(v_1, v_2) = vec(2, 1) quad --> quad v = vec(2, 1) $

that gives to us exactly the $v$ vector we started from because in this case we
used the *canonical basis* that is equivalent to applying the identity.

If now we are interested in changing coordinates system (and so change basis)
and use for example

$ tilde(B) = mat(1, 1; 1, -1) $

we just need to solve same linear system as before but now using the new basis

$ mat(1, 1; 1, -1) vec(v_1, v_2) = vec(2, 1) quad --> quad v = vec(0.5, 1.5) $

to get the new coordinates of vector $v$.

== Change of Basis Transformation Matrix

We can bring farther this concept to transformation matrices when a change of
basis is performed.

If we work with vector fields $V$ and $W$ and consider their canonical basis for
example, we can define a linear mapping $Phi : V -> W$ and its corresponding
transformation matrix $A$. A change of basis changes the coordinates system of
vectors in $V$ and $W$ and so we need a new linear mapping that is consistent
with $Phi$; in other words we need to find a new transformation matrix
$tilde(A)$ that ma

Let's consider two bases $B$ and $tilde(B)$ of $V$ and two bases $C$ and
$tilde(C)$ of $W$. Let's also consider a linear mapping $Phi : V -> W$,
represented by the matrix $A$ with respect to $B$ and $C$.

If we change bases to $tilde(B)$ and $tilde(C)$ vectors in $V$ and $W$ are now
mapped with respect to a different coordinates system. Since we have already
have $A$, a nice way to think at the new matrix we are looking for is a matrix
that, applied to a vector in $V$

+ Change basis from $tilde(B)$ to $B$ so that we go back to the coordinates
  system in which $A$ is defined.
+ Apply the original $A$ that gives us a vector $W$ but with respect to the
  original basis $C$.
+ Change basis from $C$ to $tilde(C)$ so that we obtain the result vector in the
  right coordinates system.

In general we need to find two matrices $S$ that does the basis change in $V$
(from $tilde(B)$ to $B$) and $T$ that does to basis change in $W$ (from
$tilde(C)$ to $C$). Since we want the last change of basis from $C$ to
$tilde(C)$ we actually need to use $T^(-1)$ to construct the new $tilde(A)$:

$ tilde(A) = T^(-1) A S $

Since we have the two couples $B$, $tilde(B)$ and $C$, $tilde(C)$ we can express
for example vectors of $tilde(B)$ as linear combinations of vectors of $B$, take
the coefficients and build $S$.

Analogue reasoning for $C$ and $tilde(C)$ to build $T$ except that this time we
also need to invert it in order to have the final result in terms of $tilde(C)$.
