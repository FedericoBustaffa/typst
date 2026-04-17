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

Since we want to compress $A$ as much as possible while keeping the core
informations, we are basically trying to minimize $norm(A - B)$ for some matrix
norm $norm(dot)$, by searching a matrix $B$ in the space of matrices of the same
size as $A$ but with rank $k <= r$.

Given $A in RR^(m times n)$ and an integer $k < "rank"(A)$, the *low-rank
approximation* of $A$ of rank $k$ is a matrix $tilde(A)$ such that

$ tilde(A) = arg min_("rank"(B) = k) || A - B ||_F $


that is, we're searching among all the matrices with rank $k$, the closest to
$A$ with respect to Frobenius (or spectral) norm. We can perform this task with
some iterative approach but with SVD comes also a crucial result.

#important(title: "Eckart-Young Theorem")[
  Given $A in RR^(m times n)$ with rank $r$, the best approximation of rank $k$
  is given by the _truncated_ SVD of $A$

  $
    A_k = sigma_1 u_1 v_1^T + dots.c + sigma_k u_k v_k^T
    = sum_(i=1)^k sigma_i u_i v_i^T
  $

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

This low rank approximation is the basis for many algorithms but one of the most
visual application is given by image compression; let's consider this image

#figure(image("images/dog.jpg", width: 45%))

in grey scale that corresponds to a rank 430 matrix and let's see how different
low rank approximations via SVD are capable of reconstruct the original image:

#figure(
  grid(
    rows: 4,
    columns: 2,
    row-gutter: 4pt,
    "Rank 1", "Rank 5",
    image("images/dog_1.jpg", width: 100%),
    image("images/dog_5.jpg", width: 100%),

    "Rank 25", "Rank 125",
    image("images/dog_25.jpg", width: 100%),
    image("images/dog_125.jpg", width: 100%),
  ),
  caption: [ Image Low Rank Approximation ],
)

As we can see the rank 25 approximation already gives us a nice image in which
the dog is easily recognizable, while with rank 125 becomes hard to tell the
difference from the original picture.
