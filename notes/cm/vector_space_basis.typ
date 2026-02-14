= Vector Space Basis
<vector-space-basis>
Before introducing the concept of #strong[basis] we need to define what
is a generating set of a vector space.

#quote(block: true)[
\[!NOTE\] Generating Set Given a set
$A = { x_1 , dots.h , x_n } subset.eq V$ of vectors, where $V$ is a
vector space, if every vector in $V$ can be expressed as a linear
combinations of the vectors in $A$, then $A$ is called a
#strong[generating set of] $V$.
]

A direct implication of the generating set is the #emph[span] of a set
of vectors.

#quote(block: true)[
\[!NOTE\] Span The #strong[span] is the set of all possible linear
combinations of a set of vectors.
]

In fact, if the span of a set $A$ of vectors is equal to a vector space
$V$, we say that $A$ #emph[spans] $V$. So of course a generating set $A$
of a vector space $V$ #emph[spans] $V$.

Now we can define also a special case of generating set, the
#emph[minimal generating set] of $V$.

#quote(block: true)[
\[!NOTE\] Minimal Generating Set A set of vector $A$ is a
#strong[minimal generating set] for $V$ if and only if there is no other
$hat(A)$ such that $ hat(A) subset.eq A subset.eq V $ that #emph[spans]
$V$.
]

So in other words $A$ has the minimum number of vectors to represent
every vector in $V$ as linear combinations of its vectors.

#quote(block: true)[
\[!NOTE\] Basis If a set $B$ of linearly independet vectors is also a
minimal generating set of $V$, then it’s called a #strong[basis] of $V$.
]

This has some interesting implications like

- Every linear combination of $B$ is unique.
- $B$ is both a minimal generating set and also a maximal linearly
  independent set of vectors in $V$. In other words, adding a vector to
  this set will break the linear independence.

Even though a basis seems to have some unique properties, a vector space
can have multiple basis but all of the same cardinality.

Another interesting fact is that the #strong[dimension] of $V$, when $V$
is a finite dimensional space, is the number of basis vectors of $V$.

== Change of Basis
<change-of-basis>
#quote(block: true)[
\[!example\] Change of coordinates system Let’s take the vector
$v = (2 , 1)$ and let’s consider the canonical basis

$ mat(delim: "[", 1; 0) mat(delim: "[", 0; 1) $

as coordinates system. If we consider another basis, for example

$ mat(delim: "[", 1; - 1) mat(delim: "[", 1; 1) $

we need to solve the following system

$ mat(delim: "[", 1, 1; - 1, 1) mat(delim: "[", x_1; x_2) = mat(delim: "[", 2; 1) $

in order to find the new coordinates of $v$.

$ {x_1 + x_2 = 2\
- x_1 + x_2 = 1 arrow.r.double.long {x_1 = 2 - x_2\
x_2 = 3 \/ 2 arrow.r.double.long {x_1 = 1 \/ 2 = 0.5\
x_2 = 3 \/ 2 = 1.5 $

so the new coordinates of $v$ with the new basis are $v = (0.5 , 1.5)$.
]

== References
<references>
- \[\[linear\_algebra\]\]
- \[\[linear\_independence\]\]
