#import "@local/note_template:0.1.0": *
#show: doc => note_template([Linear Systems], doc)

#title()

One of the main goal in linear algebra is solve *linear systems* (systems of
linear equations), because many real problems can be formulated in this way.

A linear system can have zero, one (unique) or infinite solutions, but this
depends on many factors that can be brought to light before trying to calculate
a solution.

From a *geometric point of view*, if we think the linear equations of the system
as vectors, the system solution is the intersection point between them, if there
is only one solution. If the system has infinite solutions the intersection will
be an hyper-plane and if there is no solution it means that there is no
intersection.

Let's take for example this linear system

$
  cases(
    x_1 - x_2 = 1,
    x_1 + x_2 = 1
  ) = cases(
    x_2 = x_1 - 1,
    x_2 = 1 - x_1
  )
$

We have a unique solution since we have two variables and two equations, in
particular we have the point $(1, 0)$ where the two equations intersect.

#figure(
  lq.diagram(
    {
      let x = lq.linspace(-0.1, 1.75)
      lq.plot(x, x => x - 1, mark: none, label: [$x_1 - x_2 = 1$])
    },
    {
      let x = lq.linspace(-0.1, 1.75)
      lq.plot(x, x => -x + 1, mark: none, label: [$x_1 + x_2 = 1$])
    },
    lq.scatter((1,), (0,), color: color.green, mark: "o", stroke: color.green),
  ),
  caption: [ Linear Equations Intersection ],
)

A linear system is usually represented in a compact form as matrix-vector
product

$ A x = y $

where $A$ is the coefficients matri, $x$ is the solution vector and $y$ is the
known coefficients vector. We can also say that $A$ is *invertible* if the
system has a unique solution (for example when its columns are basis) and if $A$
is *square*. In that case the solution is given by

$ x = A^(-1) y $

In general we need to invert the $A$ matrix or find other ways to manipulate the
equation, in order to solve the system.

If a matrix $A$ is *lower triangular*, then we can solve $A x = y$ one entry at
a time by *forward substitution*

$
  mat(
    a_(11), 0, 0;
    a_(21), a_(22), 0;
    a_(31), a_(32), a_(33);
  ) vec(x_1, x_2, x_3) = vec(y_1, y_2, y_3) <==>
  cases(
    a_(11) x_1 = y_1,
    a_(21) x_1 + a_(22) x_2 = y_2,
    a_(31) x_1 + a_(32) x_2 + a_(33) x_3 = y_3,
  )
$

With a cost of $cal(O) (n^2)$ if the matrix is already like this, otherwise it's
necessary to transform it by applying Gaussian elimination algorithm (or
equivalent).
