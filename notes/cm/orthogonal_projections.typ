#import "@local/note_template:0.1.0": *
#show: doc => note_template([Orthogonal Projections], doc)

#title()

An important type of transformations are *orthogonal projections* that let us
deal with high dimensional data, by making possible to _project_ vectors onto a
lower dimensional vector space.

Usually this is meaningful and have sense because only few dimensions contain
useful information, but of course _compress_ vectors means losing some
information in most cases.

What we want to achieve with orthogonal projections is a compression with
minimum information loss. This also implies that the projection (compression)
_extract_ the most important features of the original space.

Orthogonal projections do this already due to their _orthogonal_ nature. Let's
say for example that we want to project 2-D vectors onto a 1-D vector space (a
line):

#figure(
  lq.diagram(
    aspect-ratio: 1,
    lq.line((0.1, 0.1), (0.9, 0.9)),
    lq.line((0.5, 0.1), (0.3, 0.3), stroke: red),
    lq.line((0.8, 0.6), (0.7, 0.7), stroke: red),
    lq.line((0.4, 0.6), (0.5, 0.5), stroke: red),

    lq.scatter((0.5, 0.8, 0.4), (0.1, 0.6, 0.6)),
    lq.scatter((0.3, 0.7, 0.5), (0.3, 0.7, 0.5), color: red),
  ),
  caption: [ 2-D Vectors Projected onto 1-D Space ],
) <fig-2d-to-1d>

As shown in @fig-2d-to-1d the aim is to move in the direction of the orthogonal
vector with respect to the target vector space. In order to do that is
reasonable to think about some transformation we can apply to vectors in order
to map them onto the lower dimensional space.

#important(title: [Definition])[
  Let $V$ be a vector space and $U subset.eq V$ a subspace of $V$, then a linear
  mapping $pi : V -> U$ is called *projection* if
  $ pi^2 = pi compose pi = pi $
]

Since linear mappings can be expressed as transformation matrices, we can obtain
the *projection matrix* $P_pi$ for which it holds

$ P_pi^2 = P_pi $

that can be applied as any other transformation matrix.

= Projections on 1-D Subspaces

The most simple case of projection can be achieved by map high-dimensional
vectors onto a 1-D space like before and this also can be nicely represent
graphically.

Let's consider a line through the origin with basis vector $b in RR^n$, which is
a 1-D subspace $U subset.eq RR^n$ spanned by $b$.

Projecting a vector $x$ onto $U$ means that there is a point $pi_U (x)$ in $U$
that is the closest to $x$. And the fact that the distance is minimal means also
that $norm(x - pi_U (x))$ is minimal.

It follows that $pi_U (x) - x$ is an orthogonal segment to $U$ and therefore is
also orthogonal to the basis vector $b$ that spans it:

$ iprod(x - pi_U (x), b) = 0 $

Intuitively we have to move along $U$ until we find that point such that the
scalar product above is zero. The point $pi_U (x)$ must be an element of $U$
(the line) that is a multiple of $b$. So

$ pi_U (x) = lambda b $

Let's define a three step algorithm to project a vector onto a 1-D subspace.

+ *Find scaling factor $lambda$ of $b$*: orthogonality condition holds, so

  $ iprod(x - pi_U (x), b) = 0 <==> iprod(x - lambda b, b) = 0 $

  so by applying the bilinearity of the inner product we obtain

  $
    iprod(x, b) - lambda iprod(b, b) = 0 <==>
    lambda = iprod(x, b) / iprod(b, b) = iprod(x, b) / norm(b)^2
  $

  that for inner products symmetry becomes

  $
    lambda = iprod(x, b) / norm(b)^2 = iprod(b, x) / norm(b)^2
    = (b^T x) / norm(b)^2
  $

  So this i
+ *Find the projection point $pi_U (x)$*: since $pi_U (x) = lambda b$ it holds that

  $ pi_U (x) = lambda b = (b^T x) / norm(b)^2 b $

  and we can also compute the length of $pi_U (x)$, simply by the norm

  $ norm(pi_U (x)) = norm(lambda b) = |lambda| dot norm(b) $

  that if we use the dot product as inner product is

  $
    norm(pi_U (x)) = (|b^T x|) / norm(b)^2 norm(b)
    = |cos(omega)| norm(x) norm(b) norm(b) / norm(b)^2
    = |cos(omega)| norm(x)
  $

  with $omega$ that is the angle between $x$ and $b$.
+ *Find the projection matrix $P_pi$*: the projection is a linear mapping,
  therefore exists a projection matrix $P_pi$ such that

  $ pi_U (x) = P_pi dot x $

  that is immediate to find because we already know that

  $
    pi_U (x) = lambda b = b lambda = (b^T x) / norm(b)^2 = (b b^T) / norm(b)^2 x
  $

  that means that we already have our matrix

  $ P_pi = (b b^T) / norm(b)^2 $

  that is symmetric and has rank $1$.

= Projections on General Subspaces

The process to _project_ a vector to a general subspace $U$ such that $dim(U) =
m >= 1$ is not really different from the base case. Now the subspace is spanned
by a set of vector or, more precisely, by a basis $B = {b_1, dots, b_m}$;
therefore the vector $pi_U (x)$ is represented as linear combination of that
basis:

$ pi_U (x) = sum_(i=1)^m lambda_i b_i $

and the three step algorithm is basically the same:

+ *Find the scaling factors $lambda_1, dots, lambda_m$*: we can represent the
  above sum as a matrix-vector product

  $ pi_U (x) = sum_(i=1)^m lambda_i b_i = B lambda $

  and since we want the vector $x$ to be mapped to the closest point on $U$, we
  need to find orthogonal directions. The multiplication above is clearly a
  linear system, defining the arrival point. The idea is that the point $pi_U
  (x)$ must be orthogonal to $x$ in every of its components, so

  $
    cases(
      iprod(x - B lambda, b_1) & = 0,
      dots.v & dots.v,
      iprod(x - B lambda, b_m) & = 0
    ) ==>
    cases(
      b_1^T (x - B lambda) & = 0,
      dots.v & dots.v,
      b_m^T (x - B lambda) & = 0
    ) ==>
    B^T (x - B lambda) = 0
  $

  Now we can easily find the $lambda$ vector:

  $ B^T (x - B lambda) = 0 <==> lambda = (B^T B)^(-1) B^T x $

  notice also that $(B^T B)^(-1) B^T$ is the _pseudoinverse_ of $B$, also
  denoted with $B^+$.
+ *Find the projection point $pi_U (x)$*: since we know that

  $ lambda = (B^T B)^(-1) B^T x $

  the projection point is easily found:

  $ pi_U (x) = B lambda ==> pi_U (x) = B (B^T B)^(-1) B^T x $
+ *Find the projection matrix $P_pi$*: this step is also already done since we
  want a matrix such that

  $ P_pi x = pi_U (x) $

  and we know what is $pi_U (x)$, we can write

  $ P_pi x = B (B^T B)^(-1) B^T x $

  therefore

  $ P_pi = B (B^T B)^(-1) B^T $

= Gram-Schmidt Orthogonalization

// to do

