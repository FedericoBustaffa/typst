#import "@local/note_template:0.1.0": *
#show: doc => note_template([Inner Products], doc)

#title()

*Inner products* are operations with no fixed meaning or interpretation, for
example the most famous is the scalar or dot product:

$ iprod(x, y) = x^TT y = sum_(i=1)^N x_i y_i $

which results in a scalar which, we'll see later, is a measure of how similar
$x$ and $y$ are, mostly in terms of directions and angles.

#important(title: [ Definition ])[
  Lert $V$ be a vectore space and $Omega : V times V -> RR$ a _bilinear
  mapping_, then $Omega$ is

  - *Symmetric* if $Omega(x, y) = Omega(y, x)$ for all $x, y in V$.
  - *Positive definite*: if $Omega(x, x) > 0$ for $x != 0$.
]

#important(title: [ Definition ])[
  Lert $V$ be a vectore space and $Omega : V times V -> RR$ a _bilinear
  mapping_, then

  - A bilinear mapping $Omega : V times V -> RR$ that is symmetric and positive
    definite is an *inner product* on $V$ and is denoted with $iprod(x, y)$.
  - The pair $(V, iprod(dot, dot))$ is called *inner product
    space*.
]

If the considered inner product is the dot product then we talk about *Euclidean
space*.

= Matrix Representation

Let's now consider a $n$-dimensional space with inner product and ordered basis
$B = {b_1, dots, b_n}$ of $V$, then for inner product bilinearity it holds

$
  iprod(x, y) & = iprod(sum_(i=1)^n psi_i b_i, sum_(j=1)^n lambda_j b_j) \
              & = sum_(i=1)^n sum_(j=1)^n psi_i iprod(b_i, b_j) lambda_j =
                hat(x)^TT A hat(y)
$

where $hat(x)$ and $hat(y)$ that are the coordinates of $x$ and $y$ with respect
to the basis $B$ and with $A_(i j) = iprod(b_i, b_j)$.

This implies that the inner product is determined through the the matrix $A$ and
so there are nice property of the inner product that are transferred to $A$:

- The symmetry of the inner product implies that $A$ is symmetric.
- The inner product's positive definite property implies that also $A$ is
  positive definite.

#important(title: [ Definition ])[
  A matrix $A$ is *symmetric positive definite (SPD)* if and only if $forall x
  in V backslash { 0 }$ it holds $x^TT A x > 0$, and is denoted with $A succ 0$.
]

By using the same definition but with the matrix $A$ that satisfies the
inequality only with $x^TT A x >= 0$ we have a *symmetric positive semidefinite
(SPSD)*, denoted with $A succ.eq 0$.

= Inner Products for Functions

Inner products can also be defined for vectors with infinitely many entries and
functions are an example of that. Let's consider for example $f$ and $g$, both
defined from $RR$ to $RR$, their inner product becomes an integral:

$ iprod(f, g) = integral_b^a f(x) dot g(x) d x $

and similarly to vectors $iprod(f, g) = 0$ means that $f$ and $g$ are
orthogonal.
