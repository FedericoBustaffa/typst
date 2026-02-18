#import "@local/note_template:0.1.0": *
#show: note_template

#title("Matrix Norms") <matrix-norms>

As vectors, also matrices has the concept of #emph[norm] and it is quite
similar; in fact a #strong[matrix norm] is a function

$ parallel dot.op parallel : { upright("matrices") } arrow.r bb(R) $

that needs to satisfy $4$ properties:

- $parallel A parallel gt.eq 0$ for all $A$ and
  $parallel A parallel = 0$ if and only if $A = 0$.
- $parallel alpha A parallel = lr(|alpha|) dot.op parallel A parallel$
  for all scalars $alpha$ and all $A$.
- $parallel A + B parallel lt.eq parallel A parallel + parallel B parallel$
  for all $A , B$ (triangle inequality).
- $parallel A B parallel lt.eq parallel A parallel dot.op parallel B parallel$
  for all $A , B$ (sub-multiplicativity)

Starting from a vector norm is possible to define a matrix norm, defining the so
called #strong[induced matrix norm];, that is defined, given a vector norm
$parallel dot.op parallel$ as

$
  parallel A parallel = max_(v eq.not 0)
  frac(parallel A v parallel, parallel v parallel)
$

in fact we also can say that if $parallel dot.op parallel$ is an induced matrix
norm, then for any $A$ and for any $v$, we have

$ parallel A v parallel lt.eq parallel A parallel dot.op parallel v parallel $

= Spectral Norm <spectral-norm>

The matrix norm induced by the Euclidean norm is called #strong[spectral norm]
that has an interesting property: if $Q_1$ and $Q_2$ are two orthogonal matrices
of dimension $n times n$ and $A in bb(R)^(n times n)$ then

$ parallel Q_1 A Q_2 parallel = parallel A parallel $

and this is because

$
  parallel Q_1 A Q_2 parallel & = max_(v eq.not 0) frac(
    parallel Q_1 A Q_2 v
    parallel, parallel v parallel
  ) \
  & = max_(v eq.not 0) frac(parallel A Q_2 v parallel, parallel Q_2 v parallel) \
  & = max_(z eq.not 0) frac(parallel A z parallel, parallel z parallel) =
  parallel A parallel
$

And this is interesting because in the SVD we have the left and right matrices
that are orthogonal like $Q_1$ and $Q_2$ and so

$
  parallel A parallel = parallel U Sigma V^tack.b parallel =
  parallel Sigma parallel = sigma_1
$

that is the maximum singular value of $A$.

= Frobenius Norm <frobenius-norm>

Another interesting norm that has a relation with SVD is the *Frobenius norm*

$ parallel A parallel_F = sqrt(sum_(i , j) a_(i j)^2) $

that is, like the spectral norm, #emph[unitary invariant];, that is, for $Q_1$
and $Q_2$ orthogonal it holds

$ parallel Q_1 A Q_2 parallel_F = parallel A parallel_F $

and this implies that

$
  parallel A parallel_F = parallel U Sigma V^tack.b parallel_F =
  parallel Sigma parallel_F = sqrt(sigma_1^2 + dots.h.c + sigma_n^2)
$

= References <references>

- Linear Algebra
- Vector Norms
- Singular Value Decomposition
