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

#important(title: [ Theorem ])[
  Any square matrix is *invertible* if and only if

  $ det (A) != 0 $
]

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
