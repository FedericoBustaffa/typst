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

We can see a basis as a reference systems that gives us coordinates about
vectors living in the vector space we are considering. If we consider for
example the basis $B$ and the vector $v$:

$
  B = mat(1, 0; 0, 1) quad
  v = vec(2, 1)
$

the coordinates of $v$ in the vector space spanned by $B$ can be found by solving
this linear system

$ mat(1, 0; 0, 1) vec(x_1, x_2) = vec(2, 1) quad --> quad x = vec(2, 1) $

that gives to us exactly the $v$ vector we started from because in this case we
used the *canonical basis* that is equivalent to applying the identity.

If now we are interested in changing coordinates system (and so change basis)
and use for example

$ tilde(B) = mat(1, 1; 1, -1) $

we just need to solve same linear system as before but now using the new basis

$ mat(1, 1; 1, -1) vec(x_1, x_2) = vec(2, 1) quad --> quad x = vec(0.5, 1.5) $

Bringing further this concept to linear mappings shows some interesting facts.
Let's consider for example the two bases $B$ and $tilde(B)$ of before that span
a vector space $V$, and let's consider two generic basis $C$ and $tilde(C)$,
both spanning $W$. Let's also consider a linear mapping $Phi : V -> W$,
represented by the matrix $A$.

Under these conditions is possible to do something like mapping vectors of $V$
in the new coordinate system (from $B$ to $tilde(B)$), do the same with vectors
of $W$ ($C$ to $tilde(C)$) and then find a new transformation matrix $tilde(A)$
that preserves the same mappings of $A$ but in the new coordinates system:

$ tilde(A) = T^(-1) A S $

where $S$ and $T^(-1)$ are transformation matrices (typically) of the identity
of $V$ and $W$ respectively.
