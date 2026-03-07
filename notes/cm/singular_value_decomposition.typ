#import "@local/note_template:0.1.0": *
#show: doc => note_template([Singular Value Decomposition], doc)

#title()

The *singular value decomposition (SVD)* is a way to the decompose every matrix
$A in bb(R)^(m times n)$ in a product of three matrices

$ A = U Sigma V^tack.b $

where $U in bb(R)^(m times m)$ and $V in bb(R)^(n times n)$ orthogonal and
$Sigma in bb(R)^(m times n)$ is diagonal, where, on the diagonal we have the so
called *singular values* $sigma_1 , dots.h , sigma_min(m, n)$, such that

$ sigma_1 gt.eq sigma_2 gt.eq dots.h gt.eq sigma_(min (m , n)) gt.eq 0 $

Singular values are unique, while $U$ and $V$, in general, are not; in other
words, the singular values depend only on the matrix $A$, while there are
multiple choices of $U$ and $V$ that keep the decomposition valid.

As said, $sigma_1 , dots.h , sigma_(min (m , n))$ are the singular values of
$A$, while the columns of $U$ are called the *left singular vectors* of $A$ and
in a similar way, the rows of $V^tack.b$ (or the columns of $V$) are called the
*right singular vectors* of $A$.

= SVD and Eigenvalues <svd-and-eigenvalues>

By taking a look at the SVD formula it seems something with the same flavour of
the eigen decomposition. Let's for example take a matrix $A in bb(R)^(m times
n)$ such that $A = U Sigma V^tack.b$, then

$
  A^tack.b A & = (U Sigma V^tack.b)^tack.b (U Sigma V^tack.b) & \
  & = V Sigma^tack.b U^tack.b U Sigma V^tack.b & U^tack.b U = I\
  & = V Sigma^tack.b Sigma V^tack.b = V Sigma^2 V^tack.b & Sigma = Sigma^tack.b
$

That is the *spectral decomposition* of $A^tack.b A$ from which we can deduce
that $sigma_1 , dots.h , sigma_n$ are the singular values of $A$ if and only if
$sigma_1^2 , dots.h , sigma_n^2$ are the eigenvalues values of $A^tack.b A$.

Now we can exploit this fact to prove that, for every matrix $A$ there is a
valid SVD $A = U Sigma V^tack.b$. We can see that $V^tack.b$ is the same for
both decomposition, for the spectral decomposition we can say that $D =
Sigma^2$, so $Sigma = D^(1/2)$. Now is possible to write

$
             A & = U D^(1/2) V^tack.b \
           A V & = U D^(1/2) \
  A V D^(-1/2) & = U
$

and so we can substitute $U$ in the first equation

$
  A & = A V D^(-1/2) D^(1/2) V^tack.b \
    & = A V V^tack.b = A
$

so indeed this is a decomposition of $A$; to be sure that is a SVD we have to
check that $U$ and $V^tack.b$ are orthogonal and $Sigma$ is diagonal with all
the properties described before for the singular values.

Let's just see if $U$ is orthogonal just by checking if $U^tack.b U = I$:

$
  U^tack.b U & = (A V D^(-1/2))^tack.b A V D^(-1/2) \
  & = D^(-1/2) V^tack.b A^tack.b A V D^(-1/2) \
  & = D^(-1/2) V^tack.b (U Sigma V^tack.b)^tack.b U Sigma V^tack.b V D^(-1/2) \
  & = D^(-1/2) V^tack.b V Sigma^tack.b U^tack.b U Sigma V^tack.b V D^(-1/2) \
  & = D^(-1/2) D^(1/2) D^(1/2) D^(-1/2) = I
$

that proves $U$ being an orthogonal matrix.

== Rank

If we take a look at the rank of $A$, we can see that it is equal to the number
of strictly positive singular values. In fact is possible to write $A$ as the
sum of $r = "rank"(A)$ terms of rank-$1$.

$ A = sigma_1 u_1 v_1^tack.b + dots.c + sigma_r u_r v_r^tack.b $

where $u_i$ is a column of $U$ and $v_i^tack.b$ is a row of $V^tack.b$. In other
words, to write $A$ we only need the first $r = "rank"(A)$ singular
values, left and right singular vectors.

This leads to a more compact representation of $A$ and the SVD in general that
takes the name of *thin* SVD of a rectangular #emph[tall] matrix $A in bb(R)^(m
times n)$ ($m > n$). In this form the columns of $U$ are orthonormal.

The SVD gives also some information on the $4$ fundamental subspaces of $A$

- $im(A) = "span"{ u_1 , dots.h , u_r }$
- $ker(A) = "span"{ v_(r + 1) , dots.h , v_n }$
- $im(A^tack.b) = "span"{ v_1 , dots.h , v_r }$
- $ker(A^tack.b) = "span"{ u_(r + 1) , dots.h , u_m }$

In fact we can for example test it like this

$ A = sigma_1 u_1 v_1^tack.b + dots.h + sigma_r u_r v_r^tack.b $

and so

$
  A v_(r + 1) = sigma_1 u_1 v_1^tack.b v_(r + 1) + dots.h + sigma_r u_r
  v_r^tack.b v_(r + 1) = 0
$

because every $v_i^tack.b dot.op v_(r + 1) = 0$.

