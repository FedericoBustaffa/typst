#import "@local/note_template:0.1.0": *
#show: doc => note_template([Low Rank Approximation], doc)

#title()

If we take a look at the rank of $A$, we can see that it is equal to the number
of strictly positive singular values. In fact is possible to write $A$ as the
sum of $r = "rank"(A)$ terms of rank equal to $1$:

$ A_i = u_i v_i^T $

If we multiply the $i$-th singular value we obtain a rank 1 matrix built with
the $i$-th singular value, left singular vector and right singular vector. If we
consider all the non-zero singular value (that are $r = rank(A)$, we obtain $A$
by summing them:

$
  A = sigma_1 u_1 v_1^T + dots.c + sigma_r u_r v_r^T
  = sum_(i=1)^r sigma_i u_i v_i^T
$

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

Sometimes we have to deal with rectangular matrices that are _big_ and _complex_
but its information is contained only in few directions. In those cases is
possible to approximate it with a lower rank matrix mantaining as much as
possible its information.

Since a matrix $A$ can be obtained by sum of rank-1 matrices like saw before, if
we stop the sum up to $k < r$ we obtain an *approximation* of $A$

$ A_k = sum_(i=1)^k sigma_i u_i v_i^T $

Given $A in RR^(m times n)$ and an integer $k < "rank"(A)$, the *low-rank
approximation* of $A$ of rank $k$ is a matrix $tilde(A)$ such that

$ tilde(A) = arg min_("rank"(B) = k) || A - B ||_F $

that is, we’re searching the, among all the matrices with rank $k$, the closest
to $A$ with respect to Frobenius (or spectral) norm.

#important(title: "Eckart-Young Theorem")[
  Given $A in RR^(m times n)$ with rank $r$, the best approximation of rank $k$
  is given by the _truncated_ SVD of $A$

  $ A_k = sigma_1 u_1 v_1^T + dots.c + sigma_k u_k v_k^T $

  with $k <= r$.
]

In other words if

$
  A = U Sigma V^T =
  sigma_1 u_1 v_1^T + dots.h.c + sigma_r u_r v_r^T
$

then a minimizer of

$ min_("rank"(B) <= k) || A - B ||_F $

is given by

$
  A = U Sigma V^T =
  sigma_1 u_1 v_1^T + dots.h.c + sigma_k u_k v_k^T
$

