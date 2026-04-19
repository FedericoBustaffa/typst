#import "@local/note_template:0.1.0": *
#show: doc => note_template([Univariate Differentiation], doc)

#title()

The *univariate differentiation* is the basic of more complex concepts about
derivatives that are the core of optimization problems.

The core idea is that we want a way to express the _rate of change_ of a
function between two arbitrary points. This is done by the *difference
quotient*:

$ dv(y, x, d: delta) = frac(f(x + delta x) + f(x), delta x) $

where $delta x$ represents an arbitrary small change. Technically the difference
quotient computes the slope of the *secant* line through 2 points on the graph
of $f$.

#figure(
  lq.diagram(
    {
      let x = lq.linspace(-1, 1)
      lq.plot(x, x => calc.pow(x, 2), mark: none)
    },
    {
      let x = (0, 0.5)
      lq.plot(x, x => calc.pow(x, 2))
    },
  ),
)

We can also say that the difference quotient computes the average slope of $f$
between $x$ and $x + delta x$.

If we compute the limit of difference quotient for $delta x -> 0$ to compute the
average slope between two points at infinitesimally small distance, we obtain
the *derivative* of $f$:

$ dv(f, x, d: delta) = lim_(delta x -> 0) frac(f(x + delta x) - f(x), delta x) $

for $delta x > 0$. With this new definition the distance between $x$ and $x +
delta x$ is infinitesimally small and so the derivative at $x$ computes the
slope of the *tangent* (before secant) in that point.

#figure(
  lq.diagram(
    legend: (position: bottom + right),
    {
      let x = lq.linspace(-1, 3)
      lq.plot(x, x => calc.pow(x, 2), mark: none, label: [$x^2$])
    },
    {
      let x = lq.linspace(-1, 3)
      lq.plot(x, x => 2 * x - 1, mark: none, label: [tangent])
    },
  ),
)

This gives the hint that a function can be locally approximated by the tangent
defined by its derivative in a certain point.

// #example[
//   Let's consider $f(x) = x^2$ whose derivative we know to be $f'(x) = 2x$. If we
//   try to compute the limit we obtain
//
//   $
//     lim_(delta x -> 0) frac((x + delta x)^2 - x^2, delta x)
//     & = lim_(delta x -> 0) frac(x^2 + delta x^2 + 2 x delta x - x^2, delta x) \
//     & = lim_(delta x -> 0) frac(delta x^2 + 2 x delta x, delta x) \
//     & = lim_(delta x -> 0) delta x + 2 x = 2 x
//   $
//
//   that is in fact the derivative of $x^2$.
// ]

The derivative gives us useful insights of the function's behavior that are
fundamental to see where there are the so called *stationary points*, where the
function increases, decreases or remains constant.

#figure(
  lq.diagram(
    legend: (position: bottom + right),
    {
      let x = lq.linspace(-1, 3)
      lq.plot(x, x => calc.pow(x, 2), mark: none, label: [$x^2$])
    },
    {
      let x = lq.linspace(-1, 3)
      lq.plot(x, x => 2 * x, mark: none, label: [$2x$])
    },
  ),
)

In general we don't know where a function has for example a minimum but we can
exploit the fact that where the derivative is negative, the function decreases,
while where the derivative is positive the function increases. This entails that
where the derivative is zero, there is a maximum or a minimum of the function
that can be found by solving $f'(x) = 0$.

= Taylor Series

The *Taylor series* brings farther the concept briefly introduced before, of
approximating a function in a point.

The idea is that we can approximate arbitrarily well a function with a finite
sum of $k$ terms that are the first $k$-th order derivatives in a point $x_0$.

#important(title: [Taylor Polynomial])[
  The *Taylor polynomial* of degree $n$ of $f : RR -> RR$ at $x_0$ is defined as

  $ T_n (x) = sum_(k=0)^n frac(f^((k)) (x_0), k !) (x - x_0)^k $

  where $f^((k)) (x_0)$ is the $k$-th order derivative of $f$ at $x_0$ and
  $frac(f^((k)) (x_0), k !)$ are the coefficients of the polynomial.
]

If the function is a polynomial soon or later we will match the degree $n$ of
the original $f$ obtaining a perfect approximation.

Let's take $f(x) = x^3$ evaluated in $x = 1$, its taylor polynomial up to degree
$2$ is

$
  T_2 (x) =
  underbrace(underbrace(1, T_0) + 3 (x - 1), T_1) + 6 / 2 (x
    - 1)^2
  ) = 3x^2 - 3x + 1
$

and if we evaluate the Taylor up to the third degree we obtain exactly $x^3$.

#figure(
  lq.diagram(
    width: 70%,
    height: 6cm,
    legend: (position: top + left),
    {
      let x = lq.linspace(-1, 3)
      lq.plot(x, x => calc.pow(x, 3), mark: none, label: [$x^3$])
    },
    {
      let x = lq.linspace(-1, 3)
      lq.plot(
        x,
        x => 1,
        mark: none,
        label: [$T_0$],
      )
    },
    {
      let x = lq.linspace(-1, 3)
      lq.plot(
        x,
        x => 3 * x - 2,
        mark: none,
        label: [$T_1$],
      )
    },
    {
      let x = lq.linspace(-1, 3)
      lq.plot(
        x,
        x => 3 * calc.pow(x, 2) - 3 * x + 1,
        mark: none,
        label: [$T_2$],
      )
    },
  ),
)

In general the Taylor polynomial is an approximation of a function that does not
have to be a polynomial.

#important(title: [ Taylor Series ])[
  For a smooth function $f in cal(C)^oo$, $f : RR -> RR$ *Taylor series* of $f$
  at $x_0$ is defined as

  $ T_oo (x) = sum_(k=0)^oo frac(f^((k)) (x_0), k !) (x - x_0)^k $
]

For $x_0 = 0$ we obtain the *Maclaurin series* as a special case of the Taylor
series and if $f(x) = T_oo (x)$ then $f$ is called *analytic*.

= Differentiation Rules

There are basic differentiation rules that can be applied to obtain much more
complex identities:

$
       "Sum Rule" && (f(x) + g(x))' & = f'(x) + g'(x) \
   "Product Rule" &&   (f(x) g(x))' & = f'(x) g(x) + f(x) g'(x) \
  "Quotient Rule" && (f(x) / g(x))' & = (f'(x) g(x) - f(x) g'(x)) / (g(x)^2) \
     "Chain Rule" &&     (g(f(x)))' & = g'(f(x)) f'(x)
$

These rules can be composed and generalized to multivariate differentiation with
some catch.
