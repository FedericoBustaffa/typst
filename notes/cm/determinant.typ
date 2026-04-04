#import "@local/note_template:0.1.0": *
#show: doc => note_template([Determinant], doc)

#title()

The *determinant* is a linear mapping that maps square matrices onto real
numbers

$ det : RR^(n times n) -> RR $

and is often related to analysis and solutions of linear systems.

The determinant also has a nice graphical property: it is the area (or volume)
of the $n$-dimensional parallelopid spanned by the column vectors of $A$.

Considering the matrix

$ A = mat(3, 0; 0, 2) $

we will see that is determinant is

$ det(A) = matrixdet(3, 0; 0, 2) = 6 $

and from a graphical perspective

#figure(
  cetz.canvas({
    import cetz.draw: *

    rect((0, 0), (3, 2), fill: luma(230))

    line((0, 0), (3, 0), stroke: 1.5pt, mark: (end: ">", fill: black))
    line((0, 0), (0, 2), stroke: 1.5pt, mark: (end: ">", fill: black))
  }),
  caption: [ Graphical Determinant ],
)

the determinant of the matrix $A$ is the grey area, which reconnects with the
actual way of computing the determinant for a $2 times 2$ matrix

$ matrixdet(a, b; c, d) = a d - b c $

that is the classic _width by height_ formula.

#note[
  Matrices represent transformations of vectors and the determinant is the
  volume of the subspace spanned by the column vectors.

  This entails the fact that a matrix $A$ whose determinant is zero maps a
  vector to a lower dimensional vector space.
]

#important(title: [ Theorem ])[
  Any square matrix is *invertible* if and only if

  $ det (A) != 0 $
]

This theorem reconnects us with the note above because if a linear
transformation $A$ maps for example a 2-D vector onto a 1-D subspace, there is
no way to bring it back to its original space and coordinates by applying an
inverse operation.

Let's consider the matrix

$ A = mat(-1, 1; 1, -1) $

and the canonical basis

$ B = mat(1, 0; 0, 1) $

By applying $A$ to the canonical basis we obtain

$ A B = mat(-1, 1; 1, -1) mat(1, 0; 0, 1) = mat(-1, 1; 1, -1) $

that can be graphically represented as

#figure(
  cetz.canvas({
    import cetz.draw: *

    rect((0, 0), (1, 1), fill: luma(230))
    line((0, 0), (1, 0), stroke: 1.5pt, mark: (end: ">", fill: black))
    line((0, 0), (0, 1), stroke: 1.5pt, mark: (end: ">", fill: black))

    line((1.5, 0.5), (2.5, 0.5), stroke: 1.5pt, mark: (end: ">", fill: black))

    line((4, 0.5), (3, 1.5), stroke: 1.5pt, mark: (end: ">", fill: black))
    line((4, 0.5), (5, -0.5), stroke: 1.5pt, mark: (end: ">", fill: black))
    circle((4, 0.5), fill: black, radius: 0.05)
  }),
)

clearly showing that a matrix with determinant equal to zero squishes vectors
onto a lower dimensional space.

Let's analyze better this connection of the determinant with the invertibilty of
a matrix. A matrix with determinant equal to zero means that it has vectors that
span a zero volume hypercube. While the condition for a matrix to be invertible
is that must exists a matrix $A^(-1)$ such that

$ A A^(-1) = I $

This two things are related from the fact that if we do the math, it comes out
(for $2 times 2$ matrices) that the inverse of $A$ is

$ A^(-1) = frac(1, a d - b c) mat(d, -b; -c, a) $

but this can be computed only if the denominator is not zero. Since the
denominator is the determinant of $A$ the theorem results true for $2 times 2$
matrices, but a similar concept holds for $n times n$ matrices as well.

The determinant has also some nice properties, like every linear operator, like

- $det(A B) = det(A) det(B)$
- $det(A) = det(A^T)$
- $det(lambda A) = lambda^n det(A)$

and the fact that for triangular (lower and upper) matrices can be computed as

$ det(A) = product_(i=1)^N A_(i i) $

where $A_(i i)$ are the diagonal elements of $A$ and this useful in combination
with the *Cholesky factorization*, that splits a matrix in two triangular matrices.


#important(title: [ Laplace Expansion ])[
  Consider a square matrix $A$, then for all $j = 1, dots, n$

  - Expansion along column $j$:
    $ det(A) = sum_(k=1)^n (-1)^(k + j) a_(k j) det(A_(k, j)) $
  - Expansion along row $j$:
    $ det(A) = sum_(k=1)^n (-1)^(k + j) a_(j k) det(A_(j, k)) $

  where $A_(k, j) in RR^((n-1) times (n-1))$ is the submatrix of $A$ obtained by
  deleting row $k$ and column $j$.
]

For the general computation of the determinant we can exploit the *Laplace
expansion theorem*, which induces a recursive algorithm for the determinant
computation.
