#import "@local/note_template:0.1.0": *
#show: doc => note_template([Singular Value Decomposition], doc)

#title[Singular Value Decomposition]

The #strong[singular value decomposition] (#strong[SVD];) is a way to the
decompose every matrix $A in bb(R)^(m times n)$ in a product of three matrices

$ A = U Sigma V^tack.b $

where $U in bb(R)^(m times m)$ and $V in bb(R)^(n times n)$ orthogonal and
$Sigma in bb(R)^(m times n)$ diagonal, where, on the diagonal we have the so
called #strong[singular values];:

$ { sigma_1 , dots.h , sigma_(min (m , n)) } $

The singular values have the following interesting property

$ sigma_1 gt.eq sigma_2 gt.eq dots.h gt.eq sigma_(min (m , n)) gt.eq 0 $

Singular values are unique, while $U$ and $V$, in general, are not; in other
words, the singular values depend only on the matrix $A$, while there are
multiple choices of $U$ and $V$ that keep the decomposition valid.

As said, ${ sigma_1 , dots.h , sigma_(min (m , n)) }$ are the singular values of
$A$, while the columns of $U$ are called the #strong[left singular vectors] of
$A$ and in a similar way, the rows of $V^tack.b$ (or the columns of $V$) are
called the #strong[right singular vectors] of $A$.

= SVD and Eigenvalues <svd-and-eigenvalues>

By taking a look at the SVD formula and, most importantly at the $Sigma$ matrix,
it seems that the SVD is a generalization of the eigen decomposition for square
matrices.

We can in fact take a matrix $A in bb(R)^(m times n) = U Sigma V^tack.b$
and see that

$
  A^tack.b A & = (U Sigma V^tack.b)^tack.b (U Sigma V^tack.b) & \
  & = V Sigma^tack.b U^tack.b U Sigma V^tack.b & U^tack.b U = I\
  & = V Sigma^tack.b Sigma V^tack.b = V Sigma^2 V^tack.b & Sigma = Sigma^tack.b
$

That is the #strong[spectral decomposition] of $A^tack.b A$ from which we can
deduce that $sigma_1 , dots.h , sigma_n$ are the singular values of $A$ if and
only if $sigma_1^2 , dots.h , sigma_n^2$ are the eigenvalues values of $A^tack.b
A$.


If we take a look at the rank of $A$, we can see that it is equal to the number
of strictly positive singular values. In fact is possible to write $A$ as the
sum of $r = upright("rank") (A)$ terms of rank-$1$.

$ A = sigma_1 u_1 v_1^tack.b + dots.h.c + sigma_r u_r v_r^tack.b $

where $u_i$ is a column of $U$ and $v_i^tack.b$ is a row of $V^tack.b$. In other
words, to write $A$ we only need the first $r = upright("rank") (A)$ singular
values, left and right singular vectors.

This leads to a more compact representation of $A$ and the SVD in general that
takes the name of #strong[thin] SVD of a rectangular #emph[tall] matrix $A in
bb(R)^(m times n)$ ($m > n$). In this form the columns of $U$ are orthonormal.

The SVD gives also some information on the $4$ fundamental subspaces of $A$

- $upright("Im") (A) = upright("span") { u_1 , dots.h , u_r }$
- $upright("Ker") (A) = upright("span") { v_(r + 1) , dots.h , v_n }$
- $upright("Im") (A^tack.b) = upright("span") { v_1 , dots.h , v_r }$
- $upright("Ker") (A^tack.b) = upright("span") { u_(r + 1) , dots.h , u_m }$

In fact we can for example test it like this

$ A = sigma_1 u_1 v_1^tack.b + dots.h + sigma_r u_r v_r^tack.b $

and so

$
  A v_(r + 1) = sigma_1 u_1 v_1^tack.b v_(r + 1) + dots.h + sigma_r u_r
  v_r^tack.b v_(r + 1) = 0
$

because every $v_i^tack.b dot.op v_(r + 1) = 0$.

= References <references>

- Linear Algebra
- Eigenvalues Eigenvectors
- Computational Mathematics
- Least Squares
