#import "@local/note_template:0.1.0": *
#show: doc => note_template([Matrix Rank], doc)

#title()

The matrix *rank* is a useful value that provides information about the matrix,
and if the matrix represents a linear systems it can be used to check if it has
solutions.

#important(title: "Rank")[
  The number of linearly independent columns of matrix $A in bb(R)^(m times n)$
  is called the (column) *rank* of $A$ and it’s denoted with
  $"rank"(A)$.
]

Is also possible to consider the rows of the matrix and we will obtain the same
exact rank.

#important[
  The column rank is equal to the row rank. This also means that
  $ "rank"(A) = "rank"(A^T) $
]

The rank, as we were saying before has a lot of interesting properties:

- The columns of $A$ _span_ a subspace $U subset.eq bb(R)^m$ with dimension
  $dim (U) = "rank"(A)$. And of course the same is also true for the
  row rank, except that the subspace is $U subset.eq bb(R)^n$.
- A square matrix $A in bb(R)^(n times n)$ is *invertible* if and only if
  $"rank"(A) = n$.
- A linear system $A x = b$ can be solved if and only if
  $"rank"(A) = "rank"(A \| b)$.
- Given $A in bb(R)^(m times n)$, the subspace of the system $A x = 0$ has
  dimension $n - "rank"(A)$.

Another important property for matrices is the _full rank_

#important(title: "Full Rank")[
  A matrix $A in bb(R)^(m times n)$ has *full rank* if its rank is equal to the
  largest possible rank for a matrix of the same size:
  $"rank"(A) = min (m , n)$
]

In general we can compute the rank of a matrix $A$ by reducing $A$ in
_Row-Echelon_ form and count the number of linearly independent columns.

A slight different definition is about a full column rank matrix.

#important(title: "Full Column Rank")[
  A matrix $A in bb(R)^(m times n)$ has *full column rank* if its rank is
  equal to the number of her columns.
]

It’s clear that if the matrix is rectangular and wide ($m < n$) the matrix
cannot be a _full column rank_, because the maximum rank is the minimum between
the number of rows and columns.

Another definition states that a matrix $A in bb(R)^(m times n)$ is a full
column rank if $ker (A) = { 0 }$. In other words there is no vectore $v eq.not
0$ such that $A v = 0$.

#important(title: "Theorem")[
  A matrix $A in bb(R)^(m times n)$ has full column rank if and only if $A^T A$
  is SPD.
]

