#import "@local/note_template:0.1.0": *
#show: doc => note_template([Matrix Norms], doc)

#title()

As vectors, also matrices has the concept of _norm_ and it is quite
similar; in fact a *matrix norm* is a function

$ norm(dot.op) : { "matrices" } arrow.r bb(R) $

that needs to satisfy 4 properties:

- $norm(A) gt.eq 0$ for all $A$ and
  $norm(A) = 0$ if and only if $A = 0$.
- $norm(alpha A) = lr(|alpha|) dot.op norm(A)$
  for all scalars $alpha$ and all $A$.
- $norm(A + B) lt.eq norm(A) + norm(B)$
  for all $A , B$ (triangle inequality).
- $norm(A B) lt.eq norm(A) dot.op norm(B)$
  for all $A , B$ (sub-multiplicativity)

Starting from a vector norm is possible to define a matrix norm, defining the so
called *induced matrix norm*, that is defined, given a vector norm
$norm(dot.op)$ as

$ norm(A) = max_(v != 0) frac(norm(A v), norm(v)) $

in fact we also can say that if $norm(dot.op)$ is an induced matrix
norm, then for any $A$ and for any $v$, we have

$ norm(A v) <= norm(A) dot.op norm(v) $

= Spectral Norm <spectral-norm>

The matrix norm induced by the Euclidean norm is called *spectral norm*
that has an interesting property: if $Q_1$ and $Q_2$ are two orthogonal matrices
of dimension $n times n$ and $A in bb(R)^(n times n)$ then

$ norm(Q_1 A Q_2) = norm(A) $

and this is because

$
  norm(Q_1 A Q_2) & = max_(v != 0) frac(norm(Q_1 A Q_2 v), norm(v)) \
                  & = max_(v != 0) frac(norm(A Q_2 v), norm(Q_2 v)) \
                  & = max_(z != 0) frac(norm(A z), norm(z)) = norm(A)
$

And this is interesting because in the SVD we have the left and right matrices
that are orthogonal like $Q_1$ and $Q_2$ and so

$
  norm(A) = norm(U Sigma V^T) =
  norm(Sigma) = sigma_1
$

that is the maximum singular value of $A$.

= Frobenius Norm <frobenius-norm>

Another interesting norm that has a relation with SVD is the *Frobenius norm*

$ norm(A)_F = sqrt(sum_(i , j) a_(i j)^2) $

that is, like the spectral norm, _unitary invariant_, that is, for $Q_1$ and
$Q_2$ orthogonal it holds

$ norm(Q_1 A Q_2)_F = norm(A)_F $

and this implies that

$
  norm(A)_F = norm(U Sigma V^T)_F =
  norm(Sigma)_F = sqrt(sigma_1^2 + dots.h.c + sigma_n^2)
$

