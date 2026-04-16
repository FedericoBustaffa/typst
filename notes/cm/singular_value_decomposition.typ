#import "@local/note_template:0.1.0": *
#show: doc => note_template([Singular Value Decomposition], doc)

#title()

The *singular value decomposition (SVD)* is a way to the decompose every matrix
$A in bb(R)^(m times n)$ in a product of three matrices

$ A = U Sigma V^T $

where $U in bb(R)^(m times m)$ and $V in bb(R)^(n times n)$ orthogonal and
$Sigma in bb(R)^(m times n)$ is diagonal, where, on the diagonal we have the so
called *singular values* $sigma_1 , dots.h , sigma_min(m, n)$, such that

$ sigma_1 >= sigma_2 >= dots.h >= sigma_(min (m , n)) >= 0 $

Singular values are unique, while $U$ and $V$, in general, are not; in other
words, the singular values depend only on the matrix $A$, while there are
multiple choices of $U$ and $V$ that keep the decomposition valid.

As said, $sigma_1 , dots.h , sigma_(min (m , n))$ are the singular values of
$A$, while the columns of $U$ are called the *left singular vectors* of $A$ and
in a similar way, the rows of $V^T$ (or the columns of $V$) are called the
*right singular vectors* of $A$.

= SVD and Eigenvalues <svd-and-eigenvalues>

By taking a look at the SVD formula it seems something of the same flavour of
the eigen decomposition. Let's for example take a matrix $A in bb(R)^(m times
n)$ such that $A = U Sigma V^T$, then

$
  A^T A & = (U Sigma V^T)^T (U Sigma V^T) \
        & = V Sigma^T U^T U Sigma V^T \
        & = V Sigma^T Sigma V^T = V Sigma^2 V^T
$

That is the *spectral decomposition* of $A^T A$ from which we can deduce
that $sigma_1 , dots.h , sigma_n$ are the singular values of $A$ if and only if
$sigma_1^2 , dots.h , sigma_n^2$ are the eigenvalues values of $A^T A$.

Now we can exploit this fact to prove that, for every matrix $A$ there is a
valid SVD $A = U Sigma V^T$. We can see that $V^T$ is the same for
both decomposition, for the spectral decomposition we can say that $D =
Sigma^2$, so $Sigma = D^(1/2)$. Now is possible to write

$
             A & = U D^(1/2) V^T \
           A V & = U D^(1/2) \
  A V D^(-1/2) & = U
$

and so we can substitute $U$ in the first equation

$ A & = A V D^(-1/2) D^(1/2) V^T & = A V V^T = A $

so indeed this is a decomposition of $A$; to be sure that is a SVD we have to
check that $U$ and $V^T$ are orthogonal and $Sigma$ is diagonal with all
the properties described before for the singular values.

Let's just see if $U$ is orthogonal just by checking if $U^T U = I$:

$
  U^T U & = (A V D^(-1/2))^T A V D^(-1/2) \
        & = D^(-1/2) V^T A^T A V D^(-1/2) \
        & = D^(-1/2) V^T (U Sigma V^T)^T U Sigma V^T V D^(-1/2) \
        & = D^(-1/2) V^T V Sigma^T U^T U Sigma V^T V D^(-1/2) \
        & = D^(-1/2) D^(1/2) D^(1/2) D^(-1/2) = I
$

that proves $U$ being an orthogonal matrix.

== Rank

If we take a look at the rank of $A$, we can see that it is equal to the number
of strictly positive singular values. In fact is possible to write $A$ as the
sum of $r = "rank"(A)$ terms of rank equal to $1$.

$ A = sigma_1 u_1 v_1^T + dots.c + sigma_r u_r v_r^T $

where $u_i$ is a column of $U$ and $v_i^T$ is a row of $V^T$. In other
words, to write $A$ we only need the first $r = "rank"(A)$ singular
values, left and right singular vectors.

This leads to a more compact representation of $A$ and the SVD in general that
takes the name of *thin* (or *economy*) SVD of a rectangular _tall_ matrix $A in
RR^(m times n)$ ($m > n$). In this form the columns of $U$ are orthonormal.

The SVD gives also some information on the $4$ fundamental subspaces of $A$

- $im(A) = "span"(u_1 , dots.h , u_r)$
- $ker(A) = "span"(v_(r + 1) , dots.h , v_n)$
- $im(A^T) = "span"(v_1 , dots.h , v_r)$
- $ker(A^T) = "span"(u_(r + 1) , dots.h , u_m)$

In fact we can for example test it like this

$ A = sigma_1 u_1 v_1^T + dots.h + sigma_r u_r v_r^T $

and so

$
  A v_(r + 1) = sigma_1 u_1 v_1^T v_(r + 1) + dots.h +
  sigma_r u_r v_r^T v_(r + 1) = 0
$

because every $v_i^T v_(r + 1) = 0$.

