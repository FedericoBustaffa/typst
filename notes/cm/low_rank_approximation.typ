#import "@local/note_template:0.1.0": *
#show: doc => note_template([Low Rank Approximation], doc)

#title()

Sometimes we have to deal with rectangular matrices that are _big_ and
_complex_ but its information is contained only in few directions. In that
case is possible to approximate it in a simpler, smaller and so, with a lower
rank matrix, mantaining as much as possible its information.

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

