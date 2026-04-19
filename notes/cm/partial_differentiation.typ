#import "@local/note_template:0.1.0": *
#show: doc => note_template([Partial Differentiation and Gradients], doc)

#title()

A more generale case of the univariate differentiation is for multivariate
functions that depend on many variables but still return a scalar:

$ f : RR^n -> RR $

This brings to the generalization of the derivative for multivariate functions:
the *gradient*, that is a vector containing *partial derivatives* with respect
to one variable at a time.

#important(title: [ Partial Derivatives and Gradient ])[
  For a function $f : RR^n -> RR$ of $n$ variables we define the *partial
  derivatives* as

  $
    pdv(f, x_1) & = lim_(h -> 0) frac(f(x_1 + h, x_2, dots, x_n) - f(x), h) \
         dots.v \
    pdv(f, x_n) & = lim_(h -> 0) frac(f(x_1, dots, x_(n-1), x_n + h) - f(x), h)
  $

  that collected in a vector (usually a row vector) become the *gradient*:

  $ grad_x f = mat(pdv(f(vb(x)), x_1), dots.c, pdv(f(vb(x)), x_n)) $
]

The reasons of why the gradient is a row vector are mainly two:

- Consistent generalization for vector-valued functions, for which the gradient
  becomes the _Jacobian_ matrix.
- It is possible to apply the multivariate chain rule without thinking about
  gradient dimensions.

The basic rules for differentiation of multivariate functions are very similar
to the univariate cases with special attention to the fact that they involve
vector/matrix multiplications that are not commutative.

$
      "Sum Rule" &&      pdv(f(x) + g(x), x) & = pdv(f, x) + pdv(g, x) \
  "Product Rule" &&        pdv(f(x) g(x), x) & = pdv(f, x) g(x) + f(x) pdv(g, x) \
    "Chain Rule" && pdv((g compose f)(x), x) & = pdv(g, f) pdv(f, x)
$

If we now take a closer look at the chain rule we clearly have a matrix
multiplication and so neighboring dimensions have to match. In the particular
case we're talking about there is not much to worry about because if we see a
function composition like this

$ (g compose f) (vb(x)) = g(f(vb(x))) $

it means that $f$ is a multivariate function $f : RR^n -> RR$ therefore, $g$ is
a standard univariate function $g : RR -> RR$. This means that the chain rule is
particularly simple:

$
  pdv(f, x) = grad_x f =
  mat(pdv(f(vb(x)), x_1), dots.c, pdv(f(vb(x)), x_n))
$

while $pdv(g, f)$ is standard univariate derivative so that overall we have just
a scalar by vector product that is always possible.

= Gradient of Vector-Valued Functions

Even more general is the case of *vector-valued functions* that are defined for
arbitrary vector spaces $vb(f) : RR^n -> RR^m$ with $n >= 1$ and $m > 1$. For a
function $vb(f) : RR^n -> RR^m$ and a vector $vb(x) = [f_1, dots, f_m]^T$, the
corresponding vector of function values is given as

$ vb(f) (vb(x)) = vec(f_1 (vb(x)), dots.v, f_m (vb(x))) $

with $f_i$ being different multivariate functions $f_i : RR^n -> RR$ that return
a scalar.

So computing the gradient of a vector valued function corresponds to compute the
partial derivatives of each $f_i$ with respect to each of the $x_i$ variables,
producing rows of the so called *Jacobian* matrix that can be seen as a
collection of gradients.

#important(title: [Jacobian])[
  The collection of all _first-order_ paritial derivatives of a vector-valued
  function $vb(f) : RR^n -> RR^m$ is called the *Jacobian*, that is a $m times
  n$ matrix defined as
  $
    vb(J) = grad_x f = dv(vb(f)(vb(x)), vb(x)) = mat(
      pdv(vb(f) (vb(x)), x_1), dots.c, pdv(
        vb(f)
        (vb(x)), x_n
      )
    ) = mat(
      pdv(f_1, x_1), dots.c, pdv(f_1, x_n);
      dots.v, #none, dots.v;
      pdv(f_m, x_1), dots.c, pdv(f_m, x_n);
    ) in RR^(m times n)
  $
]

That as we will see can be seen as a collection of functions or, if evaluated in
a specific point, as a pure numerical transformation matrix that can be studied
and decomposed just like any other matrix.

But let's consider for now the most simple situation in which we have $vb(f) :
RR^2 -> RR^2$ that

$ vb(f) (vb(x)) = vec(f_1 (x_1, x_2), f_2 (x_1, x_2)) $

hence the Jacobian is defined as

$
  vb(J) = jmat(
    delim: "[",
    f_1, f_2; vb(x),
  ) = jmat(
    delim: "[",
    f_1, f_2; x_1, x_2
  )
$

that if $f_1$ and $f_2$ are linear, for example

$
  f_1(x_1, x_2) & = -2 x_1 + x_2 \
  f_2(x_1, x_2) & = x_1 + x_2
$

is defined as

$ vb(J) = mat(-2, 1; 1, 1) $

If instead the functions $f_i$ are not linear we do not obtain a matrix with
only coefficients, but a collection of functions which can be used to locally
approximate the original one (Taylor series).

= Gradients of Matrices

There are also cases in which we need to take gradients of matrices w.r.t.
scalars, vectors or other matrices. Let's think about probabilisti models in
which there is the need to optimize a covariance matrix.

== Gradients of Matrices w.r.t. a Scalar

Let's consider for example the simple case in which we have a function $f : R^(m
times n) -> RR$ that takes a matrix in input and returns a scalar in output;
this is not much different from a function that takes in a vector and returns a
scalar, in fact it can be treated as such.

$ f : RR^(m times n) -> RR = f : RR^(m n) -> RR $

and so its gradient will be a row vector with $m times n$ entries.

== Gradients of Matrices w.r.t. a Vector

$ f = A x $

with $f in RR^M$, $A in RR^(M times N)$ and $x in RR^N$. If we need to take the
gradient $dv(f, A) in RR^(M times (M times N))$ and as usual is defined as

$ dv(f, A) = vec(pdv(f_1, A), dots.v, pdv(f_M, A)) $

with $pdv(f_i, A) in RR^(1 times (M times N))$. Now to compute the partial
derivatives it's usually helpful to write down the matrix vector multiplication:

$ f_i = sum_(j=1)^N A_(i j) x_j $

and the partial derivatives are then given as

$ pdv(f_i, A_(i q)) = x_q $

which results in a more general partial derivative of $f_i$ w.r.t. a row of $A$,
which is given as

$
       pdv(f_i, A_(i, :)) & = x^T in RR^(1 times 1 times N) \
  pdv(f_i, A_(k != i, :)) & = 0^T in RR^(1 times 1 times N)
$

and by consider all the dimensions involved we can deduce that the general
gradient of $f_i$ w.r.t. $A$ is given by

$ pdv(f_i, A) = vec(0^T, dots.v, 0^T, x^T, 0^T, dots.v, 0^T) $

where $x^T$ appears in the $i$-th row.

== Gradients of Matrices w.r.t. a Matrix

There is also the case in which we need to take the gradient of a matrix w.r.t.
another matrix, that needs particular care to handle dimensionality of the
introduced objects.

For example if we compute the gradient of $A in RR^(m times n)$ w.r.t. $B in
RR^(p times q)$ the resulting Jacobian would be $(m times n) times (p times q)$
that is a four-dimensional tensor.

Since matrices represent linear mappings, we can exploit the fact that there is
a vector space linear invertible mapping between $RR^(m times n)$ and $RR^(m
n)$. Therefore, we can reshape our matrices into vectors of lengths $m n$ and $p
q$ respectively so that the chain rule can be performed as a simple matrix
multiplication.

Let's consider a matrix $X in RR^(M times N)$ and a function $f : RR^(M
times N) -> RR^(N times N)$ with

$ f(X) = X^T X $

and of course we seek the gradient

$ dv(f, X) in RR^((N times N) times (M times N)) $

Moreover

$ dv(f_(p q), X) in RR^(1 times M times N) $

where $K_(p q)$ is the $(p, q)$ entry of $f(X)$. If we now denote the $i$-th
column of $X$ with $x_i$, every entry of $f(X)$ is given by the dot product of
two columns of $X$:

$ X_(p q) = x_p^T x_q = sum_(m=1)^M X_(m p) X_(m q) $

so that when we can compute the partial derivative

$
  pdv(f_(p q), X_(i j)) = sum_(m=1)^M pdv(X_(m p) X_(m q), X_(i j))
  = partial_(p q i j) =
  cases(
    X_(i q) & " if " j = p and p != q,
    X_(i p) & " if " j = q and p != q,
    2 X_(i q) & " if " j = p and p = q,
    0 & " otherwise"
  )
$

Let's for example take the following matrix

$ X = mat(x_(1 1), x_(1 2); x_(2 1), x_(2 2)) $

the derivative of $f(X) = X^T X$ in this case is done w.r.t. each component

