#import "@local/note_template:0.1.0": *
#show: doc => note_template([Matrix Norms], doc)

#title()

As vectors, also matrices has the concept of #emph[norm] and it is quite
similar; in fact a #strong[matrix norm] is a function

$ || dot.op || : { upright("matrices") } arrow.r bb(R) $

that needs to satisfy $4$ properties:

- $|| A || gt.eq 0$ for all $A$ and
  $|| A || = 0$ if and only if $A = 0$.
- $|| alpha A || = lr(|alpha|) dot.op || A ||$
  for all scalars $alpha$ and all $A$.
- $|| A + B || lt.eq || A || + || B ||$
  for all $A , B$ (triangle inequality).
- $|| A B || lt.eq || A || dot.op || B ||$
  for all $A , B$ (sub-multiplicativity)

Starting from a vector norm is possible to define a matrix norm, defining the so
called #strong[induced matrix norm];, that is defined, given a vector norm
$|| dot.op ||$ as

$ || A || = max_(v eq.not 0) frac(|| A v ||, || v ||) $

in fact we also can say that if $|| dot.op ||$ is an induced matrix
norm, then for any $A$ and for any $v$, we have

$ || A v || <= || A || dot.op || v || $

= Spectral Norm <spectral-norm>

The matrix norm induced by the Euclidean norm is called #strong[spectral norm]
that has an interesting property: if $Q_1$ and $Q_2$ are two orthogonal matrices
of dimension $n times n$ and $A in bb(R)^(n times n)$ then

$ || Q_1 A Q_2 || = || A || $

and this is because

$
  || Q_1 A Q_2 || & = max_(v eq.not 0) frac(|| Q_1 A Q_2 v ||, || v ||) \
                  & = max_(v eq.not 0) frac(|| A Q_2 v ||, || Q_2 v ||) \
                  & = max_(z eq.not 0) frac(|| A z ||, || z ||) = || A ||
$

And this is interesting because in the SVD we have the left and right matrices
that are orthogonal like $Q_1$ and $Q_2$ and so

$
  || A || = || U Sigma V^tack.b || =
  || Sigma || = sigma_1
$

that is the maximum singular value of $A$.

= Frobenius Norm <frobenius-norm>

Another interesting norm that has a relation with SVD is the *Frobenius norm*

$ || A ||_F = sqrt(sum_(i , j) a_(i j)^2) $

that is, like the spectral norm, #emph[unitary invariant];, that is, for $Q_1$
and $Q_2$ orthogonal it holds

$ || Q_1 A Q_2 ||_F = || A ||_F $

and this implies that

$
  || A ||_F = || U Sigma V^tack.b ||_F =
  || Sigma ||_F = sqrt(sigma_1^2 + dots.h.c + sigma_n^2)
$

