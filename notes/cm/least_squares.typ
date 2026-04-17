#import "@local/note_template:0.1.0": *
#show: doc => note_template([Least Squares], doc)

#title()

Some linear system cannot be solved exactly, for example a system $A x = y$ can
have zero or infinite solutions if $A$ is not invertible.

Another case is when the system is *overdetermined*, so that we need to satisfy
more equations than the number of unknow values.

In both cases is possible to find the _best_ possible solution, that from a
geometrical point of view can be seen as the _closest_ to the desired one.

A way to find the best possible $x$ is by solving the *least squares* problem,
that aims to minimize the quadratic distance between our solution and the
desired one.

$ min_x norm(A x - y)^2 $

The quadratic distance (or error) is a common choice to get a *differentiable*
function, that can be minimized with *gradient-based* methods. But for now what
we are interested in is what we can do starting from that formula:

$
  norm(A x - y)^2 & = (A x - y)^T (A x - y) \
                  & = ((A x)^T - y^T) (A x - y) \
                  & = (x^T A^T - y^T) (A x - y) \
                  & = x^T A^T A x - x^T A^T y - y^T A x + y^T y \
                  & = x^T A^T A x - x^T A^T y - (A x)^T y + y^T y \
                  & = x^T A^T A x - x^T A^T y - x^T A^T y + y^T y \
                  & = x^T A^T A x - 2 x^T A^T y + y^T y
$

So minimize $norm(A x - y)^2$ is equivalent to minimize that equation; actually
is common to solve a slightly different problem:

$
  min_x 1 / 2 norm(A x - y)^2 =
  min_x (1 / 2 x^T A^T A x - x^T A^T y + 1 / 2 y^T y)
$

that if we define $Q = A^T A$ and $q = A^T y$, becomes

$
  min_x 1 / 2 norm(A x - y)^2 =
  min_x (1 / 2 x^T Q x - x^T q + 1 / 2 y^T y)
$

To find the solution we have to compute the gradient of the function above with
respect to $x$:

$ pdv(1 / 2 x^T Q x - x^T q + 1 / 2 y^T y, x) = Q x - q = A^T A x - A^T y $

that we need to set to zero in order to minimize the objective function

$ Q x - q = 0 quad <==> quad A^T A x - A^T y = 0 $

Let's also point out that solving the initial problem embeds the resolution of a
slightly different system $Q x = q$.

= Normal Equations

A common strategy to solve this is by *normal equations* that is a method
consisting in three main points:

+ Compute $A^T A$: we can just compute half of the matrix.
+ Compute $A^T y$: Cholesky factorization.
+ Solve the so called *normal equations* $(A^T A) x = A^T y$

In the first two points everything is known so, aside from computational
optimization, we don't need anything. Instead to solve the _normal equations_ we
need the *pseudoinverse* of $A$, that is defined as $(A^T A)^(- 1)
A^T$, and that let us generalize the concept of inverse for rectangular
(overdetermined) linear systems.

In this way is possible to solve the system by computing

$ x = (A^T A)^(- 1) A^T y $

or, a more compact form

$ x = A^(+) y $

where $A^(+) = (A^T A)^(- 1) A^T$ is the pseudoinverse of $A$.

== Unique Solution

This problem *has a unique solution* when $Q$ is SPD or has full column rank.

#important(title: "Theorem")[
  A matrix $A in RR^(m times n)$ has full column rank if and only if is SPD.
]

In particular if $ker(A) != { 0 }$ it means that there is a vector $z != 0$ such
that $A z = 0$; if we now take a vector $x$ solution of the problem, also $x +
z$ is a solution:

$ A (x + z) = y <==> A x + A z = y $

but $A z = 0$ so again we have $A x$ that was a solution. So, since full column
rank matrices have the kernel composed only by the zero vector, there is a
*unique solution* for the least squares problem.
