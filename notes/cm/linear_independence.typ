#import "@local/note_template:0.1.0": *
#show: note_template

#title("Linear Independence") <linear-independence>

Starting from basic vector operations (vector sum e multiplication by a scalar)
and thanks to the definition of closure with respect to those operations, is
possible to define what is a #emph[linear combination];, that a core concept in
linear algebra.

#important(title: "Linear Combination")[
  Given a set of vectors $x_1 , dots.h , x_n$, the vector
  $ v = lambda_1 x_1 + dots.h.c + lambda_n x_n = sum_(i = 1)^n lambda_i x_i $
  with $lambda_1 , dots.h , lambda_n in bb(R)$, is a *linear combination* of
  $x_1 , dots.h , x_n$.
]

Of course the $0$-vector is always a linear combination of $n$ vector and so, it
is typically more interesting the study of non trivial linear combinations,
where there is at least $lambda_i eq.not 0$, so that the resulting vector will
not be $0$.

#important(title: "Linear Independence")[
  Given a set of vectors $x_1 , dots.h , x_n$ and a set of coefficients
  $lambda_1 , dots.h , lambda_n$, if

  $ sum_(i = 1)^n lambda_i x_i = 0 $

  can be obtained only if $lambda_1 = dots.h.c = lambda_n = 0$, then the set of
  vectors is #strong[linearly independent];. If instead there is at least one
  $i$ sucht that $lambda_i eq.not 0$, the set is #strong[linearly dependent];.
]

This means that chosen a vector $x_i$, is not possible to express it as a linear
combination of the others. This is interesting because it says that this set of
vectors has no redundancy, and removing one of this vectors from set means to
lose something.

Another interesting analysis is to check if multiple linear combinations of a
linearly independent set of vectors is still linearly independent.

Let’s start from $n$ linearly independet vectors $b_1 , dots.h , b_n$ and $m$
linear combinations of them

$
  x_1 & = sum_(i = 1)^n lambda_(i 1) b_i \
      & dots.v \
  x_m & = sum_(i = 1)^n lambda_(i m) b_i
$

So we have also $m$ different sets of $lambda$ coefficients. If we now define
the matrix $B = [b_1 , dots.h , b_n]$ as the matrix, whose columns are the
linearly independent vectors $b_1 , dots.h , b_n$, we can say that the $j$-th
linear combination $x_j$ is

$ x_j = B upright(bold(lambda))_j $

where

$ lambda_j = mat(delim: "[", upright(bold(lambda))_(1 j); dots.v; lambda_n j) $

is the $j$-th set of coefficients for the $j$-th linear combination $x_j$. So if
we now want to test if vectors $x_1 , dots.h , x_m$ are linearly independent, we
can set

$
  0 = sum_(j = 1)^m psi_j B upright(bold(lambda))_j = B sum_(j = 1)^m psi_j
  upright(bold(lambda))_j
$

and this is true if and only if

$ sum_(j = 1)^m psi_j upright(bold(lambda))_j = 0 $

So we can conclude that $x_1 , dots.h , x_m$ are linearly independet vectors if
and only if the vectors composed by the $lambda$ coefficients of every linear
combination, are linearly independent.

= References <references>

- Linear Algebra
