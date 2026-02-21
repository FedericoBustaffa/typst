#import "@local/note_template:0.1.0": *
#show: doc => note_template([Continuous Systems], doc)

#title()

Some system can naturally be described with discrete time steps, but in many
cases the precision of those models is too low. In order to provide more
accurate simulations it’s necessary a continuous representation of time.

In other words, the time step $Delta t$ must tend to zero and a representation
through *ordinary differential equations (ODEs)* must be introduced. There are
two fundamental ways to obtain a differential equation from a recurrence
relation.

The first method can be used when in the recurrence relation there is $Delta t$
term and the goal is to obtain an equation in this form

$ frac(N (t + Delta t) - N (t), Delta t) = f (N (t)) $

compute the limit for $Delta t arrow.r 0$ that gives us the *difference
quotient*

$
  lim_(Delta t arrow.r 0) frac(N (t + Delta t) - N (t), Delta t) =
  lim_(Delta t arrow.r 0) f (N (t))
$

that can be rewritten as

$ dot(N) (t) = f (N (t)) $

that is a differential equation. Computing the solution of this ODE gives us an
equation that can be used to compute the value of a generic state variable $N$
at a given time $t$.

#note[
  The solution of the ODE is different from the solution of the recurrence
  relation because we moved parts of the recurrence to the left end side, so the
  behavior of the state variable can differ.
]

The other case is when we don’t have $Delta t$ in the recurrence and we _"copy"_
the form of the recurrence as a differential equation. The $N_(t + 1)$ part
becomes the derivative $dot(N) (t)$ and the right end side remains the same but
with $N_t$ that becomes $N (t)$.

The main difference between the two is that a recurrence relation uses the
current state to compute the next one, meanwhile the differential equation at
time $t$ let us compute the #emph[change];. In other words the value of the
derivative at time $t$ tells us how the state variable behaves in that moment:
how much it grows, decreases or remain constant.

= Analytical Solutions <analytical-solutions>

Similarly to recurrence relations, we can find a #strong[solution] for a
differential equation. That can be done by find a #emph[closed-form definition]
that depends only on $t$ and some constants, of $N (t)$ satisfying the equation.

Of course is possibile to find ODEs solutions #strong[analytically];, but there
is not a general method to solve them; in other words we have to reason case by
case and so we cannot automate the process with an algorithm.

= Recurrence Relations vs Differential Equations
<recurrence-relations-vs-differential-equations>

An important observation to make is that the recurrence equations describe how
to compute the #strong[next state];, instead the differential equations describe
how to compute the difference between the current and the next.

Also the #strong[equilibrium] is computed differently; for recurrence equations
we want to know when the next state is equal to the current. In other words we
want to find when the system does not change anymore. In differential equations
we can set the derivative to $0$ so that we reach a local minimum (or maximum)
of the function.

= Numerical Solutions <numerical-solutions>

A simpler and faster way to compute solutions for ODEs is by using *numerical
methods* that try to solve the so called _initial value problem_. The initial
value problem is solved by computing a function $F (t)$ that is a solution of
the ODE

$ dot(N) (t) = f (N (t)) $

and such that $F (0) = N_0$. Usually we are interested in values of $F (t)$ for
$t gt.eq 0$ since we want to perform a simulation starting from $t = 0$.

== Euler Method <euler-method>

The #strong[Euler’s method] is the simplest numerical method to numerically
solve an ODE, by approximating the actual function with the derivative.

Let $dot(N) (t) = f (N (t))$ be the ODE we want to solve and suppose that we
know $N (t_0 = 0)$ ($t_0$ can also be different from $0$) the starting point,
and let $tau$ be the step size.

The method starts by computing $dot(N) (t_0)$ and obtain the tangent’s angular
coefficient of the function $N$ in $t_0$. Now we can compute an approximation of
$N (t_0 + tau)$ using the tangent instead of the actual function $N$ (that we
don’t know). The idea is that, for a small step $tau$, the tangent is a good
approximation of the function.

#figure(
  image("images/euler.png", width: 75%),
  caption: [ Euler Method ],
)

So if we know the angular coefficient, the starting point, and the step
we can use the following formula

$
  y - y_0 & = m (x - x_0) \
        y & = y_0 + m (x - x_0) \
        y & = y_0 + m (x_0 + tau - x_0) \
        y & = y_0 + tau m
$

if we now consider that $m$ is the value of the derivative in
$x_0 = t_0$ we can say that

$ m = dot(N) (t_0) = f (N (t_0)) $

And so we can easily obtain the following recurrence relation

$ N_(k + 1) = N_k + tau f (N_k) $

that describes how to compute the next step and where $N_k$ approximate
$N (k tau)$.

=== Approximation Errors <approximation-errors>

The two types of error we care about when run numerical simulations are:

- #strong[Local discretization error];: error raised at every step of
  the algorithm, that has the value of $ lr(|N (tau) - N_1|) $ and is in
  the order of $O (tau^2)$.
- #strong[Global discretization error];: the error accumulates and after
  $k$ steps we have an error of $ lr(|N (k tau) - N_k|) $ and it is in
  the order of $O (tau)$.

A linear global discretization error means that a very small $tau$ has
to be used in order to minimize the error; this also can imply a much
slower simulation because smaller $tau$ means more iterations.

=== Implicit Methods <implicit-methods>

In some cases the method can become unstable unless a very small $tau$
is used. This systems are called #strong[stiff systems] and often
#strong[implicit methods] are better for those cases.

An implicit method simply compute the derivative at the end of the time
interval of length $tau$, so now the formula is slightly different:

$ N_(k + 1) = N_k + tau f (N_(k + 1)) $

where $N_k$ approximates $N (k tau)$.

With stiff systems this kind of methods are often more efficient and
greater values of $tau$ can be used. However we have to pay a more heavy
computation step but it is often more convenient than use the explicit
version of the method.

#figure(
  image("images/euler2.png", width: 75%),
  caption: [ Implicit Euler Method ],
)

The fact that $N_(k + 1)$ appears on both sides means that we need to solve an
equation like

$ g (N_(k + 1)) := N_(k + 1) - tau f (N_(k + 1)) - N_k = 0 $

that in general is not linear and can be solved numerically.

#example(title: "Example")[
  Let’s take, for example the classic consumer resource model

  $ dot(N) (t) = r_c N (t) (1 - frac(N (t), K)) $

  if we compute the implicit step of the Euler method we have

  $ N_(k + 1) = N_k + tau r_c N_(k + 1) (1 - N_(k + 1) / K) $

  that can be rewritten as

  $ frac(tau r_c, K) N_(k + 1)^2 + (tau r_c - 1) N_(k + 1) - N_k = 0 $

  since the only unknown value is $N_(k + 1)$ is clear that this is a quadratic
  equation that can be solved numerically.
]

for some simple model like the linear birth model an analytical way is still
possible but in general this is not true.

= Limitations <limitations>

Possible limitations for continuous dynamical models based on ODEs are that they
describe the behavior of the system, starting from an initial state in a
#strong[deterministic] way.

Often can happen that the same system exhibit different behaviors starting from
the same initial state. This happens when some events in the system are somehow
*random*. This introduce the need for *probabilistic or stochastic models*.
