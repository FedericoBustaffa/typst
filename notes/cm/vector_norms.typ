#import "@local/note_template:0.1.0": *
#show: doc => note_template([Vector Norms], doc)

#title()

The *norm of a vector* is a function that assigns a vector its _length_ in terms
of distance from the origin.

$ norm(dot) : RR^n -> RR $

but to be a _norm_ a function must respect these three properties:

+ $norm(v) gt.eq 0$ for all $v$ and
  $norm(v) = 0 arrow.l.r.double v = 0$.
+ $norm(alpha dot.op v) = lr(|alpha|) dot.op norm(v)$
  for all $alpha in bb(R)$ and for all vectors $v$.
+ *Triangular inequality*:
  $norm(v + w) lt.eq norm(v) + norm(w)$
  for all $v , w$.

There are several norms, used for different purposes, here some of the most
popular:

- *Euclidean*: if we think about it in two or three dimensional space it’s the
  direct distance between a point and the origin
  $ norm(v)_2 = sqrt(sum_(i = 1)^n v_i^2) $
  where $v_i$ is the $i$-th component of the vector $v$. It can also be written as
  the square root of product between the vector $v$ transposed and $v$ itself
  $ norm(v)_2 = sqrt(sum_(i = 1)^n v_i^2) = sqrt(v^tack.b v) $
  that is the definition of the square root of the scalar product between $v$ and
  itself.
  $
    norm(v)_2 = sqrt(sum_(i = 1)^n v_i^2) = sqrt(v^tack.b v) =
    sqrt(chevron.l v \, v chevron.r)
  $
  all these equalities can be useful for calculations.
- *Manhattan*: this represents the Manhattan distance between the point and the
  origin and it is basically the sum of the absolute values of each component of
  the vector:
  $ norm(v)_1 = sum_(i = 1)^n lr(|v_i|) $
- *Infinite*: this norm will take only the maximum among each component’s
  absolute value:
  $ norm(v)_oo = max_(i = 1 , dots.h , n) lr(|v_i|) $

Generally the euclidean norm is nice because there are many matrices that
preserve it, for example *orthogonal* matrices.

A nice thing to keep in mind is that, for any vector $v != 0$ we can write

$ v / (norm(v)) $

is the *unit vector* which basically gives us the _direction_ of the vector and
so we can write, hence

$ norm(v / (norm(v))) = 1 $

This is also implies that

$ v = alpha dot w $

where $alpha = norm(v)$ and $w = v / norm(v)$ is the
unit vector.

A particular vector norm, useful for some numerical approach like _conjugate
gradient method_, is the *A-norm*, defined with a SPD matrix $A$ as

$ norm(v)_A = sqrt(v^TT A v) $

that for $A = I$ is equivalent to the euclidean norm.

