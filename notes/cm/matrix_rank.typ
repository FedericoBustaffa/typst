= Matrix Rank
<matrix-rank>
The matrix #strong[rank] is a useful value that provides some
information about the matrix itself, that can be also useful check
linear systems has solutions and could be useful for many other
purposes.

#quote(block: true)[
\[!NOTE\] Rank The number of linearly independent columns of matrix
$A in bb(R)^(m times n)$ is called the (column) #strong[rank] of $A$ and
it’s denoted with $upright("rank") (A)$.
]

The rank, as we were saying before has a lot of interesting properties:

- $upright("rank") (A) = upright("rank") (A^tack.b)$, that means that
  the column rank is equal to the row rank.
- The columns of $A$ #emph[span] a subspace $U subset.eq bb(R)^m$ with
  dimension $dim (U) = upright("rank") (A)$. And of course the same is
  also true for the row rank, except that the subspace is
  $U subset.eq bb(R)^n$.
- A square matrix $A in bb(R)^(n times n)$ is invertible if and only if
  $upright("rank") (A) = n$.
- A linear system $A x = b$ can be solved if and only if
  $upright("rank") (A) = upright("rank") (A \| b)$.
- Given $A in bb(R)^(m times n)$, the subspace of the system $A x = 0$
  has dimension $n - upright("rank") (A)$.

Another important property for matrices is the #emph[full rank]

#quote(block: true)[
\[!NOTE\] Full Rank A matrix $A in bb(R)^(m times n)$ has #strong[full
rank] if its rank is equal to the largest possible rank for a matrix of
the same size: $ upright("rank") (A) = min (m , n) $
]

In general we can compute the rank of a matrix $A$ by reducing $A$ in
#emph[Row-Echelon] form and count the number of linearly independent
columns.

A slight different definition is about a full column rank matrix.

#quote(block: true)[
\[!NOTE\] Full Column Rank A matrix $A in bb(R)^(m times n)$ has
#strong[full column rank] if its rank is equal to the number of her
columns.
]

It’s clear that if the matrix is rectangular and wide ($m < n$) the
matrix cannot be a #emph[full column rank];, because the maximum rank is
the minimum between the number of rows and columns.

Another definition states that a matrix $A in bb(R)^(m times n)$ is a
full column rank if $ker (A) = { 0 }$. In other words there is no
vectore $v eq.not 0$ such that $A v = 0$.

#quote(block: true)[
\[!NOTE\] Theorem A matrix $A in bb(R)^(m times n)$ has full column rank
if and only if $A^tack.b A$ is SPD.
]

== References
<references>
- \[\[linear\_algebra\]\]
- \[\[linear\_independence\]\]
- \[\[linear\_systems\]\]
- \[\[eigenvalues\_eigenvectors\]\]
