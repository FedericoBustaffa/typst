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
    f_1, f_2; x_1, x_2
  )
$

