#import "@local/note_template:0.1.0": *
#show: doc => note_template([Least Squares], doc)

#title()

Some linear system cannot be solved exactly, for example a system $A x = y$ can
have zero or infinite solutions if $A$ is not invertible.

Another case is when the system is *overdetermined*, so that we need to satisfy
more equations than the number of unknow values.

In both cases is possible to find *the best* possible solution, that from a
geometrical point of view can be seen as the *closest* to the desired one.

A way to find the best possible $x$ is by solving the *least squares* problem,
that aims to minimize the quadratic distance between our solution and the
desired one.

$ min_x || A x - y ||^2 $

The quadratic distance (or error) is a common choice to get a *differentiable*
function, that can be minimized with methods based on *gradient*. But for now
what we are interested in is what we can do starting from that formula:

$
  || A x - y ||^2 & = (A x - y)^tack.b (A x - y)\
  & = ((A x)^tack.b - y^tack.b) (A x - y)\
  & = (x^tack.b A^tack.b - y^tack.b) (A x - y)\
  & = x^tack.b A^tack.b A x - x^tack.b A^tack.b y - y^tack.b A x + y^tack.b y\
  & = x^tack.b A^tack.b A x - x^tack.b A^tack.b y - (A x)^tack.b y + y^tack.b y\
  & = x^tack.b A^tack.b A x - x^tack.b A^tack.b y - x^tack.b A^tack.b y + y^tack.b y\
  & = x^tack.b A^tack.b A x - 2 x^tack.b A^tack.b y + y^tack.b y
$

So minimize $|| A x - y ||^2$ is equivalent to minimize that equation. Let’s
make one more step that will make sense in a while and let’s divide everything
by $2$, so that the problem becomes

$
  min_x 1 / 2 || A x - y ||^2 = min_x (1 / 2 x^tack.b A^tack.b A x -
    x^tack.b A^tack.b y + 1 / 2 y^tack.b y)
$

Let now $Q = A^tack.b A$ and $q = - A^tack.b y$, the problem can be rewritten as

$
  min_x 1 / 2 || A x - y ||^2 = min_x (1 / 2 x^tack.b Q x +
    x^tack.b q + 1 / 2 y^tack.b y)
$

This problem *has a unique solution* when $Q$ is SPD or has full column rank
and, in order to find its solution, it's necessary to compute the *gradient*

$ Q x + q = A^tack.b A x - A^tack.b y $

that we need to set to zero in order to minimize the objective function

$ A^tack.b A x - A^tack.b y = 0 $

So now we have a strategy to solve the *least squares* problem made of three key
points:

+ Compute $A^tack.b A$: we can just compute half of the matrix.
+ Compute $A^tack.b y$: Cholesky factorization.
+ Solve the so called *normal equations* $(A^tack.b A) x = A^tack.b y$

In the first two points everything is known so, aside from computational
optimization, we don't need anything. Instead to solve the _normal equations_ we
need the *pseudoinverse* of $A$, that is defined as $(A^tack.b A)^(- 1)
A^tack.b$, and that let us generalize the concept of inverse for rectangular
(overdetermined) linear systems.

In this way is possible to solve the system by computing

$ x = (A^tack.b A)^(- 1) A^tack.b y $

or, a more compact form

$ x = A^(+) y $

where $A^(+) = (A^tack.b A)^(- 1) A^tack.b$ is the pseudoinverse of $A$.

= Uniqueness of Solution

#important(title: "Theorem")[
  A matrix $A in RR^(m times n)$ has full column rank if and only if is SPD.
]

In particular if $ker(A) != { 0 }$ it means that there is a vector $z != 0$ such
that $A z = 0$; if we now take a vector $x$ solution of the problem, also $x +
z$ is a solution:

$ A (x + z) = y <==> A x + A z = y $

but $A z = 0$ so again we have $A x$ that was a solution. So, since full column
rank matrices have the kernel composed by only the zero vector, there is a
unique solution for the least squares problem.
