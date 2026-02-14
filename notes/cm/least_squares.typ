= Least Squares
<least-squares>
Some linear system cannot be solved exactly, for example in a system
$A x = y$, where $A$ is not invertible, has $0$ or infinite solutions.

Another case is when the system is #emph[overdetermined];, so that we
need to satisfy more equations than the number of unknow values.

In both cases is possible to find #emph["the best"] possible solution,
that is, the solution that is the #strong[closest] to the wanted
solution.

#quote(block: true)[
\[!EXAMPLE\] We have two foods, each with their own carbohydrates and
protein intakes $ A = mat(delim: "[", 40, 80; 10, 20) $ For our ideal
diet we want a certain amount of carbohydrates and proteins.
$ y = mat(delim: "[", 100; 50) $ So the amount of each food can be found
by solving the following linear system

$ mat(delim: "[", 40, 80; 10, 20) mat(delim: "[", x_1; x_2) = mat(delim: "[", 100; 50) $

Unfortunately $A$ is not invertible and so we can’t have an exact
solution, but we can find the closest $x$ vector, such that
$ parallel A x - y parallel $ is minimized. For the moment let’s take a
solution given by an oracle $ x = mat(delim: "[", 0.5294; 1.0588) $ that
gives us the following vector $A x$
$ A x = mat(delim: "[", 105.882; 26.471) $ As we can see is different
from $y$ but it’s the closest solution we can get.
]

A way to find the best possible $x$ is by solving the #strong[least
squares] problem, that aims to minimize the quadratic distance between
the wanted solution and the one we found.

$ min_x parallel A x - y parallel^2 $

The quadratic distance (or error) is a common choice to get a
#emph[differentiable] function, that can be minimized with
#emph[gradient-based] methods. But for now what we are interested in is
what we can do starting from that formula:

$ parallel A x - y parallel^2 & = (A x - y)^tack.b (A x - y)\
 & = ((A x)^tack.b - y^tack.b) (A x - y)\
 & = (x^tack.b A^tack.b - y^tack.b) (A x - y)\
 & = x^tack.b A^tack.b A x - x^tack.b A^tack.b y - y^tack.b A x + y^tack.b y\
 & = x^tack.b A^tack.b A x - x^tack.b A^tack.b y - (A x)^tack.b y + y^tack.b y\
 & = x^tack.b A^tack.b A x - x^tack.b A^tack.b y - x^tack.b A^tack.b y + y^tack.b y\
 & = x^tack.b A^tack.b A x - 2 angle.l x , A^tack.b y angle.r + angle.l y , y angle.r\
 $

So minimize $parallel A x - y parallel^2$ is equivalent to minimize that
equation. Let’s make one more step that will make sense in a while and
let’s divide everything by $2$, so that the problem becomes

$ min_x 1 / 2 parallel A x - y parallel^2 = min_x (1 / 2 x^tack.b A^tack.b A x - angle.l x , A^tack.b y angle.r + 1 / 2 angle.l y , y angle.r) $

Let now $Q = A^tack.b A$ and $q = - A^tack.b y$, the problem can be
rewritten as

$ min_x 1 / 2 parallel A x - y parallel^2 = min_x (1 / 2 x^tack.b Q x + angle.l q , x angle.r + 1 / 2 angle.l y , y angle.r) $

This problem #strong[has a unique solution] when $Q$ is SPD, but most
important the #strong[gradient] of that equation is

$ Q x + q = A^tack.b A x - A^tack.b y $

To minimize the objective function it’s necessary to let the gradient be
$0$, and so we obtain that

$ A^tack.b A x - A^tack.b y = 0 $

So now we have a strategy to solve the #emph[least squares] problem made
of $3$ key points:

+ Compute $A^tack.b A$
+ Compute $A^tack.b y$
+ Solve $(A^tack.b A) x = A^tack.b y$ (#strong[normal equations];)

We end up with a problem whose solution gives us the closest possible
vector to $y$.

#quote(block: true)[
\[!NOTE\] Theorem The least squares problem
$min_x parallel A x - y parallel^2$ has a unique solution if and only if
$A$ has full column rank.
]

To solve the #emph[normal equations] we need the #strong[pseudoinverse]
of $A$, that is defined as $(A^tack.b A)^(- 1) A^tack.b$, and that let
us generalize the concept of inverse for rectangular (overdetermined)
linear systems.

In this way is possible to solve the system by computing

$ x = (A^tack.b A)^(- 1) A^tack.b y $

or, a more compact form

$ x = A^(+) y $

where $A^(+) = (A^tack.b A)^(- 1) A^tack.b$ is the pseudoinverse of $A$.

== References
<references>
- \[\[computational\_mathematics\]\]
- \[\[eigenvalues\_eigenvectors\]\]
- \[\[pseudoinverse\]\]
- \[\[gradient\_descent\]\]
- \[\[conjugate\_gradient\]\]
