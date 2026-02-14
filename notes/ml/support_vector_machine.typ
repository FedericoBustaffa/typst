#set page(paper: "a4")
#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)


#let note(title: "Note", body) = block(
  fill: rgb("#e6f2ff"),
  inset: 12pt,
  radius: 6pt,
  stroke: (left: 4pt + rgb("#3399ff")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]

#let important(title: "Important", body) = block(
  fill: rgb("#e9f7ef"),
  inset: 12pt,
  radius: 6pt,
  stroke: (left: 4pt + rgb("#28a745")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]

#let example(title: "Example", body) = block(
  fill: rgb("#f3e8ff"),
  inset: 12pt,
  radius: 6pt,
  stroke: (left: 4pt + rgb("#8b5cf6")),
  width: 100%,
)[
  #strong[#title]
  #v(4pt)
  #body
]

#title("Support Vector Machine")

The #strong[support vector machine] (#strong[SVM];) is a model whose development
is driven by the concept of #strong[structural risk minimization] from the
statistical learning theory.

It can be used for classification and regression and it can adapt well to both
linear and non linear task; in particular it tries to find separation
hyper-planes also for classification problems that are not linearly separable.

= Classification <classification>

In the classical #strong[binary classification problem] we want to find an
hyper-plane of equation

$ g (x) = w^tack.b x + b = 0 $

that separates the examples in this way

$
  w^tack.b x + b & gt.eq 0 & upright("for ") y = + 1 \
  w^tack.b x + b & < 0     & upright("for ") y = - 1
$

The equation of the hyper-plane $g (x)$ is just a #emph[discrimant] function,
while the actual hypothesis function is the sign of the discriminant.

What an SVM does is try to find a #strong[margin] $rho$ that tries to maximize
the distance between the linear hyper-plane and the closest data points.

#figure(
  image("images/svm_margin.png", width: 40%),
  caption: [ SVM Margin ],
)

Of course we can move the hyper-plane and the margin will change as well; anyway
the SVM aims to find the hyper-plane that maximizes the margin $rho$ in order to
have a larger confidence on unseen points.

In order to maximize the margin we want to rescale $w$ and $b$ so that the
closest points to the hyper-plane satisfy

$ lr(|g (x_p)|) = lr(|w^tack.b x_p + b|) = 1 $

and so we can write

$
  w^tack.b x_p + b & gt.eq 0 & upright("for ") y_p = + 1 \
  w^tack.b x_p + b & lt.eq 0 & upright("for ") y_p = - 1
$

that in a compact form becomes

$ y_p dot.op (w^tack.b x_p + b) gt.eq 1 $

#note(title: "Support Vector")[
  A #strong[support vector] $x^((s))$ satisfies the previous equation exactly:

  $ y^((s)) dot.op (w^tack.b x^((s)) + b) = 1 $
]


The support vectors are the closest points to the hyper-plane. So it seems
obvious that we need to compute the distance between a point and the
hyper-plane. To do that, the idea is to compute the distance between our point
$x$ and a point $hat(x)$ on the hyper-plane that minimizes the distance.

So we can rethink $x$ as a sort of translation of $hat(x)$ in the direction
defined by $w$ (that is orthogonal to the hyper-plane) by the distance $r$ we
are looking for:

$ x = hat(x) + r frac(w, parallel w parallel) $

Let’s also remember that $g (x) = w^tack.b x + b$ and so we can write

$
  g (x) & = w^tack.b (hat(x) + r frac(w, parallel w parallel)) + b & \
  & = w^tack.b
  hat(x) + w^tack.b r frac(w, parallel w parallel) + b & \
  & = r frac(
    parallel w
    parallel^2, parallel w parallel
  ) &= r parallel w parallel
$

thus, the distance can be computed as

$
  r = frac(g (x), parallel w parallel) = frac(
    w^tack.b x + b, parallel w
    parallel
  )
$

So, assuming an already optimal hyper-plane, the distance from the hyper-plane
and a support vector is $x^((s))$

$
  frac(w^tack.b x^((s)) + b, parallel w parallel) = frac(1, parallel w parallel)
  = rho / 2
$

Computing also the distance from the hyper-plane to a negative support vector,
that will be $- frac(1, parallel w parallel)$, the total margin will be

$
  rho = lr(|- frac(1, parallel w parallel) - frac(1, parallel w parallel)|) =
  frac(2, parallel w parallel)
$

The #strong[optimal] hyper-plane maximizes $rho$ by minimizing $parallel w
parallel$.

== Hard Margin <hard-margin>

The first and simplest form of SVM is the #strong[hard margin] that wants to
minimize the weights while having zero classification errors. Of course this is
possible if and only if the problem is linearly separable.

In its #strong[primal form] the problem is formulated as the minimization of

$ Psi (w) = 1 / 2 w^tack.b w = 1 / 2 parallel w parallel^2 $

satisfying the constraint that

$ y_p dot.op (w^tack.b x_p + b) gt.eq 1 $

for each pattern in the training set. But the objective function is quadratic
and convex in $w$ and the constraints are linear in $w$; solving this problem
scales with the size of the input space.

Typically, when working with SVMs, we are interested in solving the #strong[dual
  form];, that in this case is defined with the #strong[lagrangian equation];.

$
  J (w , b , alpha) = 1 / 2 parallel w parallel^2 - sum_(p = 1)^N alpha_p (y_p
    (w^tack.b x_p + b) - 1)
$

with $alpha_p gt.eq 0$ for every $p = 1 , dots.h , N$ that are the
#strong[lagrangian multipliers];.

This gives us an optimization problem were we have to optimize only one function
in which the constraints are included and handled by the multipliers, in fact
the constraints were defined for each point as

$ y_p dot.op (w^tack.b x + b) gt.eq 1 $

So to achieve the dual form we need to impose

$ y_p dot.op (w^tack.b x + b) - 1 gt.eq 0 $

And so now each term of the sum corresponds to a constraint of the primal
problem.

The aim is minimize $J$ with respect to $w$ and $b$:

$ frac(partial J, partial w) = 0 quad frac(partial J, partial b) = 0 $

from which we obtain that

$
  w = sum_(p = 1)^N alpha_p dot.op y_p dot.op x_p quad sum_(p = 1)^N alpha_p
  dot.op y_p = 0
$

So now we can substitute this two terms in $J$ and obtain

$
  J (alpha) = sum_p alpha_p - 1 / 2 sum_p sum_t alpha_p alpha_t dot.op y_p y_t
  dot.op x_p^tack.b x_t
$

that we can maximize with a quadratic programming solver in order to find the
optimal $alpha$ vector. Once we have it we can substitute the actual $alpha$
values in the formulation for optimal $w$ previously defined, to find the
#strong[optimal hyper-plane];:

$ sum_(p = 1)^N alpha_p y_p (x_p^tack.b x) + b = 0 $

and also find the optimal $b$ corresponding to a positive support vector
$x^((s))$:

$ b = 1 - sum_(p = 1)^N alpha_p y_p x_p^tack.b x^((s)) $

and from #strong[Kuhn-Tucker conditions] it follows that

- If $alpha_p > 0$, then the $y_p (w^tack.b x_p + b) = 1$ and $x_p$ is a support
  vector.
- If $x_p$ is not a support vector then $alpha_p = 0$.

Note now that there is no need to know the optimal $w$ explicitly, because it’s
defined in terms of lagrangian multipliers and so, given an input pattern $x$ we
can compute

$ g (x) = sum_(p = 1)^N alpha_p y_p x_p^tack.b x + b $

and classify $x$ as the sign of $g (x)$, but we can restrict the sum to the
support vectors $N_s$

$ g (x) = sum_(p = 1)^(N_s) alpha_p y_p x_p^tack.b x + b $

#important(title: "Vapnik Theorem")[
  Let $D$ be diameter of the
  smallest ball around the data points $x_1 , dots.h , x_n$. For the class of
  separating hyper-planes described by the equation $ w^tack.b x + b = 0 $ the
  upper bound to the VC-dimension is

  $ V C lt.eq min (⌈D^2 / rho^2⌉ , m) + 1 $

  where $m$ is the dimension of the input vector.
]

== Soft Margin <soft-margin>

The #emph[hard margin] conditions can be to restrictive and for some cases the
margin can be very small or, in case the problem is not linearly separable, the
solver will not provide a solution.

The #strong[soft margin] SVM relaxes the constraints and let at least one point
to be inside the margin (with or without classification error).

#figure(
  image("images/soft_margin.png", width: 40%),
  caption: [ SVM Soft Margin ],
)

So now we want to allow some points into the margin in order to have a larger
margin. This is done by the introduction of #strong[slack variables]

$ xi_p gt.eq 0 quad forall p = 1 , dots.h , N $

So now also the definition of support vectors changes.

#note(title: "Support Vector (Soft Margin)")[
  A support vector in the soft margin SVM is a
  point $x_p$ that satisfies exactly the constraint

  $ y_p (w^tack.b x_p + b) = 1 - xi_p $
]

So now the Vapnik theorem does not hold anymore because is defined only for hard
margin SVMs.

Now the #strong[primal form] of the problem is to find $w$ and $b$ that minimize

$ Psi (w , xi) = 1 / 2 w^tack.b w + C sum_(p = 1)^N xi_p $

under the constraints:

$ y_p (w^tack.b x_p) gt.eq 1 - xi_p quad quad xi_p gt.eq 0 $

where $C$ is a #strong[regularization hyper-parameter] to be set in order to
find a trade off between empirical risk minimization and capacity term
minimization. Let’s also note that

- Low $C$ allow many training errors, possibly leading to underfitting.
- High value of $C$ lead to a hard margin behavior.

Note also that $C = 0$ brings us back to hard margin formulation.

So now we can formulate the problem in its #strong[dual form] as before but now
we have two kinds of constraints: the one on the classification and the one on
the non negativity of slack variables

$
  J (w , b , xi , alpha , mu) = 1 / 2 parallel w parallel^2 + C sum_(p = 1)^N
  xi_p - sum_(p = 1)^N alpha_p (y_p (w^tack.b x_p + b) - 1) - sum_(p = 1)^N mu_p
  xi_p
$

with $mu_p$ that are the lagrangian multipliers introduced to enforce the non
negativity of slack variables.

Now the #strong[Kuhn-Tucker conditions] say to us that

- if $0 < alpha_p < C$ and so $xi_p = 0$ the point is a support vector.
- if $alpha_p = C$ and so $xi_p gt.eq 0$ the point is inside the margin.

The dual problem is solved as before but now we also want to optimize $xi$.

== Kernel Trick <kernel-trick>

In general we can address non linearly separable problems with a #emph[soft
  margin] approach, but there are problems where even with that the SVM will not
perform good enough.

Usually, mapping the data points to an higher dimensional feature space, can
make them linearly separable in the new space.

#figure(
  image("images/svm_kernel.png", width: 50%),
  caption: [ Higher Dimension Mapping ],
)

So now we can find a function $phi.alt$ the maps features in an higher dimension
space. But know we have the problem is choosing the best $phi.alt$, unless a
prior knowledge on the feature space properties, in particular:

- How to choose the #strong[class of $phi.alt$];: polynomial, gaussian,
  logarithmic etc.
- How to choose the #strong[number of dimension to add];.

For example if we have

$ x = mat(delim: "[", x_1; x_2) $

we can add a third feature by applying a $phi.alt$ function and obtain

$ phi.alt (x) = mat(delim: "[", x_1; x_2; x_1 dot.op x_2) $

So now the formula in due dual problem for the optimal hyper-plane becomes

$ sum_(p = 1)^N alpha_p y_p phi.alt^tack.b (x_i) phi.alt (x) = 0 $

The problem here is that for arbitrarly complex $phi.alt$ and for high dimension
input space, the computation of $phi.alt$ and the inner products can become
unfeasible.

Fortunately, under certain conditions we do not need to evaluate directly
$phi.alt (x)$ and we don’t even need to know the feature space itself. This is
possible by computing a function directly in the feature space

$ k : bb(R)^m times bb(R)^m arrow.r bb(R) $

called #strong[inner product kernel] function

$ k (x_i , x) = phi.alt^tack.b (x_i) dot.op phi.alt (x) $

that is symmetric: $k (x_i , x) = k (x , x_i)$. The dot product in feature space
is evaluated without considering the feature mapping and the feature space
itself.

#example[
  Given a certain $phi.alt$ such that
  $
    phi.alt (x) = phi.alt ((x_1 , x_2)^tack.b) = (x_1^2 , sqrt(2) x_1 x_2 ,
      x_2^2)^tack.b
  $
  Given $x = (x_1 , x_2)^tack.b$ and $y = (y_1 , y_2)^tack.b$ in $bb(R)^2$, we
  compute $ phi.alt^tack.b (x) phi.alt (y) $ in this way:

  $
    (x_1^2 , sqrt(2) x_1 x_2 , x_2^2) (y_1^2 , sqrt(2) y_1 y_2 , y_2^2)^tack.b &
    = x_1^2 y_1^2 + 2 x_1 x_2 y_1 y_2 + x_2^2 y_2^2\ & = (x_1 y_1 + x_2 y_2)^2\ &
    = ((x_1 , x_2) (y_1 , y_2)^tack.b)^2\ & = (x^tack.b y)^2 = k (x , y)
  $

  That is out kernel function.
]

It is possible to arrange the dot products in the feature space between the
images of the input training patterns in a $N times N$ matrix, called
#strong[kernel matrix];:

$
  K = mat(
    delim: "[", k (x_1 , x_1), dots.h.c, k (x_1 , x_N); dots.v, dots.down, dots.v; k (x_N , x_1), dots.h.c, k (x_N , x_N); #none
  )
$

Which is symmetrical as the inner product kernel is symmetrical. However not
every function compute the kernel in the input space: this property only holds
for kernels gaining #emph[positive semidefinite] kernel matrices.

So now the #strong[primal form] of the problem is defined as before

$ Psi (w , xi) = 1 / 2 w^tack.b w + C sum_(p = 1)^N xi_p $

but with the constraints defined as

$ y_p (w^tack.b phi.alt (x_p)) gt.eq 1 - xi_p quad quad xi_p gt.eq 0 $

and so the #strong[dual form] can be expressed as

$
  J (alpha) = sum_p alpha_p - 1 / 2 sum_p sum_t alpha_p alpha_t dot.op y_p y_t
  dot.op k (x_p , x_t)
$

satisfying the constraints

$ sum_(p = 1)^N alpha_p y_p = 0 $

with $0 lt.eq alpha_p lt.eq C$ for all $p$.

There are some popular valid kernels that are often used without the need to
build a kernel from scratch:

- #strong[Polynomial];: given a degree of freedom $d$ is defined as
  $ k (x , x_p) = (x^tack.b x_p + 1)^d $
- #strong[Radial Basis Function];: also called #strong[gaussian kernel] that,
  given $sigma$ is defined as
  $ k (x , x_p) = e^(- frac(1, 2 sigma^2) parallel x - x_i parallel^2) $
  and leads to a infinite dimensional space.
- #strong[Sigmoidal];: that given $beta_0 > 0$ and $beta_1 < 0$ is defined as
  $ k (x , x_p) = tanh (beta_0 w^tack.b x_i + beta_1) $

For the first two and for every choice of their hyper-parameters, a valid kernel
is produced, while for the third only some values of $beta_0$ and $beta_1$
produce a valid kernel.

= Regression <regression>

SVMs can be used also for #strong[regression] tasks but the now they work in the
opposite way of classification.

For a #emph[hard margin] version, the classification SVM does not allow any
point inside the margin; for regression instead the SVM wants to put every point
inside the margin, minimizing its size.

For a soft margin version instead, some points are allowed to stay outside of
the tube, leading to an higher resistence to outliers than other models like
neural networks.

More formally, the model again tries to estimate targets using a linear
expansion of (possibly) non linear functions

$ y approx h (x) = w^tack.b phi.alt (x) $

In order to perform regression a loss function is needed and in case of SVMs we
have $epsilon.alt$-insensitive loss:

$
  L_epsilon.alt (y , h (x)) = cases(
    delim: "{", lr(|y - h (x)|) - epsilon.alt &
    upright("if ") lr(|y - h (x)|) < epsilon.alt, 0 & upright("otherwise")
  )
$

where $epsilon.alt$ defines the tube’s #emph[width];.

#figure(
  image("images/svm_regression.jpg", width: 50%),
  caption: [ SVR ],
)

The problem formulation is very similar to the classification one: as before
also here there are #strong[slack variables] $xi_i$ and $xi_i'$ that hold the
following property:

$
  - xi_i' - epsilon.alt lt.eq y_i - w^tack.b phi.alt (x_i) lt.eq epsilon.alt +
  xi_i
$

for all $i$ from $1$ to $N$. This leads to the following constraints

$
  y_i - w^tack.b phi.alt (x_i) & lt.eq epsilon.alt + xi_i \
  w^tack.b phi.alt (x_i) - y_i & lt.eq epsilon.alt + xi_i' \
                          xi_i & gt.eq 0 \
                         xi_i' & gt.eq 0 \
$

The formulation for the #strong[primal problem] is similar to the classification
task formulation. Given the training set, find the optimal values of $w$ such
that the following objective function is minimized

$ psi (w , xi , xi ') = 1 / 2 w^tack.b w + C sum_(i = 1)^N (xi + xi ') $

under the constraints defined before. The formulation for the dual problem again
needs the lagrangian multipliers. Given the training set, find the optimal
values of ${ alpha_i }_(i = 1)^N$ and ${ alpha_i' }_(i = 1)^N$ which maximize
the objective function

$
  Q (alpha , alpha ') = sum_(i = 1)^N y_i (alpha_i - alpha_i ') - epsilon.alt
  sum_(i = 1)^N (alpha_i + alpha_i ') - 1 / 2 sum_((i , j) = 1)^N (alpha_i -
    alpha_i ') (alpha_j - alpha_j ') k (x_i , x_j)
$

under the constraints

$
  sum_(i = 1)^N (alpha_i - alpha_i ') = 0 \
  0 lt.eq alpha_i lt.eq C 0 lt.eq alpha_i' lt.eq C
$

for all $i$ from $1$ to $N$. Solving the dual problem we obtain the optimal
values of lagrangian multipliers, then we compute the optimal value of vector
$w$ like follows

$
  w = sum_(i = 1)^N (alpha_i - alpha_i ') phi.alt (x_i) = sum_(i = 1)^N gamma_i
  phi.alt (x_i)
$

and in this case support vectors correspond to non zero values of $gamma_i$. The
estimated function using the linear expansion is defined as

$
  h (x) = sum_(i = 1)^N gamma_i phi.alt^tack.b (x_i) phi.alt (x) = sum_(i = 1)^N
  gamma_i k (x_i , x)
$

Like for classification, only support vectors matter and so as long as they are
in the tube, points that are not support vectors can be disposed in every
possible configuration.

= References <references>

- Supervised Learning
- Statistical Learning Theory
- Eigen Values and Eigen Vectors
