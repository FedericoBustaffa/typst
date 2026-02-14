= Matrices
<matrices>
One of the main objects in linear algebra is the #strong[matrix];, that
can be seen as an element of $bb(R)^(m times n)$, that can have many
meanings as collection of column or row vectors, the representation of a
system of linear equations or a linear mapping.

Before using matrices for some specific task is useful to define some
properties, always valid regardless of context.

- #strong[Sum];: given $A , B in bb(R)^(m times n)$
  $ A + B = C in bb(R)^(m times n) $ that is the element-wise sum of $A$
  and $B$ ($c_(i j) = a_(i j) + b_(i j)$).
- #strong[Product];: given $A in bb(R)^(m times n)$ and
  $B in bb(R)^(n times p)$ $ A dot.op B = C in bb(R)^(m times p) $ is
  the so called #strong[dot product] between $A$ and $B$. This works
  also for $1$-column (and $1$-row) matrices, defining the #emph[matrix
  by vector] multiplication.

#quote(block: true)[
\[!NOTE\] Matrix-Matrix Multiplication Given two matrices
$A in bb(R)^(m times n)$ and $B in bb(R)^(n times p)$, the elements of
product matrix $C in bb(R)^(m times p)$ are computed as follows:
$ c_(i j) = sum_(k = 1)^n a_(i k) dot.op b_(k j) $ with
$i = 1 , dots.h , m$ and $j = 1 , dots.h , p$.
]

For the dot product the following properties are valid:

- #strong[Associativity];: $(A B) C = A (B C)$
- #strong[Distributivity];: $(A + B) C = A C + B C$ and
  $A (B + C) = A B + A C$

#quote(block: true)[
\[!IMPORTANT\] The #emph[dot product] is, in general, not commutative
$ A B eq.not B A $
]

Matrices also represent #strong[linear transformations];, for example
$A v$ is a transformation $A$ applied to the vector $v$ (like
translation or rotation).

#quote(block: true)[
\[!note\] Order of Transformations Knowing that the order in matrix
multiplication counts, if we apply multiple transformations to a vector,
the order in which we apply them will change the outcome.

If for example we apply a rotation before a traslation, first we change
the coordinates system by rotating and then the vector will be moved
along the new axis.

On the other hand, if we translate first, the vector will be moved and
then rotated accordingly to the same center of rotation as before.
]

To combine multiple transformation is possible to multiply matrices. In
order to do that we need the product between the two to be well defined.
Given $A in bb(R)^(m times n)$, the other matrix needs to be
$B in bb(R)^(n times p)$ for the product to be well defined. In the end
we have

$ A B in bb(R)^(m times p) $

The classical row by column product has a cost of $O (m n p)$ that in
general we can approximate to $O (n^3)$ if we consider almost squared
matrices with dimension $n times n$.

An important matrix, that is useful to define other matrices and
represents the neutral element for the dot product, is the
#strong[identity] matrix

#quote(block: true)[
\[!NOTE\] Identity Matrix The #strong[identity matrix] is defined as a
square matrix with all zeros except on the main diagonal, that has only
ones.

$ I = mat(delim: "[", 1, 0, dots.h.c, 0; 0, dots.down, dots.down, dots.v; dots.v, dots.down, dots.down, 0; 0, dots.h.c, 0, 1) $
]

The identity matrix is crucial to define the #strong[inverse] matrix of
a matrix $A$, that is very important in many situations like solving
linear systems.

#quote(block: true)[
\[!NOTE\] Inverse Matrix Given a #emph[square] matrix $A$, its inverse
is a matrix $B$ such that $ A B = B A = I $ and it is denoted as
$A^(- 1)$.
]

Unfortunately, not all (square) matrices have a inverse, if so, they are
called #strong[singular] or #strong[non invertible];; if instead a
matrix has a inverse is called #strong[regular];, #strong[non singular]
or #strong[invertible];.

A direct consequence of this definition is that, if we have $A$ and $I$
is possible to find $A^(- 1)$ by computing the dot product

$ A A^(- 1) = I $

and solving a linear system. Now should be more clear that not always is
possible to have a inverse.

Another special matrix is the #strong[transpose] that, unlike the
inverse, is always defined for every matrix square and rectangular
matrix (so also for vectors).

#quote(block: true)[
\[!NOTE\] Transpose Matrix Given a matrix $A in bb(R)^(m times n)$, the
matrix $B in bb(R)^(n times m)$ whose elements are $ b_(i j) = a_(j i) $
is called the transpose of $A$ and is denoted as $A^tack.b$.
]

Let’s see some properties of these two matrices

- $A A^(- 1) = A^(- 1) A = I$
- $(A^tack.b)^tack.b = A$
- $(A B)^(- 1) = B^(- 1) A^(- 1)$ and similarly
  $(A B)^tack.b = B^tack.b A^tack.b$
- $(A + B)^(- 1) eq.not A^(- 1) + B^(- 1)$ instead
  $(A + B)^tack.b = A^tack.b + B^tack.b$

Let’s also say that if $A$ is invertible, also $A^tack.b$ is invertible
and this is true because

$ (A^(- 1))^tack.b = (A^tack.b)^(- 1) = A^(- tack.b) $

#quote(block: true)[
\[!NOTE\] Symmetric Matrix Given a matrix $A$ such that $ A = A^tack.b $
then is called #strong[symmetric];.
]

The sum of symmetric matrices is also symmetric, while the product is
not (generally).

There are also properties for matrix multiplication by a scalar, so
given $lambda , psi in bb(R)$ it holds:

- $(lambda psi) C = lambda (psi C)$
- $lambda (B C) = (lambda B) C = B (lambda C) = (B C) lambda$
- $(lambda C)^tack.b = lambda C^tack.b$
- $(lambda + psi) C = lambda C + psi C$
- $lambda (B + C) = lambda B + lambda C$

These are general properties and useful matrices to start doing things
with linear algebra.

== References
<references>
- \[\[linear\_algebra\]\]
- \[\[linear\_systems\]\]
