#import "@local/note_template:0.1.0": *
#show: doc => note_template([Low Rank Approximation], doc)

#title()

Sometimes we have to deal with rectangular matrices that are _big_ and
_complex_ but its information is contained only in few directions. In that
case is possible to approximate it in a simpler, smaller and so, with a lower
rank matrix, mantaining as much as possible its information.

Given $A in bb(R)^(m times n)$ and an integer $k < upright("rank") (A)$, the
*low-rank approximation* of $A$ of rank $k$ is a matrix $tilde(A)$ such that

$ tilde(A) = arg min_(upright("rank") (B) = k) parallel A - B parallel_F $

that is, we’re searching the, among all the matrices with rank $k$, the closest
to $A$ with respect to Frobenius (or spectral) norm.

#important(title: "Eckart-Young Theorem")[
  Given $A in bb(R)^(m times n)$, the best approximation of rank $k$ is given by
  the _truncated_ SVD of $A$.
]

In other words if

$
  A = U Sigma V^tack.b =
  sigma_1 u_1 v_1^tack.b + dots.h.c + sigma_r u_r v_r^tack.b
$

then a minimizer of

$ min_(upright("rank") (B) lt.eq k) parallel A - B parallel_F $

is given by

$
  A = U Sigma V^tack.b =
  sigma_1 u_1 v_1^tack.b + dots.h.c + sigma_k u_k v_k^tack.b
$

