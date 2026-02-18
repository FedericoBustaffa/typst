#import "@local/note_template:0.1.0": *
#show: note_template

#title("Vector Norms") <vector-norms>

In order to measure vectors #emph[length] there are some metrics that can be
used, called #strong[norms];, functions

$ parallel dot.op parallel : bb(R)^n arrow.r bb(R) $

but to be a #emph[norm] a function must respect these three properties:

+ $parallel v parallel gt.eq 0$ for all $v$ and
  $parallel v parallel = 0 arrow.l.r.double v = 0$.
+ $parallel alpha dot.op v parallel = lr(|alpha|) dot.op parallel v parallel$
  for all $alpha in bb(R)$ and for all vectors $v$.
+ #strong[Triangular inequality];:
  $parallel v + w parallel lt.eq parallel v parallel + parallel w parallel$
  for all $v , w$.

There are several norms, used for different purposes, here some of the most
popular:

- #strong[Euclidean];: if we think about it in two or three dimensional space
  it’s the direct distance between a point and the origin
  $ parallel v parallel_2 = sqrt(sum_(i = 1)^n v_i^2) $
  where $v_i$ is the $i$-th component of the vector $v$. It can also be written as
  the square root of product between the vector $v$ transposed and $v$ itself
  $ parallel v parallel_2 = sqrt(sum_(i = 1)^n v_i^2) = sqrt(v^tack.b v) $
  that is the definition of the square root of the scalar product between $v$ and
  itself.
  $
    parallel v parallel_2 = sqrt(sum_(i = 1)^n v_i^2) = sqrt(v^tack.b v) =
    sqrt(chevron.l v \, v chevron.r)
  $
  all these equalities can be useful for calculations.
- #strong[Manhattan];: this represents the Manhattan distance between the point
  and the origin and it is basically the sum of the absolute values of each
  component of the vector:
  $ parallel v parallel_1 = sum_(i = 1)^n lr(|v_i|) $
- #strong[Infinite];: this norm will take only the maximum among each
  component’s absolute value:
  $ parallel v parallel_oo = max_(i = 1 , dots.h , n) lr(|v_i|) $

Generally the euclidean norm is nice because there are many matrices that
preserve it, for example #strong[orthogonal] matrices.

A useful fact that is indipendent of the norm used is that for any vector
$v eq.not 0$ we can write

$ v = alpha dot.op w $

where $alpha = parallel v parallel$ and $w = v \/ parallel v parallel$ is the
unit vector.

= References <references>

- Linear Algebra
